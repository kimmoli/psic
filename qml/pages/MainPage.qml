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

            Button
            {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Reset"
                onClicked: psic.reset()
            }

            TextSwitch
            {
                id: outputControlSwitch
                text: "Output control"
                onCheckedChanged:
                {
                    if (checked)
                        psic.writeData("OUTP 1\n")
                    else
                        psic.writeData("OUTP 0\n")
                }
            }

            Slider
            {
                id: voltageSlider
                label: "Voltage"
                width: parent.width
                minimumValue: 0
                maximumValue: 200
                value: 0
                valueText: value + " V"
                stepSize: 1
                onValueChanged: psic.writeData("VOLT " + value + "\n")
            }
            Slider
            {
                id: currentSlider
                label: "Current"
                width: parent.width
                minimumValue: 0
                maximumValue: 2
                value: 0
                valueText: value + " A"
                stepSize: 0.1
                onValueChanged: psic.writeData("CURR " + value + "\n")
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
            reset()
            writeData("*IDN?\n")
        }

        onNewDataAvailable:
        {
            lastReply = readData()
            console.log("replied: " + lastReply)
        }

        function reset()
        {
            psic.writeData("*RST\n")
            clearOutputTimer.start()
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

    Timer
    {
        id: clearOutputTimer
        running: false
        interval: 200
        onTriggered:
        {
            if (outputControlSwitch.checked)
                outputControlSwitch.checked = false
            else
                psic.writeData("OUTP 0\n")
            if (voltageSlider.value != 0)
                voltageSlider.value = 0
            else
                psic.writeData("VOLT 0\n")
            if (currentSlider.value != 0)
                currentSlider.value = 0
            else
                psic.writeData("CURR 0\n")
        }
    }

}


