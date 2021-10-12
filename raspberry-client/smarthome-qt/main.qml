import QtQuick 2.11
import QtQuick.Window 2.11
import QtQuick.Controls 2.0

Window {
    id: root
    title: qsTr("Smarthome")

    visible: true
    width: 450
    height: 700

    maximumWidth: width
    maximumHeight: height

    minimumWidth: width
    minimumHeight: height

    DevicePopup {
        id: popup
        onButtonAllowClicked: {
            // popup signal execute
            // send to server: [admin]ACCOUNTOK
        }
        onButtonDenyClicked: {
            // popup signal execute
            // send to server: [admin]ACCOUNTFAIL
        }
    }

    function slotDeviceConnect(deviceId) {
        popup.openDevicePopup(deviceId);
    }
}
