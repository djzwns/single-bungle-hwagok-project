import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0

Rectangle {
    property string text: "Sample"
    property string value: ""
    property color bgColor: "lightblue"
    property string type: ""
    property bool pointView: false
    property real switchWidth: 60
    property real switchHeight: 30

    id: card
    width: 150
    height: width * 0.7
    radius: Math.min(width, height) * 0.2
    color: bgColor

    //implicitHeight: 60

    ColumnLayout {
        id: contentLayout
        anchors.fill: parent
        anchors.margins: 8
        spacing: 5

        Text {
            id: title

            font.pixelSize: 12
            font.bold: true

            text: card.text
            color: "#7f202020"
            Layout.alignment: Qt.AlignLeft
        }

        Text {
            id: sub

            font.pixelSize: title.font.pixelSize * 1.4
            font.bold: true

            text: card.value
            color: Style.startColor
            Layout.alignment: Qt.AlignRight
        }

        Rectangle {
            id: point

            width: sub.font.pixelSize * 0.6
            height: width
            anchors.right: sub.left
            anchors.rightMargin: 4
            anchors.verticalCenter: sub.verticalCenter
            radius: Math.min(width, height) * 0.5
            visible: card.pointView
            color: {
                let val = card.value.replace(/[^0-9]/g, '');
                return  val < 31 ? "#ff32a1ff" :
                        val < 81 ? "#ff00c73c" :
                        val < 151? "#fffd9b5a" : "#ffff5959";
            }
        }

        Switch {
            id: toggle
            bgWidth: card.switchWidth
            bgHeight: card.switchHeight
            Layout.alignment: Qt.AlignRight
            type: card.type
        }
    }

    layer {
        enabled: true
        effect: DropShadow {
//            horizontalOffset: 1
//            verticalOffset: 1
            radius: 8
            samples: radius * 2
            source: card
            color: Style.shadowColor
            transparentBorder: true
        }
    }
}
