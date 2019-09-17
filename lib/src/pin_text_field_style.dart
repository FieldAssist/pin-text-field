import 'package:flutter/material.dart';
import 'package:pin_text_field/src/pin_field_state.dart';

const _primaryColor = Color(0xFF0097CD);
const _defaultTextColor = Color(0xDE000000);
const _errorColor = Color(0xFFED3833);
const _successColor = Color(0xFF4BA42A);

class PinTextFieldStyle {
  Map<PinFieldState, Color> _textColor;
  Map<PinFieldState, Color> _indicatorColor;

  final double fontSize;
  final double obscureFontSize;
  final double indicatorWidth;
  final EdgeInsets margin;
  final double fieldWidth;
  final double fieldHeight;
  final bool isObscure;
  final BoxDecoration decoration;
  final InputDecoration fieldDecoration;
  final EdgeInsets padding;

  PinTextFieldStyle({
    this.fontSize: 14,
    this.obscureFontSize: 24,
    this.indicatorWidth: 2.0,
    this.isObscure,
    this.decoration: const BoxDecoration(),
    this.margin: const EdgeInsets.symmetric(horizontal: 60.0),
    this.padding: const EdgeInsets.symmetric(horizontal: 8.0),
    this.fieldWidth: 48.0,
    this.fieldHeight: 48.0,
    this.fieldDecoration: const InputDecoration(border: UnderlineInputBorder()),
    Color primaryColor: _primaryColor,
    Color defaultTextColor: _defaultTextColor,
    Color errorColor: _errorColor,
    Color successColor: _successColor,
  }) {
    _textColor = {
      PinFieldState.DEFAULT: defaultTextColor,
      PinFieldState.SUCCESS: successColor,
      PinFieldState.ERROR: errorColor,
    };

    _indicatorColor = {
      PinFieldState.DEFAULT: primaryColor,
      PinFieldState.SUCCESS: successColor,
      PinFieldState.ERROR: errorColor,
    };
  }

  Color textColor(PinFieldState state) => _textColor[state];
  Color indicatorColor(PinFieldState state) => _indicatorColor[state];
}
