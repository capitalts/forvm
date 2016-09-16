import QtQuick 2.4
import QtQuick.XmlListModel 2.0

Rectangle{
    id: thread
    property alias replyState: reply
    property alias artAddState: artAdd
    property alias postMod: postModel
    property alias artMod: artModel
    width: background.width
    height: background.height
    XmlListModel{
        id: postModel
        source: "file:///" + client.getAppPath(threadSource)
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

    }
    Rectangle{
        id: postBackground
        color:"grey"
        anchors.top:articleBack.bottom
        width: parent.width
        height: parent.height - articleBack.height
        Text{
            x: postBackground.width/2 - width/2
            y:-postList.contentY -75
            text: qsTr("Pull to Refresh")
            font.pointSize: 20
            color: "white"
        }
            ListView{
                id: postList
                anchors.fill: parent
                model: postModel
                delegate: thrdDel
                spacing: 2
                onDragEnded: if(contentY < -100){
                                       client.update(threadSource)
                                   }

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
        source: "file:///" + client.getAppPath(threadSource)
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
            XmlRole{
                name: "voteEnabled"; query: "enabled/string()"
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
        onDragEnded: if(contentX < -75 || contentX > contentWidth + 75){
                               client.update(threadSource)
                           }
    }
    Reply{
        id: reply
        state: "REPLYNOTVISIBLE"
    }
    ArticleAdd{
        id: artAdd
        state: "ARTADDNOTVISIBLE"
    }

}


