import 'package:flutter/material.dart';

class AppBody extends StatefulWidget {
  @override
  _AppBodyState createState() => _AppBodyState();
}

class _AppBodyState extends State<AppBody> {
  String dropDownValue = "10-Guy";
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Column(
        children: [
          Form(
            child: Column(
              children: [
                memesOption(dropDownValue),
                topTittle(),
                bottomTittle(),
                submitButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget memesOption(String dropDownValue) {
    List<String> optionsList = ["10-Guy", "1950s-Middle-Finger", "1990s-First-World-Problems"];
    return DropdownButton(
      value: dropDownValue,
      onChanged: (String newValue) {
        setState(() {
          dropDownValue = newValue;
          debugPrint(newValue);
        });
      },
      items: optionsList.map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList(),
    );
  }

  Widget topTittle() {
    return TextFormField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Top Text",
        hintText: "Boom Boom"
      ),
    );
  }

  Widget bottomTittle() {
    return TextFormField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          labelText: "Bottom Text",
          hintText: "Bingo"
      ),
    );
  }

  Widget submitButton() {
    return ElevatedButton(
        onPressed: () => debugPrint("Submit Pressed"),
        child: Text("Submit")
    );
  }
}
