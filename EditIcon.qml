import QtQuick 2.4
Rectangle {
    id: editIcon
    anchors.fill: parent
    color: "grey"
    ListModel{
        id: icons
        ListElement{
            textSrc: "conservative"
            imgSource: ":/../../Pictures/Republicanlogo.svg.png"
        }
        ListElement{
            textSrc: "liberal"
            imgSource: ":/../../Pictures/DemocraticLogo.png"
        }
    }

    Component{
        id:iconDel
        Rectangle{
            color: "white"
            width: parent.parent.width
            height: parent.parent.height/15
            Image{
                id: iconImg
                source: imgSource
                width: parent.width/8
                height: parent.height
            }
            Text{
                id: iconText
                text: textSrc
                anchors.centerIn: parent
                font.pointSize: 10
            }
            MouseArea{
                anchors.fill: parent
                onClicked:{
                    userIcon = textSrc;
                    settingsPage.state = "SETTINGSMAIN"
                }
            }
        }

    }

        ListView{
            id: iconBox
            spacing: 5
            model: icons
            delegate: iconDel
            anchors.fill: parent

        }

}

