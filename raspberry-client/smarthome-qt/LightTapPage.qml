import QtQuick 2.0
import QtQuick.Window 2.11
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.1
import "colorhelper.js" as ColorHelper

Item {
    id: lightTapRoot
    anchors.fill: parent

    ColumnLayout {
        id: lightLayout
        anchors.fill: parent
        anchors.margins: 20
        spacing: 20

        Text {
            id: title
            text: "Light"
            font.bold: true
            font.pixelSize: 24
            color: "white"
            Layout.alignment: Qt.AlignTop | Qt.AlignLeft
        }

        ColorPicker {
            id: colorSelector
            Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
            Layout.column: 1
        }
    }
}
