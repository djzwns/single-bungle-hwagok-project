import QtQuick 2.11
import QtQuick.Controls 2.0
import QtQuick.Window 2.11
import QtGraphicalEffects 1.0

Item {
    id: popupParent
    signal buttonAllowClicked()
    signal buttonDenyClicked()

    width: parent.width
    height: parent.height

    property string leftBtnText: "\u2715 Deny"
    property string rightBtnText: "\u2713 Allow"

    Popup {
        id: rootPopup
        width: parent.width
        height: parent.height
        padding: 0
        background: Rectangle {
            color: "white"
            opacity: 0.6
        }

        Rectangle {
            id: devicePopup
            // center position
            anchors.centerIn: parent
            width: 250
            height: 140
            radius: 20
            transform: Scale {
                id: popupScale
                origin.x: parent.width * 0.25
                origin.y: parent.height * 0.25
            }

            layer {
                enabled: true
                effect: DropShadow {
                    radius: 8
                    samples: radius * 2
                    source: devicePopup
                    color: "#7f000000" //Style.shadowColor
                    transparentBorder: true
                }
            }

            Column {
                anchors.fill: parent
                Text {
                    id: popupText
                    text: "Allow ### to access your server?"
                    color: "#23272a"
                    width: devicePopup.width
                    height: devicePopup.height * 0.7
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                Row {

                    Button {
                        id: denyBtn
                        width: devicePopup.width * 0.5
                        height: devicePopup.height * 0.3
                        background: Rectangle {
                            radius: devicePopup.radius
                        }

                        Text {
                            text: popupParent.leftBtnText
                            color: Style.startColor
                            font.bold: true
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        onClicked: {
                            closeDevicePopup()
                            buttonDenyClicked()
                            console.log("deny clicked.")
                        }
                    }

                    Button {
                        id: allowBtn
                        width: devicePopup.width * 0.5
                        height: devicePopup.height * 0.3
                        background: Rectangle {
                            radius: devicePopup.radius
                        }

                        Text {
                            text: popupParent.rightBtnText
                            color: Style.startColor
                            font.bold: true
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        onClicked: {
                            closeDevicePopup()
                            buttonAllowClicked()
                            console.log("allow clicked.")
                        }
                    }
                }
            }
        }

        enter: Transition {
            ParallelAnimation {
                NumberAnimation {
                    target: popupScale
                    properties: "xScale, yScale"
                    from: 0.6
                    to: 1
                    duration: 150
                    easing: Easing.InOutBack
                }
                NumberAnimation {
                    target: rootPopup
                    properties: "background.opacity"
                    from: 0
                    to: 0.6
                    duration: 150
                    easing: Easing.InOutBack
                }
            }
        }

        exit: Transition {
            ParallelAnimation {
                NumberAnimation {
                    target: popupScale
                    properties: "xScale, yScale"
                    from: 1
                    to: 0.6
                    duration: 150
                    easing: Easing.InOutBack
                }
                NumberAnimation {
                    target: rootPopup
                    properties: "background.opacity"
                    from: 0.6
                    to: 0
                    duration: 150
                    easing: Easing.InOutBack
                }
            }
        }
    }

    function openDevicePopup(str) {
        popupText.text = str
        rootPopup.open();
    }

    function closeDevicePopup() {
        rootPopup.close();
    }
}
