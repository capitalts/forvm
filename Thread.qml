import QtQuick 2.4
import QtQuick.XmlListModel 2.0
Rectangle{
    id: thread
    property alias replyState: reply.state
    width: background.width
    height: background.height
    XmlListModel{
        id: postModel
        source: "file:///home/tory/Qtprojects/ForvmXMLFiles/" + threadSource
        query: "/thread/posts/post"

        XmlRole{
            name: "postNumber"; query: "postNumber/number()"
        }
        XmlRole{
            name: "postText"; query: "postText/string()"
        }
        XmlRole{
            name: "postIcon"; query: "icon/string()"
        }
    }

    ThreadDel {
        id: thrdDel
        Rectangle{
            id: submit
            width: replyRect.width/2.01
            height: background.height - replyRect.height - 5
            anchors.top: replyRect.bottom
            anchors.topMargin: 5
            anchors.right: replyRect.right
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
                    reply.state = "SUBMITCLICKED"

                    client.sendPost(threadSource, "",replyText.text, userIcon)
                    postModel.reload()

                }

            }
        }
        Rectangle{
            id: cancel
            width: background.width/2.01
            height: background.height - replyRect.height - 5
            anchors.top: replyRect.bottom
            anchors.topMargin: 5
            anchors.left: replyRect.left
            color: "darkgrey"

            Text{
                id: cancelText
                anchors.centerIn: parent
                text: qsTr("Cancel")
            }
            MouseArea{
                id:cancelMA
                anchors.fill: parent
                enabled: false
                onClicked: {
                    reply.state = "CANCELCLICKED"
                    cancel.color = "lightGrey"

                }

            }

        }
    }
    Rectangle{
        id: postBackground
        color:"grey"
        anchors.top:articleBack.bottom
        width: parent.width
        height: parent.height - articleBack.height
            ListView{
                id: postList
                anchors.fill: parent
                model: postModel
                delegate: thrdDel
                spacing: 2

            }
    }
    Rectangle{
        id: articleBack
        height: root.height/4.5
        width: root.width
        color: "black"

    }

    XmlListModel{
        id: artModel
        source: "file:///home/tory/Qtprojects/ForvmXMLFiles/" + threadSource
        query: "/thread/articles/article"
            XmlRole{
                name: "artTitle"; query: "title/string()"
            }
            XmlRole{
                name: "artImg"; query: "imgSource/string()"
            }
            XmlRole{
                name: "artSource"; query: "source/string()"
            }
            XmlRole{
                name: "bias"; query: "bias/number()"
            }
            XmlRole{
                name: "fair"; query: "fair/number()"
            }
    }


    ListView {
        id: articleList
        anchors.fill: articleBack
        anchors.margins: 5
        clip: true
        model: artModel
        orientation: ListView.Horizontal
        delegate: ArticleDel {}
        spacing: 5

    }
    Reply{
        id: reply
        state: "REPLYNOTVISIBLE"
    }

}


