import QtQuick 2.4
Component{
    Rectangle{
        id: article
        color: "grey"
        width: articleBack.width/3
        height: articleBack.height/1.05
        anchors.verticalCenter: parent.verticalCenter
        Text{
            text: artTitle
            anchors.top: parent.top
            width: parent.width
            wrapMode: Text.WordWrap
            font.pointSize: 12
            color: "white"
        }
        Flickable{
            id:imageFlick
            anchors.fill: parent
            contentWidth: parent.width
            contentHeight: parent.height*2
            Image{
                id: articleImage
                width: imageFlick.width
                height: imageFlick.height
                source: artImg
                MouseArea{
                    anchors.fill: parent
                    onClicked:{
                        web.openWebPage(artSource)
                    }
                }
            }
            flickableDirection: Flickable.VerticalFlick
            boundsBehavior: Flickable.StopAtBounds

        }
        Rectangle{
            id: biases
            color:"tomato"
            width: article.width/4.5
            height: article.height/4.5
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
                    if(voteEnabled == "true"){
                        client.biasVote(threadSource, artSource)
                        artModel.reload()

                    }

                }
            }
        }
        Rectangle{
            id: fairs
            color: "palegreen"
            width: parent.width/4.5
            height: parent.height/4.5
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
                    if(voteEnabled == "true"){
                        client.fairVote(threadSource, artSource)
                        artModel.reload()
                    }



                }
            }
        }

    }
}

