import QtQuick 2.0
import QtGraphicalEffects 1.0


Rectangle {
    id: ring

    property bool circle: true

    property real currentValue: 50
    property real minValue: 0
    property real maxValue: 100

    property real startAngle: 0
    property real endAngle: 360
    property color startColor: "white"
    property color endColor: "lightblue"

    readonly property real value: (currentValue - minValue) / (maxValue - minValue)
    readonly property real startValue: startAngle / 360.0
    readonly property real endValue: endAngle / 360.0

    readonly property real handleRadius: (width + border.width) * 0.5
    readonly property real deg2rad: Math.PI * value * 2

    readonly property color emptyColor: "transparent"

    anchors.fill: parent
    radius: Math.max(width, height) * 0.5
    color: "transparent"
    border.color: "darkgray"
    border.width: 2

    Rectangle {
        id: handle
        width: ring.border.width * 5
        height: width
        radius: width * 0.5
        color: ring.circle ? ring.endColor : "transparent"
        x: ring.handleRadius - radius
        y: -radius

        layer {
            enabled: true
            effect: DropShadow {
                horizontalOffset: 3
                verticalOffset: 3
                radius: 8
                samples: radius * 2
                source: handle
                color: Qt.rgba(0, 0, 0, 0.5)
                transparentBorder: true
            }
        }
    }

    Rectangle {
        id: tail
        width: ring.border.width
        height: width
        radius: width * 0.5
        color: "red"//ring.circle ? ring.endColor : "transparent"
        x: ring.radius - radius - Math.cos(deg2rad * -40) * handleRadius
        y: ring.radius - radius - Math.sin(deg2rad * -40) * handleRadius
    }

    ConicalGradient {
        source: ring
        anchors.fill: parent
        angle: 0.0
        gradient: Gradient {
            GradientStop { position: 0.0; color: ring.emptyColor }
            GradientStop { position: ring.startValue - 0.01; color: ring.emptyColor }
            GradientStop { position: ring.startValue; color: ring.startColor }
            GradientStop { position: ring.endValue; color: ring.endColor }
            GradientStop { position: ring.endValue + 0.01; color: ring.emptyColor }
            GradientStop { position: 1.0; color: ring.emptyColor }
        }
    }

    function setValue(val) {

    }

    function setHandlePosition(degree) {
        [handle.x, handle.y] = calcHandlePosition(degree, handle.radius)
        handle.x -= handle.radius
        handle.y -= handle.radius
    }

    function calcHandlePosition(degree, radius) {
        let radian = degree * deg2rad;
        x = ring.radius - radius - Math.sin(radian) * handleRadius;
        y = ring.radius - radius - Math.cos(radian) * handleRadius;
        return [x, y]
    }
}
