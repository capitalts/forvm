import QtQuick 2.4
import QuickAndroid 0.1
import QuickAndroid.Styles 0.1
import QtQuick.Controls 2.0 as Control
Rectangle {
    id: newThreadRect
    width: background.width
    height: background.height/1.1
    y:0
    color: "darkgrey"
    state: "NEWTHREADNOTVISIBLE"
    anchors.top: topBar.bottom
    MouseArea{
        id: newThreadMA
        anchors.fill: parent
        Text {
            id: titleText
            text: qsTr("Title")
            font.pixelSize: 30
            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Rectangle{
            id: titleTextRect
            height: titleText.height*1.5
            width: parent.width-5
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: titleText.bottom
            color: "lightgrey"
            TextField{
                id: titleTextEdit
                width: parent.width
                height: parent.height
                focus: true
                clip: true
                font.pointSize: 20
                anchors{
                    right: parent.right
                    rightMargin: 7
                    left: parent.left
                    leftMargin: 5
                }

            }

        }

        Text {
            id: artText
            text: qsTr("Article")
            font.pixelSize: 30
            anchors.top: titleTextRect.bottom
            anchors.topMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Rectangle{
            id: artAddTextRect
            height: artText.height*1.5
            width: parent.width - 5
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: artText.bottom
            color: "lightgrey"

                TextField{
                    id: artAddText
                    width: parent.width
                    height: parent.height
                    clip: true
                    font.pixelSize: 20
                    anchors{
                        left: parent.left
                        leftMargin: 5
                    }
                    selectByMouse: true


                }

        }

        Text {
            id: postText
            text: qsTr("Post")
            font.pixelSize: 30
            anchors.top: artAddTextRect.bottom
            anchors.topMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Rectangle{
            id: replyTextRect
            anchors.bottom: parent.bottom
            width: parent.width -5
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: 5
            anchors.top: postText.bottom
            color: "lightgrey"
            Flickable {
                 id: replyFlick
                 width: parent.width;
                 height: parent.height;
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
               Control.TextArea{
                    id: replyText
                    width: parent.width
                    height: parent.height + font.pixelSize
                    focus: true
                    font.pixelSize: 20
                    anchors{
                        right: parent.right
                        left: parent.left
                    }
                    wrapMode: Control.TextArea.WrapAtWordBoundaryOrAnywhere
                    onCursorRectangleChanged: replyFlick.ensureVisible(cursorRectangle)
                    selectByMouse: true
                }

            }
        }
        Rectangle{
            id: submit
            width: background.width/2.01
            height: background.height - newThreadRect.height - 5
            anchors.top: newThreadMA.bottom
            anchors.topMargin: 5
            anchors.right: newThreadMA.right
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
                        threadSource = titleTextEdit.text + Date() + ".xml"
                        client.newThread(titleTextEdit.text, artAddText.text, replyText.text, userIcon, threadSource)
                        newThreadRect.state = "SUBMITCLICKED"
                    }
                }

            }
        }
        Rectangle{
            id: cancel
            width: background.width/2.01
            height: background.height - newThreadRect.height - 5
            anchors.top: newThreadMA.bottom
            anchors.topMargin: 5
            anchors.left: newThreadMA.left
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
                    newThreadRect.state = "CANCELCLICKED"
                    cancel.color = "lightGrey"
                }

            }

        }
    }

    states:[
        State{
            name: "NEWTHREADVISIBLE"
            PropertyChanges {
                target: newThreadRect
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
            PropertyChanges {
                target: artAddText
                text: ""
            }
            PropertyChanges {
                target: titleTextEdit
                text: ""
            }
        },
        State{
            name: "NEWTHREADNOTVISIBLE"
            PropertyChanges {
                target: newThreadRect
                x: root.width
                enabled: false
            }

        },
        State{
            name: "CANCELCLICKED"
            PropertyChanges {
                target: newThreadRect
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
                target: newThreadRect
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
            from: "NEWTHREADVISIBLE"
            to: "SUBMITCLICKED"
            PropertyAnimation{
                target: submit
                property: "color"
                duration: 150
            }
            PropertyAnimation{
                target: newThreadRect
                property: "x"
                duration: 200
            }


        },
        Transition {
            from: "NEWTHREADVISIBLE"
            to: "CANCELCLICKED"
            PropertyAnimation{
                target: cancel
                property: "color"
                duration: 150
            }
            PropertyAnimation{
                target: newThreadRect
                property: "x"
                duration: 200
            }
        },
        Transition {
            from: "NEWTHREADVISIBLE"
            to: "SUBMITCLICKED"
            PropertyAnimation{
                target: submit
                property: "color"
                duration: 150
            }
            PropertyAnimation{
                target: newThreadRect
                property: "x"
                duration: 200
            }
        },
            Transition {
                from: "NEWTHREADVISIBLE"
                to: "NEWTHREADNOTVISIBLE"
                PropertyAnimation{
                    target: newThreadRect
                    property: "x"
                    duration: 200
                }
            },
            Transition {
                from: "SUBMITCLICKED"
                to: "NEWTHREADVISIBLE"
                PropertyAnimation{
                    target: newThreadRect
                    property: "x"
                    duration: 200
                }
            },
        Transition {
            from: "CANCELCLICKED"
            to: "NEWTHREADVISIBLE"
            PropertyAnimation{
                target: newThreadRect
                property: "x"
                duration: 200
            }
        },
        Transition {
            from: "NEWTHREADNOTVISIBLE"
            to: "NEWTHREADVISIBLE"
            PropertyAnimation{
                target: newThreadRect
                property: "x"
                duration: 200
            }
        }
    ]
}



