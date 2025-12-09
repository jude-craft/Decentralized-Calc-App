import 'package:flutter/material.dart';

enum ButtonType {
  number,
  operator,
  special,
  equals,
}

class CalculatorButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final ButtonType type;
  final bool isEnabled;

  const CalculatorButton({
    super.key,
    required this.label,
    this.onTap,
    this.type = ButtonType.number,
    this.isEnabled = true,
  });

  Color get _backgroundColor {
    switch (type) {
      case ButtonType.operator:
        return const Color(0xFF505050);
      case ButtonType.special:
        return const Color(0xFFA5A5A5);
      case ButtonType.equals:
        return Colors.blueAccent;
      case ButtonType.number:
        return const Color(0xFF3A3A3A);
    }
  }

  Color get _textColor {
    return type == ButtonType.special ? Colors.black : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _backgroundColor.withOpacity(isEnabled ? 1.0 : 0.5),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: isEnabled ? onTap : null,
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: type == ButtonType.equals ? 28 : 32,
              fontWeight: FontWeight.w400,
              color: _textColor,
            ),
          ),
        ),
      ),
    );
  }
}