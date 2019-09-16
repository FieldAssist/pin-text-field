import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_text_field/src/pin_field_state.dart';
import 'package:pin_text_field/src/pin_input_formatter.dart';
import 'package:pin_text_field/src/pin_text_field_style.dart';
export 'pin_text_field_style.dart';

class PinTextField extends StatefulWidget {
  final int size;
  final Function(String) onDone;
  final PinTextFieldStyle style;

  const PinTextField({
    Key key,
    @required this.onDone,
    this.size: 4,
    @required this.style,
  }) : super(key: key);

  @override
  _PinTextFieldState createState() => _PinTextFieldState();
}

class _PinTextFieldState extends State<PinTextField> {
  List<FocusNode> _focusNodes;
  List<TextEditingController> _controllers;
  List<PinInputFormatter> _listeners = [];

  @override
  void initState() {
    super.initState();
    setStateToDefault();
    _focusNodes = List.generate(widget.size, (index) => FocusNode());
    _controllers =
        List.generate(widget.size, (index) => TextEditingController(text: '*'));

    for (int index = 0; index < widget.size; index++) {
      _listeners.add(PinInputFormatter((previous, current) {
        if (index > 0 && previous == "*" && current.isEmpty) {
          _focusNodes[index].unfocus();
          if(index == widget.size - 1) setStateToDefault();
          FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
        }
      }));
    }
  }

  @override
  void dispose() {
    _focusNodes.forEach((node) => node.dispose());
    _controllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    assert(widget.onDone != null, "onDone callback is required!");

    if (_focusNodes[0].hasFocus) {
      _focusNodes[0].unfocus();
      FocusScope.of(context).requestFocus(_focusNodes[0]);
    }
    return StreamBuilder<PinFieldState>(
        stream: bloc.stream,
        initialData: PinFieldState.DEFAULT,
        builder: (context, snapshot) {
          return Container(
            decoration: widget.style.decoration,
            margin: widget.style.margin,
            padding:  widget.style.padding,
            child: Center(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: List.generate(
                    widget.size,
                    (index) => SizedBox(
                        height: widget.style.fieldHeight,
                        width: widget.style.fieldWidth,
                        child: Center(
                          child: TextField(
                              textAlign: TextAlign.center,
                              textAlignVertical: TextAlignVertical.center,
                              buildCounter: (BuildContext context,
                                      {int currentLength,
                                      int maxLength,
                                      bool isFocused}) =>
                                  null,
                              key: Key('PinInput_$index'),
                              autofocus: index == 0,
                              obscureText: widget.style.isObscure ?? false,
                              focusNode: _focusNodes[index],
                              decoration: widget.style.fieldDecoration.copyWith(
                                counterText: '',
                                counterStyle: TextStyle(fontSize: 0),
                                enabledBorder: widget
                                    .style.fieldDecoration.enabledBorder
                                    .copyWith(
                                  borderSide: BorderSide(
                                    color: widget.style
                                        .indicatorColor(snapshot.data),
                                    width: widget.style.indicatorWidth,
                                  ),
                                ),
                                focusedBorder: widget
                                    .style.fieldDecoration.focusedBorder
                                    .copyWith(
                                  borderSide: BorderSide(
                                    color: widget.style
                                        .indicatorColor(snapshot.data),
                                    width: widget.style.indicatorWidth,
                                  ),
                                ),
                                isDense: true
                              ),
                              maxLength: 1,
                              controller: _controllers[index],
                              textInputAction: TextInputAction.next,
                              inputFormatters: [_listeners[index]],
                              onChanged: (value) {
                                setState(() {});
                                if (value.isNotEmpty && value != "*") {
                                  if (index < widget.size - 1) {
                                    _focusNodes[index].unfocus();
                                    FocusScope.of(context)
                                        .requestFocus(_focusNodes[index + 1]);
                                  } else {
                                    if (_controllers.every((controller) =>
                                        controller.text.isNotEmpty)) {
                                      final _pin = _controllers
                                          .map((controller) => controller.text)
                                          .join();
                                      print(_pin);
                                      widget.onDone(_pin);
                                    }
                                  }
                                }
                              },
                              cursorColor: Colors.black,
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                  fontSize: widget.style.isObscure
                                      ? widget.style.obscureFontSize
                                      : widget.style.fontSize,
                                  color: _controllers[index].text == '*'
                                      ? Colors.grey[50]
                                      : widget.style.textColor(snapshot.data))),
                        )),
                  )),
            ),
          );
        });
  }
}
