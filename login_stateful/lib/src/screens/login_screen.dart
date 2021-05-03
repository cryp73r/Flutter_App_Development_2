import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
// Key for widget controller
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20.0),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            emailField(),
            passwordField(),
            submitButton(),
          ],
        ),
      ),
    );
  }
  Widget emailField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: "Email Address",
        hintText: "you@example.com"
      ),
      validator: (String value) {
        if (!value.contains("@")) {
          return "Please Enter a Valid Email";
        }
        return null;
      },
      onSaved: (String value) {
        print(value);
      },
    );
  }

  Widget passwordField() {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "Password",
      ),
        validator: (String value) {
          if (value.length < 8) {
            return "Password length must be 8 Characters or more.";
          }
          return null;
        },
      onSaved: (String value) {
        print(value);
      },
    );
  }

  Widget submitButton() {
    return ElevatedButton(
        onPressed: () {
          if (formKey.currentState.validate()) {
            formKey.currentState.save();
            formKey.currentState.reset();
          }
          else {
            debugPrint("Not Valid!");
          }
        },
        child: Text("Submit"),
    );
  }
}
