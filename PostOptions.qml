import QtQuick 2.4
Rectangle{
    id: postOptionsRect
    x: root.width - width
    width: background.width/4
    height: postOptionsDel.height
    ListModel{
        id: postOptionsMod
        ListElement{
            name: "Reply"
            sig: "REPLYVISIBLE"
        }
        ListElement{
            name: "Quote"
            sig: "QUOTE"
        }
        ListElement{
            name: "Info"
            sig: "INFOVISIBLE"
        }
    }

    MouseArea{
        id: outsideMA
        width: root.width
        height: root.height
        x: root.x
        onClicked: postOptionsRect.state = "POSTOPNOTVISIBLE"
    }
    Component{
        id: postOptionsDel
            Rectangle{
                id: optionsRect
                width: parent.width
                height: root.height/20
                color: "darkgrey"
                Text{
                    text: name
                    width: parent.width
                    anchors.left: parent.left
                    anchors.leftMargin: 2
                    font.pointSize: 12
                    color: "black"
                }
                MouseArea{
                    id: postOPMA
                    anchors.fill: optionsRect
                    onClicked: {
                        postOptionsRect.state = "POSTOPNOTVISIBLE"
                        if(name === "Reply"){
                        reply.state = "REPLYVISIBLE"
                        reply.repText.text = ">>" + postNumber
                        }
                    }
                }
        }
    }

        Row{
            id: postOptionsList
            anchors.fill: parent
            spacing: 2
            layoutDirection: "RightToLeft"
            Repeater{
                id: optionsRep
                delegate: postOptionsDel
                model: postOptionsMod
            }
        }

        states:[
            State {
                name: "POSTOPVISIBLE"
                PropertyChanges {
                    target: postOptionsRect
                    opacity: 1.0
                    enabled: true
                }
            },
            State {
                name: "POSTOPNOTVISIBLE"
                PropertyChanges {
                    target: postOptionsRect
                    opacity: 0.0
                    enabled: false
                }
            }
        ]

        transitions: [
            Transition {
                from: "POSTOPVISIBLE"
                to: "POSTOPNOTVISIBLE"
                PropertyAnimation {
                    target: postOptionsRect
                    property: "opacity"
                    duration: 100
                }
            },
            Transition {
                from: "POSTOPNOTVISIBLE"
                to: "POSTOPVISIBLE"
                PropertyAnimation {
                    target: postOptionsRect
                    property: "opacity"
                    duration: 100
                }
            }

        ]

}

