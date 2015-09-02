import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.psicontrol 1.0

Page
{
    id: page

    SilicaFlickable
    {
        anchors.fill: parent

        PullDownMenu
        {
            MenuItem
            {
                text: "About PSIC"
            }
        }

        contentHeight: column.height

        Column
        {
            id: column

            width: page.width - 2 * Theme.horizontalPageMargin
            spacing: Theme.paddingLarge
            x: Theme.horizontalPageMargin

            PageHeader
            {
                title: "PSIC"
            }

            Label
            {
                text: psic.host
            }
            Label
            {
                text: psic.status
            }
            Label
            {
                text: psic.lastReply
                wrapMode: Text.WrapAnywhere
                width: parent.width
            }
        }
    }

    Psic
    {
        id: psic

        property string status: "initialising"
        property string host: "192.168.10.100"
        property string lastReply: ""

        onConnectFail:
        {
            status = "connection failed"
            console.log("failed")
        }

        onConnectSuccess:
        {
            status = "connected"
            console.log("success")
            writeData("*IDN?\n")
        }

        onNewDataAvailable:
        {
            lastReply = readData()
            console.log("replied: " + lastReply)
        }
    }

    Timer
    {
        running: true
        interval: 1000
        onTriggered:
        {
            psic.status = "connecting"
            psic.connectToHost(psic.host)
        }
    }

}


