import QtQuick 2.11
import QtQuick.Shapes 1.11
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0
// https://github.com/arunpkqt/RadialBarDemo/blob/master/RadialBarShape.qml

Rectangle {
    id: radialBar
    color: "transparent"

    implicitWidth: 200
    implicitHeight: 200
    radius: parent.width * 0.5

/* ring test
    property real startAngle: 40
    property real spanAngle: 280
    property real minValue: 0
    property real maxValue: 100
    property real value: 30
    readonly property real valueGap: maxValue - minValue
    readonly property real valueRate: ((0 - minValue) + value) / valueGap
    readonly property int dialWidth: width * 0.8
    property color progressColor: "#ffa51bab"

    property color backgroundColor: "transparent"
    property color dialColor: "#ff808080"

    property int penStyle: Qt.RoundCap
    property int dialType: RadialBar.DialType.MinToMax


    Ring {
        id: outerRing
        z: 0
        color: "white"
        border.color: "lightgray"
        border.width: control.dialWidth
    }

    Ring {
        id: innerRing
        z: 1
        radius: outerRing.radius
        border.color: "lightblue"

        Text {
            anchors.centerIn: parent
            text: innerRing.value
        }
    }
*/
    enum DialType {
        FullDial,
        MinToMax,
        NoDial
    }

    property real startAngle: 40
    property real spanAngle: 280
    property real minValue: -20
    property real maxValue: 60
    property real value: 0
    property real valueGap: maxValue - minValue
    property real valueRate: (value - minValue) / valueGap
    property int dialWidth: width * 0.055

    property color backgroundColor: "transparent"
    property color dialColor: "#1f404040"
    property color progressColor: "#ffa51bab"
    property color shadowColor: "#7fffffff"

    property int penStyle: Qt.RoundCap
    property int dialType: RadialBar.DialType.MinToMax

//    property string iconSource: "images/fire.png"
//    property string status: "hot"

    QtObject {
        id: internals

        property bool isFullDial: radialBar.dialType === RadialBar.DialType.FullDial
        property bool isNoDial: radialBar.dialType === RadialBar.DialType.NoDial

        property real baseRadius: Math.min(radialBar.width, radialBar.height) * 0.48
        property real radiusOffset: internals.isFullDial ? radialBar.dialWidth * 0.5
                                                         : radialBar.dialWidth * 0.5
        property real actualSpanAngle: internals.isFullDial? 360: radialBar.spanAngle

        property color transparentColor: "transparent"
        property color dialColor: internals.isNoDial ? internals.transparentColor
                                                     : radialBar.dialColor
    }

    Shape {
        id: shape
        anchors.fill: parent
        layer.enabled: true
        layer.samples: 8

        ShapePath {
            id: pathBackground
            strokeColor: internals.transparentColor
            fillColor: "transparent"
            capStyle: radialBar.penStyle

            PathAngleArc {
                radiusX: internals.baseRadius - radialBar.dialWidth
                radiusY: internals.baseRadius - radialBar.dialWidth
                centerX: radialBar.width * 0.5
                centerY: radialBar.height * 0.5
                startAngle: 0
                sweepAngle: 360
            }
        }

        ShapePath {
            id: pathDial
            strokeColor: radialBar.dialColor
            fillColor: internals.transparentColor
            strokeWidth: radialBar.dialWidth
            capStyle: radialBar.penStyle

            PathAngleArc {
                radiusX: internals.baseRadius - internals.radiusOffset
                radiusY: internals.baseRadius - internals.radiusOffset
                centerX: radialBar.width * 0.5
                centerY: radialBar.height * 0.5
                startAngle: radialBar.startAngle - 270
                sweepAngle: internals.actualSpanAngle
            }
        }

        ShapePath {
            id: pathProgress
            strokeColor: radialBar.progressColor
            fillColor: internals.transparentColor
            strokeWidth: radialBar.dialWidth
            capStyle: radialBar.penStyle

            PathAngleArc {
                radiusX: internals.baseRadius - internals.radiusOffset
                radiusY: internals.baseRadius - internals.radiusOffset
                centerX: radialBar.width * 0.5
                centerY: radialBar.height * 0.5
                startAngle: radialBar.startAngle - 270
                sweepAngle: (internals.actualSpanAngle / (radialBar.maxValue - radialBar.minValue) * ((0 - radialBar.minValue) + radialBar.value))
            }
        }
    }
    Text {
        anchors.centerIn: parent
        text: radialBar.value.toFixed().toString() + "℃"
        color: radialBar.progressColor
        font.bold: true
        font.pixelSize: radialBar.width * 0.2
    }

//    Rectangle {
//        anchors.bottom: parent.bottom
//        anchors.horizontalCenter: parent.horizontalCenter
//        Image {
//            id: icon
//            anchors.left: parent.left
//            width: 50
//            height: 50
//            source: radialBar.iconSource
//        }
//        Text {
//            anchors.left: icon.right
//            text: radialBar.status
//            font.pixelSize: 20
//        }
//    }


    layer {
        enabled: true
        effect: DropShadow {
            radius: 8
            samples: radius * 2
            source: radialBar
            color: radialBar.shadowColor
            transparentBorder: true
        }
    }
}
