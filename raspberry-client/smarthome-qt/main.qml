import QtQuick 2.11
import QtQuick.Window 2.11
import QtQuick.Controls 2.0
import "."

Window {
    id: root
    title: qsTr("Smarthome")

    visible: true
//    visibility: Window.FullScreen
    width: 384
    height: 640

    maximumWidth: width
    maximumHeight: height

    minimumWidth: width
    minimumHeight: height

    signal sendData(var sendMsg)

    DevicePopup {
        id: popup
        property string deviceId: ""
        onButtonAllowClicked: {
            // popup signal execute
            // send to server: [admin]ACCOUNTOK
            sendData("[" + deviceId + "]ACCOUNTOK")
        }
        onButtonDenyClicked: {
            // popup signal execute
            // send to server: [admin]ACCOUNTFAIL
            sendData("[" + deviceId + "]ACCOUNTFAIL")
        }
    }

    SwipePage {
        id: swipe
        anchors.fill: parent
    }

    function slotDeviceConnect(deviceId) {
        popup.deviceId = deviceId;
        popup.openDevicePopup(deviceId);
    }

    function slotSetTemperature(temp) {
        swipe.setTemp(temp);
    }
}
