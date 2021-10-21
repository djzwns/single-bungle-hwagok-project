import QtQuick 2.0
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import "colorhelper.js" as ColorHelper

Item {
    id: lightTapRoot
    anchors.fill: parent

    ColorPicker {
        id: colorSelector
    }

    Button {
        width: 150
        height: 60
        anchors.verticalCenter: parent.verticalCenter
        anchors.top: colorSelector.bottom
        id: setColorBtn
        onClicked: {
            root.colorChanged(ColorHelper.rgbToNumber(colorSelector.currentColor));
        }
    }
}
