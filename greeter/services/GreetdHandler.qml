pragma Singleton

import Quickshell
import Quickshell.Io
import Quickshell.Services.Greetd
import QtQuick

import qs.greeter.services
import qs.common

Singleton {
    id: handler

    signal ready
    signal success
    signal failed

    Logger {
        id: logger
        name: "Greetd"
    }

    Connections {
        id: connection
        target: Greetd

        function onAuthMessage(message) {
            // requesting password
            logger.info("Credentials requested.");
            handler.ready();
        }

        function onAuthFailure(message) {
            // password is wrong
            logger.info("Authentication failed.");
            handler.failed();
        }

        function onReadyToLaunch() {
            // password is correct
            logger.info("Authentication success.");
            handler.success();
        }
    }

    Connections {
        target: SessionManager

        function onActiveUserChanged() {
            if (Greetd.state === GreetdState.Authenticating) {
                logger.info(`User changed, cancelling active session.`);
                Greetd.cancelSession();
            }

            handler.start();
        }
    }

    function start() {
        sessionStarter.start();
    }

    Timer {
        id: sessionStarter
        interval: 200
        repeat: true
        onTriggered: {
            // make sure socket ready for new session
            // authenticating(1) -> inactive (0)
            if (Greetd.state !== GreetdState.Inactive) {
                return;
            }

            logger.info(`Created session (user:${SessionManager.activeUser.uid}:${SessionManager.activeUser.username})`);
            Greetd.createSession(SessionManager.activeUser.username);

            sessionStarter.stop();
        }
    }

    function respond(password) {
        if (Greetd.available) {
            Greetd.respond(password);
        } else {
            logger.debug("Failed to respond, Not available.");
        }
    }

    // Runs the exit command (e.g. "uwsm stop") and only calls
    // Greetd.launch() once it has actually finished, instead of firing
    // Greetd.launch() and Quickshell.execDetached(exitCommand) almost
    // simultaneously (the previous behaviour) -- that raced the greeter's
    // own compositor teardown against the new session's startup and
    // intermittently lost: confirmed via journalctl showing
    // "uwsm: A compositor or graphical-session* target is already
    // active!" right before the login bounced back to the greeter,
    // meaning the new `uwsm start` saw the outgoing greeter's systemd
    // session target still marked active.
    //
    // `doLaunch()` is guarded by `launchedThisSession` so it only ever
    // actually calls Greetd.launch() once, no matter which of the two
    // paths below triggers it first:
    //   - exitProcess.onExited (the normal, fast path)
    //   - launchSafetyTimer (a fallback in case the exit command hangs
    //     or never fires onExited for any reason -- without this, a
    //     stuck exit command would leave the login silently frozen
    //     forever instead of just landing back on the old racy-but-
    //     working behaviour)
    property var pendingLaunchCommand: []
    property bool launchedThisSession: false

    function doLaunch() {
        if (handler.launchedThisSession) {
            return;
        }
        handler.launchedThisSession = true;
        launchSafetyTimer.stop();
        Greetd.launch(handler.pendingLaunchCommand);
    }

    Process {
        id: exitProcess
        onExited: exitCode => {
            logger.info(`Greeter exit command finished (code ${exitCode}).`);
            handler.doLaunch();
        }
    }

    Timer {
        id: launchSafetyTimer
        interval: 4000
        repeat: false
        onTriggered: {
            logger.debug("Exit command didn't finish in time, launching anyway.");
            handler.doLaunch();
        }
    }

    function finish() {
        const launchCommand = SessionManager.getLaunchCommand();
        const exitCommand = SessionManager.getExitCommand();

        logger.info(`Exiting Greeter: ${exitCommand.join(" ") || "<none>"}`);
        logger.info(`Launching: ${launchCommand.join(" ")}`);

        handler.pendingLaunchCommand = launchCommand;
        handler.launchedThisSession = false;

        if (exitCommand.length) {
            exitProcess.command = exitCommand;
            exitProcess.running = true;
            launchSafetyTimer.start();
        } else {
            handler.doLaunch();
        }
    }
}
