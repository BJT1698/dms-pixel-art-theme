pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Effects
import qs.DankCommon.Common

Item {
    id: root

    property string name: ""
    property real size: Style.fontSizeMedium
    property color color: Style.surfaceText
    property bool filled: false
    property real fill: filled ? 1.0 : 0.0
    property int grade: Style.isLightMode ? 0 : -25
    property int weight: filled ? 500 : 400
    property real weightAnim: weight
    readonly property int weightStep: Math.round(weightAnim / 25) * 25
    readonly property real fillStep: Math.round(fill * 4) / 4
    property bool smoothTransform: false

    implicitWidth: Math.round(size)
    implicitHeight: Math.round(size)

    signal rotationCompleted

    readonly property string mappedIconName: {
        const n = (root.name || "").trim();
        if (!n) return "";
        const map = {
            "dashboard": "dashboard",
            "grid_view": "grid_view",
            "space_dashboard": "space_dashboard",
            "overview": "overview",
            "apps": "apps",
            "music_note": "music_note",
            "music_off": "music_off",
            "image": "image",
            "wallpaper": "wallpaper",
            "wb_sunny": "wb_sunny",
            "light_mode": "light_mode",
            "dark_mode": "dark_mode",
            "nightlight": "nightlight",
            "bedtime": "bedtime",
            "settings": "settings",
            "tune": "tune",
            "display_settings": "display_settings",
            "wifi": "wifi",
            "network_wifi": "wifi",
            "wifi_off": "wifi_off",
            "bluetooth": "bluetooth",
            "bluetooth_connected": "bluetooth_connected",
            "bluetooth_disabled": "bluetooth_disabled",
            "battery_full": "battery_full",
            "battery_5_bar": "battery_5_bar",
            "battery_horiz_075": "battery_horiz_075",
            "battery_std": "battery_std",
            "battery_charging_full": "battery_charging_full",
            "volume_up": "volume_up",
            "volume_down": "volume_down",
            "volume_off": "volume_off",
            "volume_mute": "volume_mute",
            "speaker": "speaker",
            "mic": "mic",
            "mic_off": "mic_off",
            "notifications": "notifications",
            "notifications_active": "notifications_active",
            "notifications_none": "notifications_none",
            "notifications_off": "notifications_off",
            "power": "power",
            "power_settings_new": "power_settings_new",
            "lock": "lock",
            "content_copy": "content_copy",
            "content_paste": "content_paste",
            "assignment": "assignment",
            "cpu": "cpu",
            "developer_board": "developer_board",
            "memory": "memory",
            "search": "search",
            "close": "close",
            "check": "check",
            "check_circle": "check_circle",
            "verified": "verified",
            "arrow_back": "arrow_back",
            "arrow_forward": "arrow_forward",
            "chevron_left": "chevron_left",
            "chevron_right": "chevron_right",
            "expand_more": "expand_more",
            "expand_less": "expand_less",
            "folder": "folder",
            "folder_open": "folder_open",
            "home": "home",
            "play_arrow": "play_arrow",
            "pause": "pause",
            "delete": "delete",
            "delete_forever": "delete_forever",
            "refresh": "refresh",
            "sync": "sync",
            "restart_alt": "restart_alt",
            "palette": "palette",
            "edit": "edit",
            "brightness_high": "brightness_high",
            "brightness_6": "brightness_6",
            "keyboard": "keyboard",
            "terminal": "terminal",
            "monitor": "monitor",
            "cloud": "cloud"
        };
        return map[n] || n;
    }

    readonly property string pixelIconSource: mappedIconName ? Qt.resolvedUrl("../assets/pixel-icons/" + mappedIconName + ".svg") : ""
    readonly property bool isPixelIconReady: pixelImage.status === Image.Ready

    Image {
        id: pixelImage
        anchors.centerIn: parent
        width: Math.round(root.size)
        height: Math.round(root.size)
        source: root.pixelIconSource
        sourceSize.width: Math.round(root.size) * 2
        sourceSize.height: Math.round(root.size) * 2
        fillMode: Image.PreserveAspectFit
        smooth: false
        mipmap: false
        asynchronous: false
        visible: status === Image.Ready

        layer.enabled: true
        layer.smooth: false
        layer.mipmap: false
        layer.effect: MultiEffect {
            colorization: 1.0
            colorizationColor: root.color
        }
    }

    StyledText {
        id: fallbackIcon
        anchors.centerIn: parent
        visible: !root.isPixelIconReady
        text: root.name

        font.family: Fonts.icons
        font.pixelSize: Math.round(root.size)
        font.weight: root.weightStep
        font.hintingPreference: Font.PreferNoHinting
        color: root.color
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        renderType: root.smoothTransform ? Text.QtRendering : Text.NativeRendering

        font.variableAxes: {
            "FILL": root.fillStep,
            "GRAD": root.grade,
            "opsz": 24,
            "wght": root.weightStep
        }
    }

    Behavior on weightAnim {
        NumberAnimation {
            duration: Style.shortDuration
            easing.type: Style.standardEasing
        }
    }

    Behavior on fill {
        NumberAnimation {
            duration: Style.shortDuration
            easing.type: Style.standardEasing
        }
    }

    Timer {
        id: rotationTimer
        interval: 16
        repeat: false
        onTriggered: root.rotationCompleted()
    }

    onRotationChanged: {
        rotationTimer.restart();
    }
}
