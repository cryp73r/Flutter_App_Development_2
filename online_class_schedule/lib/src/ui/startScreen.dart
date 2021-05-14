import 'package:flutter/material.dart';
import 'package:online_class_schedule/src/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({Key key}) : super(key: key);

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {

  _setRollNumber(String strRollNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString("strRollNo", strRollNumber);
    });
  }

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        resizeToAvoidBottomInset: false,
        body: Container(
          padding: const EdgeInsets.all(10.0),
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
              Container(margin: const EdgeInsets.only(top: 60.0, bottom: 60.0),),
              Form(key: formKey, child: Column(
                children: [
                  rollNoField(),
                  Container(margin: const EdgeInsets.only(top: 15.0, bottom: 15.0),),
                  goButton(),
                ],
              )),
              Expanded(
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        child: Text("Report a Problem🐞",
                          style: TextStyle(
                            fontSize: 14.7,
                            color: Colors.deepPurpleAccent
                          ),
                        ),
                        onTap: () async {
                          if (await canLaunch(reportPrbUrl)) {
                            await launch(reportPrbUrl);
                          } else {
                            throw "Could not launch";
                          }
                        },
                      ),
                      Container(margin: const EdgeInsets.only(top: 8.0, bottom: 8.0),),
                      Text("Crafted with ❤ by CRYP73R",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                      ),
                      Container(margin: const EdgeInsets.only(top: 0.7, bottom: 0.7),),
                      Text(appVer,
                        style: TextStyle(
                          fontSize: 11.0,
                          color: Colors.white60,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
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
        if (!value.startsWith("1901220100") && !value.startsWith("1901220130")) {
          return "Please Enter a Valid Roll Number";
        }
        else if (value.length!=13) {
          return "Please Enter a Valid 13-digit Roll Number";
        }
        else if (value.startsWith("1901220100") && int.parse(value.substring(10))>145) {
          return "Max. Roll Number Exceeded\n\n1) CS41 -> 001 - 028\n2) CS42 -> 029 - 057\n3) CS43 -> 058 - 086\n4) CS44 -> 087 - 117\n5) CS45 -> 118 - 145";
        }
        else if (value.startsWith("1901220130") && int.parse(value.substring(10))>134) {
          return "Max. Roll Number Exceeded\n\n1) IT41 -> 001 - 033\n2) IT42 -> 034 - 067\n3) IT43 -> 068 - 100\n4) IT44 -> 101 - 134";
        }
        return null;
      },
      onSaved: (String value) {
        _setRollNumber(value);
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
            Navigator.pushReplacementNamed(context, "/detailScreen");
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