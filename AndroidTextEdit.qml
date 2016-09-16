import QtQuick 2.4
import QtQuick.Controls 1.2 as Control
import QtQuick.Controls.Styles 1.3 as ControlSyles
import QuickAndroid.Styles 0.1
import QuickAndroid 0.1
import QuickAndroid.Private 0.1
Control.TextArea {
    id: textField

    property string floatingLabelText: ""

    property bool floatingLabelAlwaysOnTop: false;

    property TextFieldMaterial material: ThemeManager.currentTheme.textField

    /// The color of underline and floating text label on focus
    property color color: material.color

    readonly property bool hasFloatingLabel : floatingLabelText !== ""

    property color placeholderTextColor: material.placeholderTextColor

    font.pixelSize: material.text.textSize

    font.bold: material.text.bold

    height: (hasFloatingLabel ? 72 * A.dp : 48 * A.dp) + _fontDiff

    verticalAlignment: Text.AlignTop

    textColor: material.text.textColor

    property real _fontDiff : Math.max(font.pixelSize - 16 * A.dp,0);

//    FloatingActionButton {
//        id: pasteButton
//        cursorRect: cursorRectangle;
//        onClicked: paste();

//    }

//    MouseSensor {
//        enabled: canPaste
//        filter: textField
//        onPressAndHold: {
//            pasteButton.openAt();
//        }
//        z: 10000
//    }

//    onTextChanged: pasteButton.close();

    style: TextFieldMaterialStyle { }
}
