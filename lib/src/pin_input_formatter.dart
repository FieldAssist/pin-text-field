import 'package:flutter/services.dart';

class PinInputFormatter extends TextInputFormatter {
  final Function(String, String) onBack;

  PinInputFormatter(this.onBack);
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    onBack(oldValue.text, newValue.text);
    return TextEditingValue(
      text: newValue.text.isEmpty
          ? '*'
          : newValue.text.length > 1 ? newValue.text[1] : newValue.text,
      selection: TextSelection(extentOffset: 1, baseOffset: 1),
    );
  }
}
