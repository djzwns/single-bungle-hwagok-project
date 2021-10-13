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

            HomeTabPage {}
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
}
