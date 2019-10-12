import 'dart:async';

abstract class BaseBloc<T> {
  StreamController<T> _controller;

  T bean;

  Stream<T> get data => _controller.stream;

  BaseBloc() {
    _controller = new StreamController();
  }

  void dispose() {
    _controller.close();
  }

  void notifyDataChanged() {
    _controller.sink.add(bean);
  }

  void reset() {
    bean = null;
    notifyDataChanged();
  }
}
