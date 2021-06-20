import 'package:flutter/material.dart';
import 'package:online_class_schedule/src/apiDataHandler/getJsonData.dart';
import 'package:online_class_schedule/src/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateAppScreen extends StatefulWidget {
  const UpdateAppScreen({Key key}) : super(key: key);

  @override
  _UpdateAppScreenState createState() => _UpdateAppScreenState();
}

class _UpdateAppScreenState extends State<UpdateAppScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
          future: getJsonData(apiUrlVer),
          builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
            if (snapshot.hasData) {
              Map rawData = snapshot.data;
              return successWidget(rawData);
            }
            return Center(child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Container(margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),),
                  Text("Checking for Updates...",
                    style: TextStyle(
                      letterSpacing: 2.0,
                    ),
                  )
                ],
              ),
            ),);
          }
      ),
    );
  }

  Widget successWidget(Map rawData) {
    return Column(
      children: [
        Flexible(
            child: ListView(
              padding: const EdgeInsets.all(8.0),
              children: [
                Image.asset(
                    "images/ic_launcher.png",
                  width: 140.0,
                  height: 140.0,
                ),
                Container(margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),),
                Center(child: appVer==rawData["ver"]?Text("No Updates Available", style: updateStyle(),):Text("New Update Available", style: updateStyle(),)),
                Container(margin: const EdgeInsets.only(top: 4.0, bottom: 4.0),),
                Center(child: appVer==rawData["ver"]?Text(appVer, style: newVerStyle(),):Text("New App Version: " + rawData["ver"], style: newVerStyle(),)),
                Container(margin: const EdgeInsets.only(top: 2.0, bottom: 2.0),),
                Center(child: appVer==rawData["ver"]?Text(""):Text("Current Version: " + appVer, style: curVerStyle(),)),
              ],
            )
        ),
        appVer==rawData["ver"]?Text(""):Expanded(
          child: Align(
            alignment: FractionalOffset.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                          )
                      )
                    ),
                    onPressed: () async {
                      String _sourceUrl = "https://ocs.pythonanywhere.com" + rawData["url"];
                      if (await canLaunch(_sourceUrl)) {
                      await launch(_sourceUrl);
                      } else {
                      throw 'Could not launch';
                      }
                    },
                    child: Text("Download Now (" + rawData["size"] + ")", style: TextStyle(fontSize: 17.0),))
              ],
            ),
          ),
        ),
      ],
    );
  }

  TextStyle updateStyle() {
    return TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.w700,
      letterSpacing: 4.0,
    );
  }

  TextStyle newVerStyle() {
    return TextStyle(
      fontSize: 15.0,
      color: Colors.white60,
      fontWeight: FontWeight.w400,
    );
  }

  TextStyle curVerStyle() {
    return TextStyle(
      fontSize: 15.0,
      color: Colors.white54,
      fontWeight: FontWeight.w300,
    );
  }
}