import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.2
import QtQuick.Extras 1.4
import QtQuick.Layouts 1.3
import QtQuick.Window 2.2

ApplicationWindow {
    id: appWindow
    visible: true
    width: 600
    minimumWidth: 380
    height: 286
    minimumHeight: 286
    x: (Screen.width - appWindow.width) / 2
    y: (Screen.height - appWindow.height) / 2
    title: qsTr("Calculator")

    menuBar: MenuBar {
        Menu {
            title: qsTr("File")
            Menu {
                title: qsTr("&View")
                MenuItem {
                    objectName: "mi_calc"
                    text: qsTr("&Calculator")
                    shortcut: "Ctrl+Shift+C"
                    onTriggered: function() {
                        if (stack.depth < 2)
                            stack.push(calculator)
                    }
                }
                MenuItem {
                    objectName: "mi_conv"
                    text: qsTr("&Converter")
                    shortcut: "Ctrl+Shift+V"
                    onTriggered: function() {
                        if (stack.depth > 1)
                            stack.pop()
                    }
                }
            }
            MenuSeparator { }
            MenuItem {
                text: qsTr("&Exit")
                shortcut: "Ctrl+Q"
                onTriggered: Qt.quit();
            }
        }
        Menu {
            title: qsTr("About")
            MenuItem {
                text: qsTr("&About")
                shortcut: "F1"
            }
        }
    }

    Component {
        id: calcBtn
        ButtonStyle {
            label: Component {
                Text {
                    text: control.text
                    clip: true
                    font.pointSize: 12
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    anchors.fill: parent
                }
            }
        }
    }

    Component {
        id: calcBtn_bold
        ButtonStyle {
            label: Component {
                Text {
                    text: control.text
                    clip: true
                    font.pointSize: 12
                    font.bold: true
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    anchors.fill: parent
                }
            }
        }
    }

    StackView {
        id: stack
        objectName: "stack"
        anchors.fill: parent
        anchors.margins: 6
        Component.onCompleted: function() {
            stack.push(converter)
            stack.push(calculator)
        }
        signal changed()

        delegate: StackViewDelegate {
            function transitionFinished(properties)
            {
                properties.exitItem.opacity = 1
                stack.changed()
            }

            pushTransition: StackViewTransition {
                PropertyAnimation {
                    target: enterItem
                    property: "opacity"
                    from: 0
                    to: 1
                }
                PropertyAnimation {
                    target: exitItem
                    property: "opacity"
                    from: 1
                    to: 0
                }
            }
        }
    }

    Component {
        id: calculator

        ColumnLayout {
            id: cl_calc

            Shortcut {
                id: shortcut_enter
                objectName: "shortcut_enter"
                sequence: "Enter"
            }

            Shortcut {
                id: shortcut_del
                objectName: "shortcut_del"
                sequence: "Delete"
            }

            TextField {
                id: tf_calc_in
                objectName: "tf_calc_in"
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                font.pointSize: 18
                placeholderText: qsTr("0")
                validator: RegExpValidator { regExp: /[\d+\.\d+|\d+\+,\-,\*,\/]+\d+|sqrt\(\d+\)/ }
                horizontalAlignment: TextInput.AlignRight
            }

            GridLayout {
                id: gridLayout1
                width: 100
                height: 100
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Layout.fillHeight: true
                Layout.fillWidth: true
                columnSpacing: 4
                rowSpacing: 4
                rows: 5
                columns: 4

                Button {
                    id: btn_ac
                    objectName: "btn_ac"
                    text: qsTr("AC")
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    tooltip: "Clears the calculator "
                    style: calcBtn_bold
                }

                Button {
                    id: btn_div
                    objectName: "btn_div"
                    text: qsTr("/")
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    style: calcBtn
                }

                Button {
                    id: btn_mult
                    objectName: "btn_mult"
                    text: qsTr("*")
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    style: calcBtn
                }

                Button {
                    id: btn_sub
                    objectName: "btn_sub"
                    text: qsTr("-")
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    style: calcBtn
                }

                Button {
                    id: btn_one
                    objectName: "btn_one"
                    text: qsTr("1")
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    style: calcBtn
                }

                Button {
                    id: btn_two
                    objectName: "btn_two"
                    text: qsTr("2")
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    style: calcBtn
                }

                Button {
                    id: btn_three
                    objectName: "btn_three"
                    text: qsTr("3")
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    style: calcBtn
                }

                Button {
                    id: btn_add
                    objectName: "btn_add"
                    text: qsTr("+")
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    style: calcBtn
                }

                Button {
                    id: btn_four
                    objectName: "btn_four"
                    text: qsTr("4")
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    style: calcBtn
                }

                Button {
                    id: btn_five
                    objectName: "btn_five"
                    text: qsTr("5")
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    style: calcBtn
                }

                Button {
                    id: btn_six
                    objectName: "btn_six"
                    text: qsTr("6")
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    style: calcBtn
                }

                Button {
                    id: btn_pow
                    objectName: "btn_pow"
                    text: qsTr("**")
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    style: calcBtn
                }

                Button {
                    id: btn_seven
                    objectName: "btn_seven"
                    text: qsTr("7")
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    style: calcBtn
                }

                Button {
                    id: btn_eight
                    objectName: "btn_eight"
                    text: qsTr("8")
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    style: calcBtn
                }

                Button {
                    id: btn_nine
                    objectName: "btn_nine"
                    text: qsTr("9")
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    style: calcBtn
                }

                Button {
                    id: btn_sqrt
                    objectName: "btn_sqrt"
                    text: qsTr("sqrt(...)")
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    style: calcBtn
                }

                Button {
                    id: btn_brackets
                    objectName: "btn_brackets"
                    text: qsTr("(...)")
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    style: calcBtn
                }

                Button {
                    id: btn_zero
                    objectName: "btn_zero"
                    text: qsTr("0")
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    style: calcBtn
                }

                Button {
                    id: btn_comma
                    objectName: "btn_comma"
                    text: qsTr(".")
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    style: calcBtn
                }

                Button {
                    id: btn_equals
                    objectName: "btn_equals"
                    text: qsTr("=")
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    style: calcBtn_bold
                }
            }
        }
    }

    Component {
        id: converter

        TabView {
            id: tv_conv
            objectName: "tv_conv"
            tabPosition: Qt.BottomEdge
            tabsVisible: true
            frameVisible: true
            signal currency()
            signal distance()
            signal speed()

            onCurrentIndexChanged: function() {
                if (tv_conv.currentIndex < 1)
                    tv_conv.currency()
                else if (tv_conv.currentIndex == 1)
                    tv_conv.distance()
                else
                    tv_conv.speed()
            }

            Tab {
                id: tab_currency
                title: "Currency"

                GridLayout {
                    id: gl_curr
                    anchors.margins: 4
                    anchors.fill: parent
                    columnSpacing: 4
                    rowSpacing: 4
                    rows: 3
                    columns: 3

                    Label {
                        id: lbl_curr_a
                        text: qsTr("Currency (A)")
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                    }

                    ComboBox {
                        id: cmb_curr_a
                        objectName: "cmb_curr_a"
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    }

                    TextField {
                        id: tf_curr_a
                        objectName: "tf_curr_a"
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        Layout.fillWidth: true
                        placeholderText: qsTr("0.0")
                        horizontalAlignment: TextInput.AlignRight
                    }

                    Label {
                        id: lbl_curr_b
                        text: qsTr("Currency (B)")
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                    }

                    ComboBox {
                        id: cmb_curr_b
                        objectName: "cmb_curr_b"
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    }

                    TextField {
                        id: tf_curr_b
                        objectName: "tf_curr_b"
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        Layout.fillWidth: true
                        placeholderText: qsTr("0.0")
                        horizontalAlignment: TextInput.AlignRight
                    }

                    Label {
                        id: lbl_exchange
                        text: qsTr("Exchange rate")
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    }

                    TextField {
                        id: tf_exchange
                        objectName: "tf_exchange"
                        readOnly: true
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        placeholderText: qsTr("0.0")
                        horizontalAlignment: TextInput.AlignRight
                    }

                    RowLayout {
                        id: columnLayout1
                        width: 100
                        height: 100
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        Layout.fillWidth: true

                        Button {
                            id: btn_refresh
                            objectName: "btn_refresh"
                            tooltip: "Attempts to refresh the currency exchange rates from a web service"
                            style: ButtonStyle {
                                label: Rectangle {
                                    implicitHeight: 26
                                    color: "transparent"
                                    Image {
                                        id: syncImg
                                        source: "./img/sync.png"
                                        anchors {
                                            horizontalCenter: parent.horizontalCenter;
                                            verticalCenter: parent.verticalCenter
                                        }
                                    }
                                }
                            }
                        }

                        Button {
                            id: btn_convert
                            objectName: "btn_convert"
                            text: qsTr("Convert")
                            Layout.fillWidth: true
                            tooltip: "Convert Currency (A) Value to Currency (B)"
                            style: calcBtn
                        }
                    }
                }
            }

            Tab {
                id: tab_distance
                title: "Distance"

                GridLayout {
                    id: gl_dist
                    anchors.margins: 4
                    anchors.fill: parent
                    columnSpacing: 4
                    rowSpacing: 4
                    rows: 2
                    columns: 3

                    Label {
                        id: lbl_dist_a
                        text: qsTr("Distance (A)")
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    }

                    ComboBox {
                        id: cmb_dist_a
                        objectName: "cmb_dist_a"
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    }

                    TextField {
                        id: tf_dist_a
                        objectName: "tf_dist_a"
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        Layout.fillWidth: true
                        placeholderText: qsTr("0.0")
                        horizontalAlignment: TextInput.AlignRight
                    }

                    Label {
                        id: lbl_dist_b
                        text: qsTr("Distance (B)")
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    }

                    ComboBox {
                        id: cmb_dist_b
                        objectName: "cmb_dist_b"
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    }

                    TextField {
                        id: tf_dist_b
                        objectName: "tf_dist_b"
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        Layout.fillWidth: true
                        placeholderText: qsTr("0.0")
                        horizontalAlignment: TextInput.AlignRight
                    }
                }
            }

            Tab {
                id: tab_speed
                title: "Speed"

                GridLayout {
                    id: gl_speed
                    anchors.margins: 4
                    anchors.fill: parent
                    columnSpacing: 4
                    rowSpacing: 4
                    rows: 2
                    columns: 3

                    Label {
                        id: lbl_speed_a
                        text: qsTr("Speed (A)")
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    }

                    ComboBox {
                        id: cmb_speed_a
                        objectName: "cmb_speed_a"
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    }

                    TextField {
                        id: tf_speed_a
                        objectName: "tf_speed_a"
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        Layout.fillWidth: true
                        placeholderText: qsTr("0.0")
                        horizontalAlignment: TextInput.AlignRight
                    }

                    Label {
                        id: lb_speed_b
                        text: qsTr("Speed (B)")
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    }

                    ComboBox {
                        id: cmb_speed_b
                        objectName: "cmb_speed_b"
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    }

                    TextField {
                        id: tf_speed_b
                        objectName: "tf_speed_b"
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        Layout.fillWidth: true
                        placeholderText: qsTr("0.0")
                        horizontalAlignment: TextInput.AlignRight
                    }
                }
            }
        }
    }
}
