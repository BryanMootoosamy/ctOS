pragma Singleton

import QtQuick
import Quickshell

// ============================================================
// CYBR RICE — cybrdots palette patch for TSM-061/ctOS
// Original: common/Theme.qml (Watch Dogs green, #1bfd9c)
//
// Scoped patch — only two things change:
//   1. Background -> real cybrdots no0 (#030408)
//   2. Password field feedback color (greeter/components/
//      FieldGroup.qml, PasswordField.color) -> cyan on success,
//      cybrdots red on failure. Confirmed in the real code:
//      Theme.success drives PasswordField.color on
//      AuthManager.State.Success/Finish, Theme.error drives it
//      on State.Failed.
//
// Everything else (ctosGray, window border colors — those live
// in hyprland.lua, not here, and are left at cybrdots' own
// defaults) is UNCHANGED from upstream. This is deliberately not
// a full reskin.
//
// This is NOT copied at install time. Per chapter 6 of the
// course: paste this over vendor/ctOS/common/Theme.qml INSIDE
// your own fork, then git add / commit / push before adding it
// as a submodule. install.sh never touches this file.
//
// Property NAMES are kept identical to the upstream file on
// purpose — every component in greeter/ and bar/ references
// Theme.ctosGray, Theme.success, etc. Renaming them would mean
// touching every file that imports qs.common. Only the VALUES
// of background/success/error change here.
// ============================================================

Singleton {

    // SECTION Primitives

    readonly property color gray50: "#ffffff"
    readonly property color gray100: "#CACACA"
    readonly property color gray200: "#D9D9D9"          // unchanged — this drives borders/structural elements throughout the greeter
    readonly property color gray300: "#c3c3c3"          // unchanged
    readonly property color gray500: "#7a7a7a"
    readonly property color gray800: "#030408"          // was #0E0E0E — now cybrdots no0

    readonly property color accentGreen: "#1bfd9c"      // unchanged, kept for anything still referencing it
    readonly property color accentCyan: "#29BECC"       // cybrdots cy0 — password-correct feedback
    readonly property color accentRed: "#F24848"        // was #fc3e38 — now cybrdots re0, password-error feedback

    // SECTION Theme

    readonly property color background: gray800

    readonly property color ctosGray: gray200

    readonly property color textPrimary: gray50
    readonly property color textPrimaryDim: gray100
    readonly property color textPrimaryDimmer: gray300

    readonly property color textSecondary: gray500
    readonly property color secondary: gray500

    readonly property color textAccent: accentCyan

    readonly property color success: accentCyan         // <- password field turns cyan on correct entry
    readonly property color error: accentRed             // <- password field turns cybrdots red on wrong entry

    // SECTION Fonts
    property string fontFamily: "JetBrainsMono Nerd Font"
}
