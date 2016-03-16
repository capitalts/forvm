import QtQuick 2.4
Rectangle {
    id: settingsBar
    width: root.width/3
    height: root.height/3

    property alias mainPageSetModel: mainPageSettingsBarMod
    property alias threadSetModel: threadSettingsBarMod
    property alias settingsModel: settingsRep.model
    ListModel{
        id: mainPageSettingsBarMod
        ListElement{
            name: "Settings"
            sig: "SETTINGS"
        }
        ListElement{
            name: "New Thread"
            sig: "REPLYVISIBLE"
        }
        ListElement{
            name: "Help"
            sig: "Help Clicked"
        }
    }

    ListModel{
        id: threadSettingsBarMod
        ListElement{
            name: "Settings"
            sig: "SETTINGS"
        }
        ListElement{
            name: "New Post"
            sig: "REPLYVISIBLE"
        }
        ListElement{
            name: "Add Article"
            sig: "Add Article Clicked"
        }
        ListElement{
            name: "Help"
            sig: "Help Clicked"
        }
    }

    Component{
        id: settingsBarDel
        Rectangle{
            id: settingsRect
            width: settingsBar.width
            height:settingsBar.height/settingsRep.count
            color: "lightgrey"
            Text{
                text: name
                width: parent.width
                anchors.centerIn: settingsRect
                font.pointSize: 12
                color: "black"
            }
            MouseArea{
                anchors.fill: settingsRect
                onClicked: {
                           setBar.state = "SETNOTVISIBLE";
                           if(name == "Settings"){
                               root.state = sig
                           }
                            else if (name == "New Post"){
                                reply.state = sig
                           }
                         }
            }
        }
    }

    Column{
        id: settingsBarList
        anchors.fill: parent
        spacing: 5
        Repeater{
        id: settingsRep
        delegate: settingsBarDel      
        model: mainPageSettingsBarMod
        }
    }

    states:[
        State {
            name: "SETVISIBLE"
            PropertyChanges {
                target: settingsBar
                opacity: 1.0
                enabled: true
            }
        },
        State {
            name: "SETNOTVISIBLE"
            PropertyChanges {
                target: settingsBar
                opacity: 0.0
                enabled: false
            }

        }
    ]

    transitions: [
        Transition {
            from: "SETNOTVISIBLE"
            to: "SETVISIBLE"
            PropertyAnimation {
                target: settingsBar
                property: "opacity"
                duration: 100
            }
        },
        Transition {
            from: "SETVISIBLE"
            to: "SETNOTVISIBLE"
            PropertyAnimation {
                target: settingsBar
                property: "opacity"
                duration: 100
            }
        }


    ]
}

