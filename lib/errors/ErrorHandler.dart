import 'dart:async';

class ErrorHandler {
  final errors = StreamController<Exception>();

  handleError(String message) {
    errors.add(Exception(message));
  }

  handleException(Exception exception) {
    errors.add(exception);
  }
}
