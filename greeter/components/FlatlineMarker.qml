import QtQuick

// Replaces the old Watch Dogs "tesseract" glyph. A blinking red square,
// closer to Cyberpunk 2077's "FLATLINED" glitch flash than a static icon.
Rectangle {
    id: root

    color: "#F24848"

    SequentialAnimation on opacity {
        loops: Animation.Infinite

        NumberAnimation { to: 0.12; duration: 90; easing.type: Easing.InOutQuad }
        NumberAnimation { to: 1; duration: 70; easing.type: Easing.InOutQuad }
        PauseAnimation { duration: 90 }
        NumberAnimation { to: 0.12; duration: 60; easing.type: Easing.InOutQuad }
        NumberAnimation { to: 1; duration: 140; easing.type: Easing.InOutQuad }
        PauseAnimation { duration: 700 }
    }
}
