import 'package:flutter/material.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({Key key}) : super(key: key);

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Container(
          padding: EdgeInsets.all(10.0),
          alignment: Alignment.center,
          child: Column(
            children: [
              Wrap(
                direction: Axis.horizontal,
                children: [
                  Text("WELCOME",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 45.0,
                      letterSpacing: 10.0
                    ),
                  ),
                ],
              ),
              Container(margin: EdgeInsets.only(top: 60.0, bottom: 60.0),),
              Form(key: formKey, child: Column(
                children: [
                  rollNoField(),
                  Container(margin: EdgeInsets.only(top: 15.0, bottom: 15.0),),
                  goButton(),
                ],
              )),
            ],
          ),
        )
      );
    }

  Widget rollNoField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          labelText: "Roll Number",
          labelStyle: TextStyle(
            color: Colors.redAccent,
            fontSize: 20.0,
            letterSpacing: 4.0
          ),
          hintText: "1901220100XXX",
        hintStyle: TextStyle(
          color: Colors.white54,
          fontStyle: FontStyle.italic,
        ),
        errorStyle: TextStyle(
          fontSize: 16.0,
          fontStyle: FontStyle.italic,
          color: Colors.yellow
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          borderSide: BorderSide(
              color: Colors.redAccent,
            width: 3.0
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
      ),
      validator: (String value) {
        if (!value.contains("1901220100")) {
          return "Please Enter a Valid Roll Number";
        }
        return null;
      },
      onSaved: (String value) {
        debugPrint(value);
      },
    );
  }

  Widget goButton() {
    return ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
        ),
        onPressed: () {
          if (formKey.currentState.validate()) {
            formKey.currentState.save();
            formKey.currentState.reset();
          }
          else {
            debugPrint("Not Valid!");
          }
        },
        child: Icon(
          Icons.arrow_forward,
          size: 40.0,
        )
    );
  }
}