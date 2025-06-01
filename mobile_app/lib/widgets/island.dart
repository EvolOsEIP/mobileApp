import 'package:flutter/material.dart';
import 'package:mobile_app/utils/hexagon_item.dart';
import 'package:mobile_app/utils/colors.dart';

class IslandWidget extends StatelessWidget {
  final String hexLabel;
  final String title;
  final String description;
  final VoidCallback onTapAction;
  final String buttonText;
  final int state;
  final Key? keyRef;

  const IslandWidget({
    super.key,
    required this.hexLabel,
    required this.title,
    required this.description,
    required this.onTapAction,
    required this.buttonText,
    required this.state,
    this.keyRef,
  });

  Color getHexColor() {
    switch (state) {
      case 0:
        return Colors.green;
      case 1:
        return CustomColors.accent;
      case 2:
        return Colors.grey.shade400;
      default:
        return CustomColors.accent;
    }
  }

  Color getBorderColor() {
    switch (state) {
      case 0:
        return Colors.green;
      case 1:
        return const Color.fromRGBO(55, 190, 240, 1);
      case 2:
        return Colors.grey;
      default:
        return const Color.fromRGBO(55, 190, 240, 1);
    }
  }

  bool isLocked() => state == 2;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: keyRef,
      child: HexagonItem(
        hexLabel : hexLabel,
        title: title,
        description: description,
        onTapAction: onTapAction,
        buttonText: buttonText,
        hexColor: getHexColor(),
        borderColor: getBorderColor(),
      ),
    );
  }
}
