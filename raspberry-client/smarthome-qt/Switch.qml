import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
    id: toggleswitch
    width: background.width; height: background.height

    signal toggled(var check, var type)

    readonly property bool checked: state === "on"
    property bool on: false
    property real bgWidth: 60
    property real bgHeight: 30
    property color bgColor: state === "on" ? Style.startColor : "lightgray"
    property color knobColor: "white"
    property color shadowColor: "#7f3d3d3d"
    property string type: ""

    readonly property int minx: background.radius - knob.radius
    readonly property int maxx: background.width - knob.width - minx

    function toggle() {
        if (toggleswitch.state === "on")
            toggleswitch.state = "off";
        else
            toggleswitch.state = "on";

        console.log(type);
        root.cardToggled(checked, type);
        toggled(checked, type);
    }

    function releaseSwitch() {
        if (knob.x == toggleswitch.minx) {
            if (toggleswitch.state === "off") return;
        }
        if (knob.x == toggleswitch.maxx) {
            if (toggleswitch.state === "on") return;
        }
        toggle();
    }

    Rectangle {
        id: background
        width: bgWidth
        height: bgHeight
        radius: Math.min(width, height) * 0.5
        color: toggleswitch.bgColor
        MouseArea { anchors.fill: parent; onClicked: toggle() }
    }

    Text {
        id: txt
        width: knob.width
        height: knob.height
        x: toggleswitch.maxx - width * 0.1
        text: "OFF"
        color: "white"
        anchors.verticalCenter: background.verticalCenter
        font.bold: true
        font.pixelSize: width * 0.47
        verticalAlignment: Text.AlignVCenter
        visible: true
    }

    Rectangle {
        id: knob
        width: background.width * 0.4
        height: background.height * 0.8
        radius: Math.min(width, height) * 0.5
        x: toggleswitch.minx
        color: toggleswitch.knobColor
        anchors.verticalCenter: background.verticalCenter

        MouseArea {
            anchors.fill: parent
            drag.target: knob; drag.axis: Drag.XAxis; drag.minimumX: toggleswitch.minx; drag.maximumX: toggleswitch.maxx
            onClicked: toggle()
            onReleased: releaseSwitch()
        }

        layer {
            enabled: true
            effect: DropShadow {
                horizontalOffset: 1
                verticalOffset: 1
                radius: 8
                samples: radius * 2
                source: knob
                color: toggleswitch.shadowColor
                transparentBorder: true
            }
        }
    }

    states: [
        State {
            name: "on"
            PropertyChanges { target: knob; x: toggleswitch.maxx }
            PropertyChanges { target: toggleswitch; on: true }
            PropertyChanges { target: txt; x: toggleswitch.minx + txt.width * 0.3 }
            PropertyChanges { target: txt; text: "ON" }
        },
        State {
            name: "off"
            PropertyChanges { target: knob; x: toggleswitch.minx }
            PropertyChanges { target: toggleswitch; on: false }
            PropertyChanges { target: txt; x: toggleswitch.maxx - txt.width * 0.1 }
            PropertyChanges { target: txt; text: "OFF" }
        }
    ]

    transitions: Transition {
        NumberAnimation { properties: "x"; easing.type: Easing.InOutQuad; duration: 200 }
    }
}
