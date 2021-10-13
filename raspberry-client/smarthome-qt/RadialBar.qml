import QtQuick 2.11
import QtQuick.Shapes 1.12
// https://github.com/arunpkqt/RadialBarDemo/blob/master/RadialBarShape.qml

Item {
    id: radialBar

    implicitWidth: 300
    implicitHeight: 300

    enum DialType {
        FullDial,
        MinToMax,
        NoDial
    }

    property real startAngle: 40
    property real spanAngle: 320
    property real minValue: -20
    property real maxValue: 60
    property real value: 0
    property int dialWidth: 15

    property color backgroundColor: "transparent"
    property color dialColor: "#ff808080"
    property color progressColor: "#ffa51bab"

    property int penStyle: Qt.RoundCap
    property int dialType: 1

    QtObject {
        id: internals

        property bool isFullDial: radialBar.dialType === 0
        property bool isNoDial: radialBar.dialType === 2

        property real baseRadius: Math.min(radialBar.width * 0.5, radialBar.height * 0.5)
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
            fillColor: radialBar.backgroundColor
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
                sweepAngle: (internals.actualSpanAngle / radialBar.maxValue * radialBar.value)
            }
        }
    }
}
