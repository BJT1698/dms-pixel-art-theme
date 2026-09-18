pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Effects
import qs.DankCommon.Common

Item {
    id: root

    property string name: ""
    property real size: 16
    property color color: Style.surfaceText
    property bool filled: false
    property real fill: filled ? 1.0 : 0.0
    property int grade: Style.isLightMode ? 0 : -25
    property int weight: filled ? 500 : 400
    property real weightAnim: weight
    readonly property int weightStep: Math.round(weightAnim / 25) * 25
    readonly property real fillStep: Math.round(fill * 4) / 4
    property bool smoothTransform: false

    implicitWidth: effectiveIconSize
    implicitHeight: effectiveIconSize

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
            "calendar_today": "calendar_today",
            "calendar_month": "calendar_month",
            "event": "calendar_today",
            "music_note": "music_note",
            "music_off": "music_off",
            "image": "image",
            "wallpaper": "wallpaper",
            "wb_sunny": "wb_sunny",
            "weather": "wb_sunny",
            "clear_day": "wb_sunny",
            "clear_night": "nightlight",
            "partly_cloudy_day": "wb_sunny",
            "partly_cloudy_night": "nightlight",
            "foggy": "cloud",
            "rainy": "cloud",
            "cloudy_snowing": "cloud",
            "snowing_heavy": "cloud",
            "thunderstorm": "cloud",
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
            "battery_6_bar": "battery_6_bar",
            "battery_5_bar": "battery_5_bar",
            "battery_4_bar": "battery_4_bar",
            "battery_3_bar": "battery_3_bar",
            "battery_2_bar": "battery_2_bar",
            "battery_1_bar": "battery_1_bar",
            "battery_alert": "battery_alert",
            "battery_horiz_075": "battery_horiz_075",
            "battery_std": "battery_std",
            "battery_charging_full": "battery_charging_full",
            "battery_charging_90": "battery_charging_90",
            "battery_charging_80": "battery_charging_80",
            "battery_charging_60": "battery_charging_60",
            "battery_charging_50": "battery_charging_50",
            "battery_charging_30": "battery_charging_30",
            "battery_charging_20": "battery_charging_20",
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
            "cpu": "memory",
            "developer_board": "memory",
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
            "cloud": "cloud",
            "sports_esports": "sports_esports",
            "vpn_lock": "vpn_lock",
            "vpn_key_off": "vpn_key_off",
            "camera_video": "camera_video",
            "screen_share": "screen_share",
            "screen_record": "screen_record",
            "network_check": "network_check",
            "print": "print",
            "do_not_disturb_on": "do_not_disturb_on",
            "motion_sensor_active": "motion_sensor_active",
            "hidden_horizontal": "hidden_horizontal",
            "hidden_vertical": "hidden_vertical"
        };
        return map[n] || n;
    }

    readonly property int effectiveIconSize: {
        const s = Math.round(root.size);
        if (s >= 32) return 32;
        if (s >= 24) return 24;
        return 16;
    }

    readonly property string pixelIconSource: mappedIconName ? Qt.resolvedUrl("../assets/pixel-icons/" + mappedIconName + ".svg") : ""
    readonly property bool isPixelIconReady: pixelImage.status === Image.Ready

    Image {
        id: pixelImage
        anchors.centerIn: parent
        width: root.effectiveIconSize
        height: root.effectiveIconSize
        source: root.pixelIconSource
        sourceSize.width: root.effectiveIconSize >= 24 ? 24 : 16
        sourceSize.height: root.effectiveIconSize >= 24 ? 24 : 16
        fillMode: Image.PreserveAspectFit
        smooth: false
        mipmap: false
        asynchronous: false
        visible: status === Image.Ready

        layer.enabled: true
        layer.smooth: false
        layer.mipmap: false
        layer.effect: MultiEffect {
            autoPaddingEnabled: false
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
        renderType: Text.NativeRendering
        antialiasing: false
        smooth: false

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
