import QtQuick 2.4
Component{
    Rectangle{
        id: article
        width: articleBack.width/3
        height: articleBack.height/1.05
        anchors.verticalCenter: parent.verticalCenter

        Image{
            id: articleImage
            anchors.fill: parent
            source: artImg
        }
        Text{
            text: artTitle
            anchors.top: parent.top
            width: parent.width
            wrapMode: Text.WordWrap
            font.pointSize: 12
        }
        MouseArea{
            anchors.fill: parent
            onClicked:{
                web.openWebPage(artSource)
            }
        }
        Rectangle{
            id: biases
            color:"orange"
            width: article.width/4.5 - fair/10
            height: article.height/4.5 - fair/10
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 2
            anchors.right: parent.right
            anchors.rightMargin: 2
            radius: 20
            Text{
                anchors.centerIn: parent
                text: bias.toString()
            }
            MouseArea{
                id: biasClick
                anchors.fill: parent
                onClicked:{

                    client.biasVote(threadSource, artSource)
                    artModel.reload()
                }
            }
        }
        Rectangle{
            id: fairs
            color: "purple"
            width: parent.width/4.5 - bias/10
            height: parent.height/4.5 - bias/10
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 2
            anchors.right: biases.left
            anchors.rightMargin: 2
            radius: 20
            Text{
                anchors.centerIn: parent
                text: fair.toString()
            }
            MouseArea{
                id: fairClick
                anchors.fill: parent
                onClicked: {
                    client.fairVote(threadSource, artSource)
                    artModel.reload()
                }
            }
        }

    }
}

