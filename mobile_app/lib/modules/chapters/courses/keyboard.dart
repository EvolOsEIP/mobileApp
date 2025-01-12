import 'package:flutter/material.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

class TextInputPage extends StatefulWidget {
  final String title;
  const TextInputPage({Key? key, required this.title}) : super(key: key);

  @override
  _TextInputPageState createState() => _TextInputPageState();
}

class _TextInputPageState extends State<TextInputPage> {
  String text = '';
  bool shiftEnabled = false;
  late TextEditingController _controllerText;

  @override
  void initState() {
    _controllerText = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            // Affichage du texte saisi
            Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            // Affichage du texte de TextController
            Text(
              _controllerText.text,
              style: TextStyle(color: Colors.red),
            ),
            // Switch pour basculer entre le mode numérique et alphanumérique
            Expanded(
              child: Container(),
            ),
            // Clavier virtuel
            Container(
              color: Colors.grey,
              child: VirtualKeyboard(
                // Default height is 300
                  height: 350,
                  // Default height is will screen width
                  width: 600,
                  // Default is black
                  textColor: Colors.white,
                  // Default 14
                  fontSize: 20,
                  // the layouts supported
                  defaultLayouts: [VirtualKeyboardDefaultLayouts.English],
                  // All types
                  type: VirtualKeyboardType.Custom,
                  // Layout separated by rows
                  keys: const [
                    ["T", "E", "S", "T"],
                    ["C", "U", "S", "T", "O", "M"],
                    ["L", "A", "Y", "O", "U", "T"],
                    ["RETURN", "SHIFT", "BACKSPACE", "SPACE"],
                  ],
                  // Callback for key press event
                  onKeyPress: _onKeyPress),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// Fonction appelée lors de l'appui sur une touche du clavier virtuel.
  _onKeyPress(VirtualKeyboardKey key) {
    if (key.keyType == VirtualKeyboardKeyType.String) {
      text = text + ((shiftEnabled ? key.capsText : key.text) ?? '');
    } else if (key.keyType == VirtualKeyboardKeyType.Action) {
      switch (key.action) {
        case VirtualKeyboardKeyAction.Backspace:
          if (text.length == 0) return;
          text = text.substring(0, text.length - 1);
          break;
        case VirtualKeyboardKeyAction.Return:
          text = text + '\n';
          break;
        case VirtualKeyboardKeyAction.Space:
          text = text + (key.text ?? '');
          break;
        case VirtualKeyboardKeyAction.Shift:
          shiftEnabled = !shiftEnabled;
          break;
        default:
      }
    }
    // Mettre à jour l'affichage
    setState(() {});
  }
}