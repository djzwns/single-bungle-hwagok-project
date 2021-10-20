import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0

Rectangle {
    property string text: "Sample"
    property string value: ""
    property color bgColor: "lightblue"
    property color shadowColor: "#7fffffff"

    signal switchToggled(var check)

    id: card
    width: 150
    height: width * 0.7
    radius: Math.min(width, height) * 0.2
    color: bgColor

    //implicitHeight: 60

    ColumnLayout {
        id: contentLayout
        anchors.fill: parent
        anchors.margins: 10
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

        Switch {
            id: toggle
            Layout.alignment: Qt.AlignRight
            onToggled: switchToggled(checked)
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
            color: card.shadowColor
            transparentBorder: true
        }
    }
}
