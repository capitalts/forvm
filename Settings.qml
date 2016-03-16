import QtQuick 2.4
import QtQuick.Controls 1.2

Rectangle {
    id: settingsPage
    width: background.width
    height: background.height
    color: "grey"
    state: "SETTINGSMAIN"
    Rectangle{

        id: iconEdit
        anchors.top: parent.top
        anchors.left: parent.left
        width: parent.width
        height: parent.height/8
        color: "white"
        Text{
            id:iconEditText
            anchors.top: parent.top
            anchors.left: parent.left
            text: qsTr("Edit Icon:")
            font.pointSize: 12
        }

        Image{
            id:icon
            anchors.top: iconEditText.bottom
            anchors.topMargin: 5
            anchors.left: parent.left
            width: settingsPage.width/7
            height: parent.height/1.7
            source: iconDict[userIcon]
        }
        Text{
            id: iconText
            anchors.verticalCenter: icon.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.leftMargin: 10
            text: userIcon
            font.pointSize: 12
        }

        MouseArea{
            anchors.fill: parent
            onClicked: settingsPage.state = "EDITICON"
        }
    }

    Rectangle{

            id: fontEdit
            anchors.top: iconEdit.bottom
            anchors.topMargin: 10
            anchors.left: parent.left
            width: parent.width
            height: parent.height/8
            color: "white"
            Text{
                id:fontEditText
                anchors.top: parent.top
                anchors.left: parent.left
                text: qsTr("Edit Post Font Size:")
                font.pointSize: 12
            }

            Text{
                id: fontSizeText
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.leftMargin: 10
                text: qsTr(postFontSize.toString())
                font.pointSize: postFontSize
            }

            MouseArea{
                anchors.fill: parent
                onClicked: settingsPage.state = "EDITFONTSIZE"
            }
        }

    EditIcon{
        id: edIc
        visible: false
    }

    PostFontSize{
        id: postFont
        visible: false
    }

    states: [
        State{
            name: "SETTINGSMAIN"
            PropertyChanges {
                target: edIc
                visible: false
            }
            PropertyChanges {
                target: iconEdit
                visible: true
            }
        },

        State{
            name: "EDITICON"
            PropertyChanges {
                target: edIc
                visible: true
            }
            PropertyChanges {
                target: iconEdit
                visible: false
            }
        },

        State{
                name: "EDITFONTSIZE"
                PropertyChanges {
                    target: iconEdit
                    visible: false
                }
                PropertyChanges {
                    target: postFont
                    visible: true
                }
                PropertyChanges {
                    target: fontEdit
                    visible: false
                }
        }
    ]
}



