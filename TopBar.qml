import QtQuick 2.4
import QtQuick.Window 2.2
Rectangle{
    id: topBar
    property alias setMA: settingsMA
    anchors.top: root.top
    width: root.width
    height: root.height/15
    color: "darkred"
    Column{
        id: settingsColumn
        spacing: topBar.height/8
        anchors.right: topBar.right
        anchors.verticalCenter: topBar.verticalCenter
        Repeater{
            model: 3
            Rectangle{
                color: "white"
                height: topBar.height/6
                width: topBar.width/10
                radius: 20
            }

        }
    }
    MouseArea{
        id: settingsMA
        anchors.fill: settingsColumn
        onClicked: {
            if(setBar.state === "SETVISIBLE"){
                setBar.state = "SETNOTVISIBLE";
               } else{
                setBar.state = "SETVISIBLE"
            }
        }
    }
    MouseArea{
        id: home
        width: settingsColumn.width
        height: settingsColumn.height
        onClicked: {
            root.state = "MAIN"
            setBar.state = "SETNOTVISIBLE"
        }
    }
}


