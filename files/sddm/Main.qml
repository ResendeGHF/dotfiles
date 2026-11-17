import QtQuick
import QtQuick.Controls

Rectangle {
    width: 1920; height: 1080
    color: "#2e2e2e"

    // Smart Focus: Runs immediately when the screen loads
    Component.onCompleted: {
        if (name.text === "") {
            name.forceActiveFocus()     // Focus username if empty
        } else {
            password.forceActiveFocus() // Focus password if user is detected
        }
    }

    Column {
        anchors.centerIn: parent
        spacing: 12

        // Username Label
        Text {
            text: "Username"
            color: "#eeeeee"
            font.pixelSize: 14
            font.family: "monospace"
        }

        // Username Input
        Rectangle {
            width: 300; height: 40
            color: "#444444"
            border.color: name.activeFocus ? "#005577" : "#2e2e2e"
            border.width: 2

            TextInput {
                id: name
                anchors.fill: parent
                anchors.margins: 10
                clip: true  
                
                // If lastUser is empty, fallback to the first user in the system (Role 257 is the Username string in SDDM)
                text: userModel.lastUser ? userModel.lastUser : (userModel.rowCount() > 0 ? userModel.data(userModel.index(0, 0), 257) : "")
                
                font.pixelSize: 16
                font.family: "monospace"
                color: "#eeeeee"
                verticalAlignment: TextInput.AlignVCenter
                
                KeyNavigation.tab: password
                onAccepted: password.forceActiveFocus() 
            }
        }

        // Password Label
        Text {
            text: "Password"
            color: "#eeeeee"
            font.pixelSize: 14
            font.family: "monospace"
        }

        // Password Input
        Rectangle {
            width: 300; height: 40
            color: "#444444"
            border.color: password.activeFocus ? "#005577" : "#2e2e2e"
            border.width: 2

            TextInput {
                id: password
                anchors.fill: parent
                anchors.margins: 10
                clip: true 
                
                echoMode: TextInput.Password
                font.pixelSize: 16
                font.family: "monospace"
                color: "#eeeeee"
                verticalAlignment: TextInput.AlignVCenter
                
                KeyNavigation.backtab: name
                
                onAccepted: sddm.login(name.text, password.text, sessionModel.lastIndex)
            }
        }
    }
}
