import QtQuick 2.4

Rectangle {
    id: editPostFontSize
    anchors.fill: parent
    color: "grey"
    ListModel{
        id: postFonts
        ListElement{
            textSrc: "8"
            size: 8
        }
        ListElement{
            textSrc: "10"
            size: 10
        }
        ListElement{
            textSrc: "12"
            size: 12
        }
        ListElement{
            textSrc: "14"
            size: 14
        }
        ListElement{
            textSrc: "16"
            size: 16
        }
    }

    Component{
        id:fontSizeDel
        Rectangle{
            color: "white"
            width: parent.parent.width
            height: parent.parent.height/postFonts.count
            Text{
                id: fontText
                text: qsTr(textSrc)
                anchors.centerIn: parent
                font.pointSize: size
            }
            MouseArea{
                anchors.fill: parent
                onClicked:{
                    postFontSize = size;
                    settingsPage.state = "SETTINGSMAIN"
                }
            }
        }

    }

        ListView{
            id: postFontList
            spacing: 5
            model: postFonts
            delegate: fontSizeDel
            anchors.fill: parent

        }

}
