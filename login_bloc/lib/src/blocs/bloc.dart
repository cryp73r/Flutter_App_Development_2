import 'dart:async';
import 'package:flutter/material.dart';
import 'package:login_bloc/src/blocs/validators.dart';
import 'package:rxdart/rxdart.dart';

class Bloc extends Object with Validators {
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  // Add data to stream
  Stream<String> get email => _emailController.stream.transform(validateEmail);
  Stream<String> get password => _passwordController.stream.transform(validatePassword);
  Stream<bool> get submitValid => CombineLatestStream.combine2(email, password, (a, b) => true);


  // Change data
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  submit() {
    final validEmail = _emailController.value;
    final validPassword = _passwordController.value;
    debugPrint("Email: $validEmail");
    debugPrint("Password: $validPassword");
}

  dispose() {
    _emailController.close();
    _passwordController.close();
  }
}

final bloc = Bloc();