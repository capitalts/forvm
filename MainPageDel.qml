import QtQuick 2.4


Component{
    id: mainPageDel
    Rectangle{
        id: thread
        width: threadGrid.cellWidth-4
        height: threadGrid.cellHeight-4

        color: "grey"
        Text{
            id: title
            text: thrdTitle
            anchors.bottom: thread.bottom
            anchors.left: thread.left
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            color: "white"
            font.pointSize: 20
            width: thread.width
        }

//        Image{
//            id: articleImage
//            width: thread.width
//            height: thread.height - title.height
//            source: threadImg
//            MouseArea{
//                anchors.fill: parent
//                onClicked:{
//                    threadSource = threadSrc
//                    client.update(threadSrc)
//                    root.state = "THREAD"
//                }
//            }

//        }
        Flickable{
            id:imageFlick
            anchors.fill: parent
            contentWidth: parent.width
            contentHeight: parent.height+title.height
            Image{
                id: articleImage
                width: thread.width
                height: thread.height
                source: threadImg
                MouseArea{
                    anchors.fill: parent
                    onClicked:{
                        threadSource = threadSrc
                        client.update(threadSrc)
                        root.state = "THREAD"
                    }
                }
            }
            flickableDirection: Flickable.VerticalFlick
            boundsBehavior: Flickable.StopAtBounds

        }
    }

}

