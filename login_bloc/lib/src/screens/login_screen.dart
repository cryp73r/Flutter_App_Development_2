import 'package:flutter/material.dart';
import 'package:login_bloc/src/blocs/bloc.dart';

final bloc = Bloc();

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          emailField(),
          passwordField(),
          Container(margin: const EdgeInsets.only(top: 25.0),),
          loginButton(),
        ],
      ),
    );
  }

  Widget emailField() {
    return TextField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: "you@example.com",
        labelText: "Email Address",
        errorText: "Invalid Email"
      ),
    );
  }

  Widget passwordField() {
    return TextField(
      decoration: InputDecoration(
        hintText: "Password",
        labelText: "Password",
      ),
      // obscureText: true,
    );
  }

  Widget loginButton() {
    return ElevatedButton(
        onPressed: () => debugPrint("Submit Pressed"),
        child: Text("Login")
    );
  }
}
