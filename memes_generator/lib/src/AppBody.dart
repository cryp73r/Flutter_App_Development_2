import 'package:flutter/material.dart';
import 'package:memes_generator/utils/utils.dart';

class AppBody extends StatefulWidget {
  @override
  _AppBodyState createState() => _AppBodyState();
}

class _AppBodyState extends State<AppBody> {
  final formKey = GlobalKey<FormState>();
  String dropDownValue;
  String top="";
  String bottom="";
  String apiUrl = "";
  bool loaded = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Column(
        children: [
          Form(
            child: Column(
              children: [
                memesOption(),
                topTittle(),
                bottomTittle(),
                Padding(padding: EdgeInsets.only(bottom: 30.0),),
                imageWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget memesOption() {
    return DropdownButton(
      onChanged: (String newValue) {
        setState(() {
          dropDownValue = newValue;
          apiUrl = getImage();
        });
      },
      items: optionsList.map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value, style: TextStyle(fontSize: 14.265),),
      );
    }).toList(),
      hint: Text("Please Choose Meme Template"),
      value: dropDownValue,
    );
  }

  Widget topTittle() {
    return TextFormField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Top Text",
        hintText: "Boom Boom"
      ),
      onChanged: (String value) {
        setState(() {
          top = value;
          apiUrl = getImage();
        });
      },
    );
  }

  Widget bottomTittle() {
    return TextFormField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          labelText: "Bottom Text",
          hintText: "Bingo"
      ),
      onChanged: (String value) {
        setState(() {
          bottom = value;
          apiUrl = getImage();
        });
      },
    );
  }

  Widget imageWidget() {
    return Container(
      child: loaded ? Image.network(apiUrl) : Text("Crafted with ❤ by CRYP73R"),
    );
  }

String getImage() {
    var apiUrl;
    setState(() {
      apiUrl = "http://apimeme.com/meme?meme=$dropDownValue&top=$top&bottom=$bottom";
      loaded = true;
    });
    return apiUrl;
}
}
