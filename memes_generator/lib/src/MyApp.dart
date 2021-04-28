import 'package:flutter/material.dart';
import 'package:memes_generator/src/AppBody.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: Text("Memes Generator"),
              backgroundColor: Colors.black54,
            ),
            resizeToAvoidBottomInset: false,
            body: AppBody()
        )
    );
  }
}





