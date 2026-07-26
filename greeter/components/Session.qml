import QtQuick
import QtQuick.Layouts

import qs.common
import qs.greeter.components
import qs.greeter.services

RowLayout {
    spacing: 0
    ColumnLayout {
        id: code
        Layout.alignment: Qt.AlignTop

        RowLayout {
            spacing: 0
            Rectangle {
                color: Theme.ctosGray
                height: 56 * Units.vh
                width: height

                // Simple reticle mark, replacing the old Blume Corp hex
                // logo -- dark-on-red like the barcode strip below it.
                Item {
                    anchors.fill: parent
                    anchors.margins: 6 * Units.vh

                    Rectangle {
                        anchors.fill: parent
                        color: "transparent"
                        border.color: Theme.background
                        border.width: 3
                    }
                    Rectangle {
                        anchors.centerIn: parent
                        width: parent.width * 0.22
                        height: width
                        color: Theme.background
                    }
                }
            }

            ColumnLayout {
                Layout.preferredWidth: 150 * Units.vh

                spacing: 0

                Rectangle {
                    color: Theme.backgroundBright
                    Layout.fillWidth: true
                    Layout.preferredHeight: 28 * Units.vh

                    RowLayout {
                        anchors {
                            fill: parent
                            leftMargin: 10 * Units.vh
                            rightMargin: 10 * Units.vh
                        }

                        Typewriter {
                            id: typewriter
                            color: Theme.textPrimary
                            initialText: ""
                            font.family: Theme.fontFamily
                            font.pixelSize: 14
                        }

                        Item {
                            Layout.fillWidth: true
                        }

                        FlatlineMarker {
                            Layout.preferredWidth: 15 * Units.vh
                            Layout.preferredHeight: width
                        }
                    }
                }

                Rectangle {
                    id: barcode

                    Layout.preferredHeight: 28 * Units.vh
                    Layout.fillWidth: true
                    color: Theme.ctosGray

                    Image {
                        anchors.fill: parent
                        anchors.margins: 5 * Units.vh
                        fillMode: Image.PreserveAspectFit
                        source: "../resources/user-barcode.svg"
                    }
                }
            }
        }
    }

    Rectangle {
        id: picture

        color: Theme.secondary
        height: 75 * Units.vh
        width: height

        Image {
            id: avatar

            // Real profile picture support: the standard `~/.face` convention
            // used by LightDM/GDM/SDDM (a plain image file, no extension) --
            // there was previously no way to set this at all, just a
            // hardcoded placeholder. Falls back to that same placeholder if
            // `.face` doesn't exist or fails to load, never left blank.
            source: SessionManager.activeUser
                ? "file://" + SessionManager.activeUser.homeDir + "/.face"
                : "../resources/user.svg"
            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop
            asynchronous: true

            onStatusChanged: {
                if (status === Image.Error) {
                    source = "../resources/user.svg";
                }
            }
        }
    }

    Connections {
        target: SessionManager
        function onActiveUserChanged() {
            typewriter.overwrite(SessionManager.activeUser.username.toUpperCase());
        }
    }
}
