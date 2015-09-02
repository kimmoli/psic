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
                onCheckedChanged: psic.update()
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
                onValueChanged: psic.update()
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
                onValueChanged: psic.update()
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
            connectTimer.start()
        }

        onConnectSuccess:
        {
            status = "connected"
            reset()
            writeData("*IDN?\n")
        }

        onNewDataAvailable: lastReply = readData()

        function reset()
        {
            outputControlSwitch.checked = false
            voltageSlider.value = 0
            currentSlider.value = 0
            update()
            psic.writeData("*RST\n")
        }

        function update()
        {
            psic.writeData("OUTP " + (outputControlSwitch.checked ? "1":"0") + "; " +
                           "VOLT " + voltageSlider.value + "; " +
                           "CURR " + currentSlider.value)
        }
    }

    Timer
    {
        id: connectTimer
        running: true
        interval: 1000
        onTriggered:
        {
            psic.status = "connecting"
            psic.connectToHost(psic.host)
        }
    }
}


