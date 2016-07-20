 import QtQuick 2.4

Component{
    id: threadDel


    Rectangle{

        id: postRect
        color: "white"
        width: root.width
        height: postTxt.height + root.height/10


        antialiasing: true
        Text {
            id: postTxt
            text: postText
            wrapMode: Text.WordWrap
            anchors.top: title.bottom
            anchors.topMargin: 5
            anchors.left: parent.left
            anchors.leftMargin: 3
            font.pointSize: postFontSize
            width: postRect.width
        }
        Rectangle{
            id: title
            color: "lightgrey"
            anchors.top: postRect.top
            width: postRect.width
            height: root.height/20
            Column{
                id: postColumn
                spacing: title.height/10
                anchors.right: title.right
                anchors.rightMargin: 3
                anchors.verticalCenter: title.verticalCenter
                Repeater{
                    model: 3
                    Rectangle{
                        color: "grey"
                        height: title.height/6
                        width: title.width/25
                        radius: 20
                    }

                }
            }

            MouseArea{
                id: postMA
                anchors.right: parent.right
                anchors.top: title.top
                width: postColumn.width * 2.2
                height: title.height + title.height/3
                onClicked:{
                    if(postOp.state == "POSTOPNOTVISIBLE"){
                        postOp.state = "POSTOPVISIBLE"
                    }else{
                        postOp.state = "POSTOPNOTVISIBLE"
                    }


                }
            }


            Text {
                id: postNum
                text: qsTr("No: ") + postNumber
                font.pointSize: 12
                anchors.right: postColumn.left
                anchors.rightMargin: 5
                anchors.verticalCenter: title.verticalCenter

            }
            Rectangle{
                id: icon
                radius: 20
                anchors.verticalCenter: title.verticalCenter
                anchors.left: title.left
                anchors.leftMargin: 5
                width: postRect.width/20
                height: title.height/1.3
                Image {
                    source: iconDict[postIcon]
                    anchors.fill: icon
                }
            }
        }
        PostOptions{
            id: postOp
            anchors.top: title.bottom
            anchors.right: parent.right
            state: "POSTOPNOTVISIBLE"
        }



    }


}

