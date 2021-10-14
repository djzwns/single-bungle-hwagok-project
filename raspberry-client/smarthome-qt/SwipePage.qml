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
            Rectangle {
                implicitHeight: 50
                implicitWidth: 50
                color: "blue"
            }
        }
        Item {
            Rectangle {
                implicitHeight: 50
                implicitWidth: 50
                color: "red"
            }
        }
    }

    TabBar {
        id: tabBar
        width: parent.width
        anchors.bottom: parent.bottom
        currentIndex: swipeView.currentIndex

        TabButton {
            text: "Home"
            property int status: 0
            onClicked: function () {
                if (status === 0)
                    homeTab.setTemp(-5);
                else if (status === 1)
                    homeTab.setTemp(35);
                else if (status === 2)
                    homeTab.setTemp(17);
                status = (status + 1) % 3;
            }
        }

        TabButton {
            text: "LED"
        }

        TabButton {
            text: "Air"
        }

        TabButton {
            text: "Config"
        }
    }

    function setTemp(temp) {
        homeTab.setTemp(temp)
    }
}
