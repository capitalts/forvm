import QtQuick 2.4


Component{
    id: mainPageDel
    Rectangle{
        id: thread
        property string previousState: "SHOWIMAGE"
        property int inter: Math.random()*(5000 - 3000 + 1) + 3000
        width: threadGrid.cellWidth-4
        height: threadGrid.cellHeight-4
        color: "darkgrey"
        Text{
            id: title
            text: thrdTitle
            anchors.bottom: thread.bottom
            anchors.left: thread.left
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            color: "white"
            font.pointSize: 15
            width: thread.width
        }

//           Timer {
//                interval: inter;
//                running: true;
//                repeat: true
//                triggeredOnStart: true
//                onTriggered: {
//                    thread.state = previousState
//                    if(previousState == "SHOWTITLE"){
//                        previousState = "SHOWIMAGE"
//                    }else{
//                        previousState = "SHOWTITLE"
//                    }

//                }
//            }

//            Image{
//                id: articleImage
//                width: thread.width
//                height: thread.height

//                source: threadImg
//            }
        Flickable{
            id:imageFlick
            anchors.fill: parent
            contentWidth: parent.width
            contentHeight: parent.height + title.height

            Image{
                id: articleImage
                width: imageFlick.width
                height: imageFlick.height
                source: threadImg
                MouseArea{
                    anchors.fill: parent
                    onClicked:{
                        threadSource = threadSrc
                        client.update(threadSource)
                        threadClicked = true
                    }
                }
            }
            flickableDirection: Flickable.VerticalFlick
            boundsBehavior: Flickable.StopAtBounds

        }


//            MouseArea{
//                anchors.fill: parent
//                onClicked:{
//                    threadSource = threadSrc
//                    client.update(threadSource)
//                    threadClicked = true
//                }
//            }
    states:[
        State{
            name: "SHOWIMAGE"
            PropertyChanges {
                target: articleImage
                y: 0

            }
        },
        State{
            name:"SHOWTITLE"
            PropertyChanges{
                target: articleImage
                y: title.height
            }
        }

    ]
    transitions: [
        Transition{
            from: "SHOWIMAGE"; to: "SHOWTITLE"


            PropertyAnimation {
                target: articleImage
                property: "y"
                duration: 1000
                easing.type: Easing.InOutQuad
            }

        },

        Transition{
            from: "SHOWTITLE"; to: "SHOWIMAGE"
            PropertyAnimation {
                target: articleImage
                property: "y"
                duration: 1000
                easing.type: Easing.InOutQuad
            }

        }
    ]

    }

}

