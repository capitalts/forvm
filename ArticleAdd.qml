import QtQuick 2.0
import QuickAndroid 0.1
Rectangle {
    property variant arts: [""]
    id: artAddRect
    width: background.width
    height: background.height/6
    y: 0
    color: "darkgrey"
    state: "ARTADDNOTVISIBLE"
    MouseArea{
        id: backMA
        anchors.fill: parent
    }

    Text {
        id: postIn
        text: qsTr("Add Article")
        font.pointSize: 30
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Rectangle{
        id: submit
        width: artAddRect.width/2.01
        height:artAddRect.height/2
        anchors.top: artAddRect.bottom
        anchors.topMargin: 2
        anchors.right: artAddRect.right
        color: "darkgrey"
        Text{
            id: submitText
            anchors.centerIn: parent
            text: qsTr("Submit")
        }
        MouseArea{
            id:submitMA
            anchors.fill: parent

            onClicked: {
                if(artAddText.text.length > 0){
                    client.addArticle(threadSource, artAddText.text)
                }
                artAddRect.state = "SUBMITCLICKED"
            }

        }
    }
    Rectangle{
        id: cancel
        width: background.width/2.01
        height: artAddRect.height/2
        anchors.top: artAddRect.bottom
        anchors.topMargin: 2
        anchors.left: artAddRect.left
        color: "darkgrey"

        Text{
            id: cancelText
            anchors.centerIn: parent
            text: qsTr("Cancel")
        }
        MouseArea{
            id:cancelMA
            anchors.fill: parent
            onClicked: {
                artAddRect.state = "CANCELCLICKED"
                cancel.color = "lightGrey"
            }

        }

    }
    Rectangle{
        id: artAddTextRect
        height: postFontSize*4
        width: parent.width-5
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: postIn.bottom
        color: "lightgrey"

            TextField{
                id: artAddText
                width: parent.width
                height: parent.height
                focus: true
                font.pointSize: postFontSize
                anchors{
                    right: parent.right
                    rightMargin: 7
                    left: parent.left
                    leftMargin: 5
                }
            }

    }

    states:[
        State{
            name: "ARTADDVISIBLE"
            PropertyChanges {
                target: artAddRect
                y: 0
                enabled: true
            }
            PropertyChanges {
                target: submit
                color: "darkgrey"

            }
            PropertyChanges {
                target: cancel
                color: "darkgrey"

            }
            PropertyChanges {
                target: artAddText
                text: ""
            }
        },
        State{
            name: "ARTADDNOTVISIBLE"
            PropertyChanges {
                target: artAddRect
                y: -artAddRect.height - cancel.height-topBar.height
                enabled: false
            }
            PropertyChanges {
                target: backMA
                enabled: false
            }

        },
        State{
            name: "CANCELCLICKED"
            PropertyChanges {
                target: artAddRect
                y: -artAddRect.height - cancel.height-topBar.height
                enabled: false
            }
            PropertyChanges {
                target: cancel
                color: "lightgrey"

            }
        },
        State{
            name: "SUBMITCLICKED"
            PropertyChanges {
                target: artAddRect
                y: -artAddRect.height - cancel.height-topBar.height
                enabled: false
            }
            PropertyChanges {
                target: submit
                color: "lightgrey"
            }

        }

    ]

    transitions: [
        Transition {
            from: "ARTADDVISIBLE"
            to: "SUBMITCLICKED"
            PropertyAnimation{
                target: submit
                property: "color"
                duration: 50
            }
            PropertyAnimation{
                target: artAddRect
                property: "y"
                duration: 200
            }


        },
        Transition {
            from: "ARTADDVISIBLE"
            to: "CANCELCLICKED"
            PropertyAnimation{
                target: cancel
                property: "color"
                duration: 50
            }
            PropertyAnimation{
                target: artAddRect
                property: "y"
                duration: 200
            }
        },
        Transition {
            from: "ARTADDVISIBLE"
            to: "SUBMITCLICKED"
            PropertyAnimation{
                target: submit
                property: "color"
                duration: 150
            }
            PropertyAnimation{
                target: artAddRect
                property: "y"
                duration: 200
            }
        },
            Transition {
                from: "ARTADDVISIBLE"
                to: "ARTADDNOTVISIBLE"
                PropertyAnimation{
                    target: artAddRect
                    property: "y"
                    duration: 200
                }
            },
            Transition {
                from: "SUBMITCLICKED"
                to: "ARTADDVISIBLE"
                PropertyAnimation{
                    target: artAddRect
                    property: "y"
                    duration: 200
                }
            },
        Transition {
            from: "CANCELCLICKED"
            to: "ARTADDVISIBLE"
            PropertyAnimation{
                target: artAddRect
                property: "y"
                duration: 200
            }
        },
        Transition {
            from: "ARTADDNOTVISIBLE"
            to: "ARTADDVISIBLE"
            PropertyAnimation{
                target: artAddRect
                property: "y"
                duration: 200
            }
        }
    ]
}

