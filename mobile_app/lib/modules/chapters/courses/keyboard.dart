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
  bool isNumericMode = false;
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
            SwitchListTile(
              title: Text(
                'Keyboard Type = ' +
                    (isNumericMode
                        ? 'VirtualKeyboardType.Numeric'
                        : 'VirtualKeyboardType.Alphanumeric'),
              ),
              value: isNumericMode,
              onChanged: (val) {
                setState(() {
                  isNumericMode = val;
                });
              },
            ),
            Expanded(
              child: Container(),
            ),
            // Clavier virtuel
            Container(
              color: Colors.deepPurple,
              child: VirtualKeyboard(
                height: 300,
                textColor: Colors.white,
                textController: _controllerText,
                defaultLayouts: [
                  VirtualKeyboardDefaultLayouts.English,
                  VirtualKeyboardDefaultLayouts.Arabic,
                ],
                type: isNumericMode
                    ? VirtualKeyboardType.Numeric
                    : VirtualKeyboardType.Alphanumeric,
                postKeyPress: _onKeyPress,
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