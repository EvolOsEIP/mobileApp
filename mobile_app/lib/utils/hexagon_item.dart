import 'package:flutter/material.dart';
import 'package:hexagon/hexagon.dart';

class HexagonItem extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onTapAction;
  final Color hexColor;
  final Color borderColor;
  final String buttonText;

  const HexagonItem({super.key,
    required this.title,
    required this.description,
    required this.onTapAction,
    required this.hexColor,
    required this.borderColor,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {

    double screenW = MediaQuery.of(context).size.width;
    double size = (screenW * 0.25).clamp(80.0, 150.0);
    double textWidth = (size /6).clamp(12.0, 18.0);

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: borderColor),
            ),
            title: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            content: SizedBox(
              width: screenW * 0.8,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(description, textAlign: TextAlign.center),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onTapAction();
                    },
                    child: Text(buttonText),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      child: HexagonWidget.pointy(
        width: size,
        color: hexColor,
        elevation: 10,
        child: Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: textWidth,
            ),
          ),
        ),
      ),
    );
  }
}
