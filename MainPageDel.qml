import QtQuick 2.4


Component{
    id: mainPageDel
    Rectangle{
        id: thread
        width: threadGrid.cellWidth
        height: threadGrid.cellHeight
        color: "black"
            Image{
                id: articleImage
                anchors.centerIn: parent
                height: parent.height/1.03
                width: parent.width/1.02
                source: threadImg
            }
            Text{
                id: title
                text: threadTitle
                anchors.bottom: articleImage.bottom
                anchors.left: parent.left
                wrapMode: Text.WordWrap
                color: "black"
                font.pointSize: 12
                width:articleImage.width
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    threadSource = threadSrc
                    root.state = "THREAD"
                    threadTitle = thrdTitle
                }
            }
        }

}

