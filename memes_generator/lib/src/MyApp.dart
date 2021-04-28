import 'dart:io';
import 'package:flutter/material.dart';
import 'package:memes_generator/utils/utils.dart';
import 'package:memes_generator/src/AppBody.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        title: "Memes Generator",
        home: Scaffold(
          appBar: AppBar(
            title: Text("Memes Generator"),
            backgroundColor: Colors.black87,
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(Icons.share),
                tooltip: "Share Meme",
                onPressed: () async {
                  if (apiUrl!="") {
                    var response = await http.get(Uri.parse(apiUrl));
                    Directory documentDirectory = await getApplicationDocumentsDirectory();
                    File file = new File(join(documentDirectory.path, 'temp.jpg'));
                    file.writeAsBytesSync(response.bodyBytes);
                    await Share.shareFiles(['${documentDirectory.path}/temp.jpg']);
                  }
                  else {
                    debugPrint("Template Not Selected!");
                  }
                },
              )
            ],
          ),
          resizeToAvoidBottomInset: false,
          body: AppBody(),
        )
    );
  }
}






