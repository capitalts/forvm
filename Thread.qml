import QtQuick 2.4
import QtQuick.XmlListModel 2.0
Rectangle{
    id: thread
    width: background.width
    height: background.height
    XmlListModel{
        id: postModel
        source: threadSource
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
                delegate: ThreadDel {}
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
        source: threadSource
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

}


