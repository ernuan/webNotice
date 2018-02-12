import QtQuick 2.10
import QtQuick.Window 2.10
import QtWebEngine 1.5

import Qt.labs.platform 1.0

Window {
    id:root
    visible: true
    width: Screen.width*0.8
    height: Screen.height*0.9
    title:web.title

    property string url: ""
    property string hostname: ""
    Component.onCompleted: {
        x=(Screen.width-width)/2
        y=(Screen.height-height)/2
        console.log(Qt.application.arguments)
        if(Qt.application.arguments.length>1){
            hostname=Qt.application.arguments[1].split('/')[2]
            url=Qt.application.arguments[1];
            console.log(url,hostname)
        }
    }

    WebEngineView{
        id:web
        userScripts:[
            WebEngineScript{
                sourceCode: "
                    class Notification{
                        constructor(){
                            console.debug('Notification')
                        }

                    }
                    Notification.permission='granted'
                    Notification.requestPermission=function(callback){
                            callback(this.permission)
                    }
                "
                worldId: WebEngineScript.MainWorld
            }
        ]
        profile: WebEngineProfile{
            persistentStoragePath:root.hostname
        }

        anchors.fill: parent
        url:root.url
        onNewViewRequested: {
            url=request.requestedUrl
        }
        onJavaScriptConsoleMessage: {
            if(level===0 && message==="Notification"&&!t.running){
                t.start()
            }
        }
    }

    Image {
        id: icon
        visible: false
        source: web.icon
        onStatusChanged: {
            if(status===Image.Ready){
                icon.grabToImage(function(result){
                    window.setIcon(result)
                    tray.visible=true
                    t.start()
                })
            }
        }
    }

    SystemTrayIcon {
        id:tray
        iconSource: web.icon
        iconName: web.title
        tooltip: web.title

        onActivated: {
            if(reason===SystemTrayIcon.Trigger){
                root.show()
                root.requestActivate()
                if(t.running){
                    t.stop()
                }
            }
        }

        menu: Menu {
            MenuItem {
                text: qsTr("Show")
                onTriggered: {
                    root.show()
                    root.requestActivate()
                }
            }
            MenuItem {
                text: qsTr("Quit")
                onTriggered: Qt.quit()
            }
        }
    }

    Timer{
        id: t
        interval: 500
        repeat: true

        property bool v: true
        onTriggered: {
            tray.iconSource=v ? icon.source : ""
            v=!v
        }
        onRunningChanged: {
            if(!running){
                v=true
                tray.iconSource= icon.source
            }
        }
    }
}
