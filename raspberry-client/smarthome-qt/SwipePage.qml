import QtQuick 2.11
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.1

Item {

    SwipeView {
        id: swipeView

        currentIndex: tabBar.currentIndex
        anchors.fill: parent

        // my pages add..
        Item {

            HomeTabPage {
                id: homeTab
            }
        }
        Item {
            Rectangle {
                implicitHeight: 50
                implicitWidth: 50
                color: "green"
            }
        }
        Item {
            Text {
                width: 200
                height: 100
                text: HomeProperty.currentTemperature
            }

            Rectangle {
                implicitHeight: 50
                implicitWidth: 50
                color: "blue"
            }
        }
        Item {

            SecureTabPage {
                id: secureTab
            }
        }
    }

    TabBar {
        id: tabBar
        width: parent.width
        anchors.bottom: parent.bottom
        currentIndex: swipeView.currentIndex

        TabButton {
//            text: HomeProperty.currentTemperature
            onClicked: homeTab.animRestart()
            icon {
                source: "qrc:/images/3844435-home-house_110321.png"
            }
        }

        TabButton {
//            text: "LED"
            icon {
                source: "qrc:/images/ceiling_light_icon_136808.png"
            }
        }

        TabButton {
//            text: "Air"
            icon {
                source: "qrc:/images/wind-weather-lines-group-symbol_icon-icons.com_54629.png"
            }
        }

        TabButton {
//            text: "Secure"
            onClicked: secureTab.videoUpdate()
            icon {
                source: "qrc:/images/shield_lock_icon_136215.png"
            }
        }
    }

    function setTemp(temp) {
        homeTab.setTemp(temp)
    }
}
