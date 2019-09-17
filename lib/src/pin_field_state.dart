import 'dart:async';

enum PinFieldState { DEFAULT, SUCCESS, ERROR }

final bloc = PinFieldStateBloc._();

setStateToSuccessful() {
  bloc._changeState(PinFieldState.SUCCESS);
}

setStateToDefault() {
  bloc._changeState(PinFieldState.DEFAULT);
}

setStateToError() {
  bloc._changeState(PinFieldState.ERROR);
}

disposePinField(){
  bloc._dispose();
}

class PinFieldStateBloc {
  PinFieldStateBloc._();

  StreamController _stateController = StreamController<PinFieldState>.broadcast();

  Stream<PinFieldState> get stream {
    _stateController ??= StreamController<PinFieldState>.broadcast();
    return _stateController.stream;
  }

  _changeState(PinFieldState _state) {
    _stateController.sink.add(_state);
  }

  _dispose() {
    _stateController?.close();
    _stateController = null;
  }
}
