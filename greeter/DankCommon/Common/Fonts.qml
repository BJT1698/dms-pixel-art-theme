pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell

Singleton {
    readonly property string sans: silkscreenFont.name || "Silkscreen"
    readonly property string mono: monocraftFont.name || "Monocraft"
    readonly property string icons: materialSymbolsFont.name || "Material Symbols Rounded"
    readonly property string nerd: monocraftFont.name || "Monocraft"

    FontLoader {
        id: silkscreenFont
        source: Qt.resolvedUrl("../assets/fonts/pixel-art/Silkscreen-Regular.ttf")
    }

    FontLoader {
        id: monocraftFont
        source: Qt.resolvedUrl("../assets/fonts/pixel-art/Monocraft.otf")
    }

    FontLoader {
        id: materialSymbolsFont
        source: Qt.resolvedUrl("../assets/fonts/material-design-icons/variablefont/MaterialSymbolsRounded[FILL,GRAD,opsz,wght].ttf")
    }
}
