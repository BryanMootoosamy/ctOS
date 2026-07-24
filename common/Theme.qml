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
    // First patch pass used wh0 (#898D99) here -- still just a different
    // shade of gray, missing the point: cybrdots' actual dominant
    // structural accent across the rest of the rice (panel borders,
    // headers) is RED, not any neutral gray/white tone. Fixed to re0.
    readonly property color gray200: "#F24848"          // was #D9D9D9 (Watch Dogs), then #898D99 (still gray) — now cybrdots re0, matching the panels' own dominant-red borders/headers
    readonly property color gray300: "#c3c3c3"          // unchanged
    readonly property color gray500: "#7a7a7a"
    readonly property color gray800: "#030408"          // was #0E0E0E — now cybrdots no0

    // Second patch pass (cyberdesk-2077 panels/): accentGreen was still
    // the original Watch Dogs green (#1bfd9c), unused anywhere in ctOS
    // (confirmed: grep turns up nothing outside this file) but a real
    // divergence from cybrdots per vars.conf being the source of truth.
    // Fixed to the real gr0. Added accentOrange/accentYellow, both
    // needed for the desktop panels' fuller "ok/warn/critical" states
    // (the greeter itself only ever needed cyan/red -- see success/
    // error below, untouched).
    readonly property color accentGreen: "#30F291"      // cybrdots gr0 (was Watch Dogs' #1bfd9c, unused, now correct)
    readonly property color accentCyan: "#29BECC"       // cybrdots cy0 — password-correct feedback
    readonly property color accentRed: "#F24848"        // was #fc3e38 — now cybrdots re0, password-error feedback
    readonly property color accentOrange: "#F26118"     // cybrdots or0
    readonly property color accentYellow: "#F2D230"     // cybrdots ye0

    // SECTION Theme

    readonly property color background: gray800
    // Referenced by greeter/components/Session.qml (the username strip
    // background) but was never actually defined anywhere in this file --
    // rendered as a flat gray fallback box. Reuses surfaceAlt (cybrdots
    // no2), the same "brighter than base background" tone already used
    // for card/strip backgrounds elsewhere.
    readonly property color backgroundBright: surfaceAlt

    // cybrdots no1/no2 -- slightly lighter than no0/background, used
    // for title-bar strips and card backgrounds throughout the rice
    // (waybar's no1/no2, the panels' own win-title bars). Added for
    // the desktop panels; the greeter itself only ever used no0.
    readonly property color surface: "#05070D"    // cybrdots no1
    readonly property color surfaceAlt: "#0A0E1A" // cybrdots no2

    readonly property color ctosGray: gray200

    readonly property color textPrimary: gray50
    readonly property color textPrimaryDim: gray100
    readonly property color textPrimaryDimmer: gray300

    readonly property color textSecondary: gray500
    readonly property color secondary: gray500

    readonly property color textAccent: accentCyan

    readonly property color success: accentCyan         // <- password field turns cyan on correct entry
    readonly property color error: accentRed             // <- password field turns cybrdots red on wrong entry

    // Desktop panels' state semantic (separate from the greeter's own
    // success/error above, which must stay cyan/red -- PasswordField
    // reads them directly). Matches cybrdots' own usage elsewhere in
    // the rice: green = ok/good, orange = warning, red = critical.
    readonly property color ok: accentGreen
    readonly property color warn: accentOrange
    readonly property color critical: accentRed

    // SECTION Fonts
    property string fontFamily: "JetBrainsMono Nerd Font"
}
