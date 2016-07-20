import QtQuick 2.4
Rectangle {
    property variant arts: [""]
    id: replyRect
    width: background.width
    height: background.height/1.1
    y: 0
    color: "darkgrey"
    state: "REPLYNOTVISIBLE"

    Text {
        id: postIn
        text: qsTr("Post In " + threadTitle)
        font.pointSize: 15
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
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
            TextEdit{
                id: replyText
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
                wrapMode: TextEdit.WrapAtWordBoundaryOrAnywhere
                onCursorRectangleChanged: replyFlick.ensureVisible(cursorRectangle)
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


