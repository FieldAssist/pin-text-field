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

class PinFieldStateBloc {
  PinFieldStateBloc._();

  StreamController _stateController = StreamController<PinFieldState>();

  Stream<PinFieldState> get stream => _stateController.stream;

  _changeState(PinFieldState _state) {
    _stateController.sink.add(_state);
  }

  dispose() {
    _stateController?.close();
  }
}
