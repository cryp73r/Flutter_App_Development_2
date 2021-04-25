import 'package:flutter/material.dart';

// StatelessWidget Starting.
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => debugPrint("Action Button Pressed"),
        ),
        appBar: AppBar(
          title: Text("Let's see Images"),
        ),
      ),
    );
  }
}
