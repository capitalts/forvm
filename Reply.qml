import QtQuick 2.5
import QuickAndroid 0.1
import QuickAndroid.Styles 0.1
import QtQuick.Controls 2.0
Rectangle {
    property variant arts: [""]
    property alias repText: replyText
    id: replyRect
    width: background.width
    height: background.height/1.1
    color: "darkgrey"
    state: "REPLYNOTVISIBLE"
    MouseArea{
        id: replyMA
        anchors.fill: parent
    Text {
        id: postIn
        text: qsTr("Post In " + threadTitle)
        font.pointSize: 15
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
    }



    Rectangle{
        id: submit
        width: reply.width/2.01
        height: background.height - replyMA.height - 5
        anchors.top: replyMA.bottom
        anchors.topMargin: 5
        anchors.right: replyMA.right
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
                if(replyText.text.length > 0){
                    client.sendPost(threadSource, "",replyText.text, userIcon)
                }
                replyRect.state = "SUBMITCLICKED"

            }

        }
    }
    Rectangle{
        id: cancel
        width: background.width/2.01
        height: background.height - replyRect.height - 5
        anchors.top: replyMA.bottom
        anchors.topMargin: 5
        anchors.left: replyMA.left
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
                replyRect.state = "CANCELCLICKED"
                cancel.color = "lightGrey"
            }

        }

    }
    Rectangle{
        id: replyTextRect
        height: parent.height - postIn.height - 15
        width: parent.width -5
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: postIn.bottom
        color: "lightgrey"
        Flickable {
             id: replyFlick
             width: parent.width; height: parent.height;
             anchors.fill: parent
             flickableDirection: Flickable.VerticalFlick
             contentWidth: parent.width
             contentHeight: replyText.paintedHeight
             clip: true
             boundsBehavior: Flickable.StopAtBounds

             function ensureVisible(r)
             {
                 if (contentX >= r.x)
                     contentX = r.x;
                 else if (contentX+ width <= r.x+r.width)
                     contentX = r.x+r.width-width;
                 if (contentY >= r.y)
                     contentY = r.y;
                 else if (contentY+height <= r.y+r.height)
                     contentY = r.y+r.height-height;
             }
            TextArea{
                id: replyText
                width: parent.width
                height: parent.height + postFontSize
                focus: true
                font.pointSize: postFontSize
                anchors{
                    right: parent.right
                    rightMargin: 7
                    left: parent.left
                    leftMargin: 5
                }
                wrapMode: TextArea.WrapAtWordBoundaryOrAnywhere
                onCursorRectangleChanged: replyFlick.ensureVisible(cursorRectangle)
            }

        }
    }
}
    states:[
        State{
            name: "REPLYVISIBLE"
            PropertyChanges {
                target: replyRect
                x: 0
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
                target: replyText
                text: ""
            }
        },
        State{
            name: "REPLYNOTVISIBLE"
            PropertyChanges {
                target: replyRect
                x: root.width
                enabled: false
            }

        },
        State{
            name: "CANCELCLICKED"
            PropertyChanges {
                target: replyRect
                x: root.width
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
                target: replyRect
                x: root.width
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
            from: "REPLYVISIBLE"
            to: "SUBMITCLICKED"
            PropertyAnimation{
                target: submit
                property: "color"
                duration: 150
            }
            PropertyAnimation{
                target: replyRect
                property: "x"
                duration: 200
            }


        },
        Transition {
            from: "REPLYVISIBLE"
            to: "CANCELCLICKED"
            PropertyAnimation{
                target: cancel
                property: "color"
                duration: 150
            }
            PropertyAnimation{
                target: replyRect
                property: "x"
                duration: 200
            }
        },
        Transition {
            from: "REPLYVISIBLE"
            to: "SUBMITCLICKED"
            PropertyAnimation{
                target: submit
                property: "color"
                duration: 150
            }
            PropertyAnimation{
                target: replyRect
                property: "x"
                duration: 200
            }
        },
            Transition {
                from: "REPLYVISIBLE"
                to: "REPLYNOTVISIBLE"
                PropertyAnimation{
                    target: replyRect
                    property: "x"
                    duration: 200
                }
            },
            Transition {
                from: "SUBMITCLICKED"
                to: "REPLYVISIBLE"
                PropertyAnimation{
                    target: replyRect
                    property: "x"
                    duration: 200
                }
            },
        Transition {
            from: "CANCELCLICKED"
            to: "REPLYVISIBLE"
            PropertyAnimation{
                target: replyRect
                property: "x"
                duration: 200
            }
        },
        Transition {
            from: "REPLYNOTVISIBLE"
            to: "REPLYVISIBLE"
            PropertyAnimation{
                target: replyRect
                property: "x"
                duration: 200
            }
        }
    ]
}


