import QtQuick 2.0
import QtQuick.Controls 2.2

Item {
    VideioPlayer {
        id: player
    }

    ToolButton {

    }

    function videoUpdate() {
        player.update()
    }
}
