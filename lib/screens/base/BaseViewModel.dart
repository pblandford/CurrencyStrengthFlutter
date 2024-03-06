import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:fluttersandpit/errors/ErrorHandler.dart';
import 'package:get_it/get_it.dart';
import 'package:view_model_x/view_model_x.dart';

class BaseViewModel extends ViewModel {
  final _errorHandler = GetIt.I<ErrorHandler>();

  @protected
  Future<T> usecase<T>(Future<T> Function() function) {
    return function().catchError((err) {
      _handleError(err);
    });
  }

  void _handleError<T>(dynamic error) {
    print(error);
    _errorHandler.handleError(error.toString());
  }
}
