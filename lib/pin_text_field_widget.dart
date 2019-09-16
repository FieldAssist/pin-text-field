import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_text_field/pin_field_state.dart';
import 'package:pin_text_field/pin_input_formatter.dart';
import 'package:pin_text_field/pin_text_field_style.dart';
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
      _listeners.add(PinInputFormatter());
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
            padding: widget.style.padding,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  widget.size,
                  (index) => Container(
                      height: widget.style.fieldHeight,
                      width: widget.style.fieldWidth,
                      child: TextField(
                          textAlign: TextAlign.center,
                          key: Key('PinInput_$index'),
                          autofocus: index == 0,
                          obscureText: widget.style.isObscure ?? false,
                          focusNode: _focusNodes[index],
                          decoration: InputDecoration(
                            counter: SizedBox(),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    widget.style.indicatorColor(snapshot.data),
                                width: widget.style.indicatorWidth,
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    widget.style.indicatorColor(snapshot.data),
                                width: widget.style.indicatorWidth,
                              ),
                            ),
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
                            } else {
                              if (index > 0) {
                                _focusNodes[index].unfocus();
                                FocusScope.of(context)
                                    .requestFocus(_focusNodes[index - 1]);
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
                                  : widget.style.textColor))),
                )),
          );
        });
  }
}
