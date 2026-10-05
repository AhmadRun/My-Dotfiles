import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: root
    width: 1280; height: 720
    color: "#121212"
    property bool busy: false
    property string errorMessage: ""
    property string clockText: Qt.formatTime(new Date(), "HH:mm")
    function login() {
        if (busy || username.text.trim() === "" || session.currentIndex < 0) return;
        errorMessage = ""; busy = true; loginTimeout.restart();
        sddm.login(username.text.trim(), password.text, session.currentIndex);
    }
    Connections {
        target: sddm
        function onLoginFailed() {
            root.busy = false; loginTimeout.stop(); password.clear();
            root.errorMessage = "Login failed · حاول مرة أخرى"; password.forceActiveFocus();
        }
        function onLoginSucceeded() { password.clear(); loginTimeout.stop(); }
    }
    Timer { id: loginTimeout; interval: 30000; onTriggered: { root.busy = false; password.clear(); root.errorMessage = "Please try again"; } }
    Timer { interval: 1000; running: true; repeat: true; onTriggered: root.clockText = Qt.formatTime(new Date(), "HH:mm") }
    Item {
        id: scene
        width: 1280; height: 720
        anchors.centerIn: parent
        scale: Math.min(root.width / width, root.height / height)
        // Re-create the reference geometry without baking login controls into a wallpaper.
        Rectangle { x: 150; y: 224; width: 546; height: 270; radius: 135; color: "#242424" }
        Rectangle { x: 324; y: 180; width: 213; height: 280; radius: 107; color: "#1b1b1b" }
        Rectangle { x: 721; y: 209; width: 303; height: 303; radius: 152; color: "#656565" }
        Rectangle {
            x: 711; y: 362; width: 162; height: 238
            gradient: Gradient { GradientStop { position: 0; color: "#393939" } GradientStop { position: 1; color: "#121212" } }
        }
        Rectangle {
            x: 1027; y: 157; width: 182; height: 401
            gradient: Gradient { GradientStop { position: 0; color: "#121212" } GradientStop { position: 0.48; color: "#333333" } GradientStop { position: 1; color: "#121212" } }
        }
        Repeater {
            model: [428, 1206]
            delegate: Item {
                required property var modelData
                x: modelData; y: 361
                Rectangle { x: -65; width: 130; height: 1; color: "#535353" }
                Rectangle { y: -65; width: 1; height: 130; color: "#535353" }
            }
        }
        Canvas {
            id: clock; x: 545; y: 102; width: 200; height: 61
            property string value: root.clockText
            onValueChanged: requestPaint()
            onPaint: {
                var c = getContext("2d"); c.clearRect(0,0,width,height); c.fillStyle = "#fafafa";
                var digits = {"0":["11111","10001","10001","10001","10001","10001","11111"],"1":["00100","01100","00100","00100","00100","00100","01110"],"2":["11111","00001","00001","11111","10000","10000","11111"],"3":["11111","00001","00001","01111","00001","00001","11111"],"4":["10001","10001","10001","11111","00001","00001","00001"],"5":["11111","10000","10000","11111","00001","00001","11111"],"6":["11111","10000","10000","11111","10001","10001","11111"],"7":["11111","00001","00010","00100","01000","01000","01000"],"8":["11111","10001","10001","11111","10001","10001","11111"],"9":["11111","10001","10001","11111","00001","00001","11111"],":":["0","1","1","0","1","1","0"]};
                var offset=4;
                for(var i=0;i<value.length;i++) {
                    var rows=digits[value[i]];
                    for(var y=0;y<7;y++) for(var x=0;x<rows[y].length;x++) if(rows[y][x]==="1") { c.beginPath(); c.arc(offset+x*7,6+y*7,2.35,0,Math.PI*2); c.fill(); }
                    offset += (value[i]===":" ? 3 : 6)*7;
                }
            }
        }
        Rectangle { x: 560; y: 249; width: 162; height: 158; radius: 25; color: "transparent"; border.color: "#a62f36"; border.width: 2 }
        Rectangle {
            x: 557; y: 242; width: 153; height: 153; radius: 20; color: "#e2e4e6"; clip: true
            Image { anchors.fill: parent; source: "avatar.svg"; fillMode: Image.PreserveAspectCrop }
        }
        Text { x: 490; y: 440; width: 300; horizontalAlignment: Text.AlignHCenter; text: "welcome " + (username.text || "User"); color: "#f4f4f4"; font.family: "monospace"; font.pixelSize: 23 }
        Column {
            x: 540; y: 505; width: 200; spacing: 13
            TextField {
                id: username; objectName: "username"; width: 200; height: 35
                text: userModel.lastUser || ""; placeholderText: "Username"
                enabled: !root.busy; color: "#ffffff"; placeholderTextColor: "#e2a3a6"
                font.pixelSize: 15; leftPadding: 15; selectByMouse: true
                background: Rectangle { radius: 18; color: "#a83037"; border.width: username.activeFocus ? 1 : 0; border.color: "#f7b3b7" }
                KeyNavigation.tab: password
                onAccepted: password.forceActiveFocus()
            }
            TextField {
                id: password; objectName: "password"; width: 200; height: 35; placeholderText: "Password"
                echoMode: TextInput.Password; passwordCharacter: "●"; enabled: !root.busy
                color: "#ffffff"; placeholderTextColor: "#e2a3a6"; font.pixelSize: 15; leftPadding: 15
                inputMethodHints: Qt.ImhHiddenText | Qt.ImhSensitiveData | Qt.ImhNoPredictiveText
                background: Rectangle { radius: 18; color: "#a83037"; border.width: password.activeFocus ? 1 : 0; border.color: "#f7b3b7" }
                KeyNavigation.tab: submit
                onAccepted: root.login()
            }
            Button {
                id: submit; anchors.horizontalCenter: parent.horizontalCenter; width: 41; height: 41; enabled: !root.busy
                text: root.busy ? "…" : "➜"
                background: Rectangle { radius: 21; color: submit.hovered ? "#e9b7ba" : "#fafafa"; border.color: "#a83037"; border.width: submit.activeFocus ? 2 : 0 }
                contentItem: Text { text: submit.text; color: "#a83037"; font.pixelSize: 23; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
                onClicked: root.login()
                Accessible.name: "Sign in"
            }
        }
        Text { x: 350; y: 650; width: 580; text: root.errorMessage; color: "#f1a0a5"; horizontalAlignment: Text.AlignHCenter; font.pixelSize: 14 }
    }
    ComboBox {
        id: session; objectName: "session"; anchors.left: parent.left; anchors.bottom: parent.bottom; anchors.margins: 22
        width: 180; height: 34; model: sessionModel; textRole: "name"; currentIndex: sessionModel.lastIndex
        enabled: !root.busy
        palette.button: "#242424"; palette.buttonText: "#cccccc"; palette.text: "#eeeeee"; palette.base: "#242424"; palette.highlight: "#a83037"
        Accessible.name: "Desktop session"
    }
    Text { anchors.right: parent.right; anchors.bottom: parent.bottom; anchors.margins: 28; text: "CRUZE  /  NIRI"; font.pixelSize: 11; font.letterSpacing: 3; color: "#858585" }
    Component.onCompleted: { var niri = session.find("Niri", Qt.MatchFixedString); if (niri >= 0) session.currentIndex = niri; password.forceActiveFocus(); }
}
