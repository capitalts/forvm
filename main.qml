import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import QtQuick.XmlListModel 2.0
ApplicationWindow{
    height: 600
    width: 400
    visible: true
    property int postFontSize: 12
    property string userIcon: "conservative"
    property string threadSource: ""
    property variant iconDict : {"conservative": ":/../../Pictures/Republicanlogo.svg.png",
        "liberal": ":/../../Pictures/DemocraticLogo.png"};
    property string articleUrl: ""
    property string threadTitle: ""

    Rectangle{
        id: root
        anchors.fill: parent
        visible: true
        color: "black"
        state: "MAIN"
        MouseArea{
            anchors.fill: parent
            onClicked: setBar.state = "SETNOTVISIBLE"
        }

        XmlListModel{
            id: mainModel
            source: "file:///home/tory/Qtprojects/ForvmXMLFiles/MainThreads.xml"
            query: "/threads/thread"

            XmlRole{
                name: "thrdTitle"; query: "title/string()"
            }
            XmlRole{
                name: "threadImg"; query: "imageSrc/string()"
            }
            XmlRole{
                name: "threadSrc"; query: "source/string()"
            }

        }


        Rectangle{
            id: background
            y:topBar.height
            width: root.width
            height: root.height - topBar.height
            color: "black"
            GridView{
                id: threadGrid
                cellWidth: parent.width/2
                cellHeight: parent.height/4
                anchors.fill: parent
                model: mainModel
                delegate: MainPageDel {}

            }
    }
        Thread{
            id: thread
            x: root.width
            y: topBar.height
        }
        TopBar {
            id: topBar
        }

        Settings{
            id: sets
            x: root.width
            y: topBar.height
            enabled: false
        }

        SettingsBar{
            id: setBar
            anchors.right: root.right
            anchors.top: topBar.bottom
        }

        EditIcon{
            id: edIc
            visible: false
        }
        states: [
            State{
                name:"MAIN"
                PropertyChanges {
                    target: root
                    color: "black"
                }
                PropertyChanges {
                    target: threadGrid
                    visible: true
                }
                PropertyChanges {
                    target: setBar
                    settingsModel: setBar.mainPageSetModel
                    state: "SETNOTVISIBLE"
                }
                PropertyChanges {
                    target: thread
                    x: root.width
                }
                PropertyChanges {
                    target: sets
                    x: root.width
                }
//                PropertyChanges {
//                    target: thread.replyState
//                    state: "REPLYNOTVISIBLE"

//                }
            },
            State{
                name:"THREAD"
                PropertyChanges {
                    target: root
                    color: "grey"
                }
                PropertyChanges {
                    target: setBar
                    settingsModel: setBar.threadSetModel
                    state: "SETNOTVISIBLE"
                }
                PropertyChanges {
                    target: thread
                    x: 0
                }
//                PropertyChanges{
//                    target: thread.replyState
//                    state: "REPLYNOTVISIBLE"

//                }
            },
            State{
                name: "SETTINGS"

                PropertyChanges {
                    target: sets
                    x:0
                    state: "SETTINGSMAIN"
                    enabled: true
                }
                PropertyChanges{
                    target: setBar
                    state: "SETNOTVISIBLE"
                }
            }

        ]

        transitions: [
            Transition{
                from: "MAIN"; to: "THREAD"


                PropertyAnimation {
                    target: thread
                    property: "x"
                    duration: 200
                    easing.type: Easing.InOutQuad
                }

            },

            Transition{
                from: "THREAD"; to: "MAIN"
                PropertyAnimation {
                    target: thread
                    property: "x"
                    duration: 200
                    easing.type: Easing.InOutQuad
                }

            },
            Transition {
                from: "MAIN"
                to: "SETTINGS"

                PropertyAnimation {
                    target: sets
                    property: "x"
                    duration: 200
                }
            },

            Transition {
                from: "THREAD"
                to: "SETTINGS"

                PropertyAnimation {
                    target: sets
                    property: "x"
                    duration: 200
                }
            },
            Transition {
                from: "SETTINGS"
                to: "MAIN"

                PropertyAnimation {
                    target: sets
                    property: "x"
                    duration: 200

                }
            }


        ]
    }
}


