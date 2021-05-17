import 'package:flutter/material.dart';
import 'package:login_bloc/src/blocs/bloc.dart';

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
          Container(
            margin: const EdgeInsets.only(top: 25.0),
          ),
          loginButton(),
        ],
      ),
    );
  }

  Widget emailField() {
    return StreamBuilder(
        stream: bloc.email,
        builder: (context, snapshot) {
          return TextField(
            onChanged: bloc.changeEmail,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: "you@example.com",
              labelText: "Email Address",
              errorText: snapshot.error,
            ),
          );
        });
  }

  Widget passwordField() {
    return StreamBuilder(
      stream: bloc.password,
        builder: (context, snapshot) {
          return TextField(
            onChanged: bloc.changePassword,
            decoration: InputDecoration(
              hintText: "Password",
              labelText: "Password",
              errorText: snapshot.error,
            ),
            // obscureText: true,
          );
        }
    );
  }

  Widget loginButton() {
    return StreamBuilder(
      stream: bloc.submitValid,
        builder: (context, snapshot) {
          return ElevatedButton(
              onPressed: () => snapshot.hasError?null:() => debugPrint("Submitted"),
              child: Text("Login"));
        }
    );
  }
}
