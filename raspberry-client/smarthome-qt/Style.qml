pragma Singleton
import QtQuick 2.0

QtObject {
    readonly property int light: 0
    readonly property int normal: 1
    readonly property int dark: 2

    function fontColor(type, brightness) {
        switch (type)
        {
        case "secure":
            return "white";
        default:
            return brightness < dark ? "white" : "black";
        }
    }

    function backgroundColor(type, brightness) {
        switch (type)
        {
        case "home":
            return brightness === light   ? homeLightColor :
                   brightness === normal  ? homeColor
                                          : homeDarkColor;
        case "led":
            return brightness === light   ? ledLightColor :
                   brightness === normal  ? ledColor
                                          : ledDarkColor;
        case "aircon":
            return brightness === light   ? airconLightColor :
                   brightness === normal  ? airconColor
                                          : airconDarkColor;
        case "secure":
            return brightness === light   ? secureLightColor :
                   brightness === normal  ? secureColor
                                          : secureDarkColor;
        case "warning":
            return brightness === light   ? warningLightColor :
                   brightness === normal  ? warningColor
                                          : warningDarkColor;
        default:
            return "white";
        }
    }
    // home color
    readonly property color homeColor: "#ff2ecc71"
    readonly property color homeLightColor: "#ff6effa0"
    readonly property color homeDarkColor: "#ff009a44"

    // led color
    readonly property color ledColor: "#fff1c40f"
    readonly property color ledLightColor: "#fffff653"
    readonly property color ledDarkColor: "#ffba9400"

    // aircon color
    readonly property color airconColor: "#ff3498db"
    readonly property color airconLightColor: "#ff73c9ff"
    readonly property color airconDarkColor: "#ff006aa9"

    // secure color
    readonly property color secureColor: "#ff34495e"
    readonly property color secureLightColor: "#ff60748b"
    readonly property color secureDarkColor: "#ff092234"

    // warning color
    readonly property color warningColor: "#ffe74c3c"
    readonly property color warningLightColor: "#ffff7f67"
    readonly property color warningDarkColor: "#ffae0c13"

    // gradient color
    readonly property color startColor: "#ffff4576"
    readonly property color endColor: "#ffffa45a"

    readonly property color normalColor: "#7fdddddd"
    readonly property color shadowColor: "#7fffffff"
}
