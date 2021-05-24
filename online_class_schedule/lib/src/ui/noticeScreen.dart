import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:online_class_schedule/src/apiDataHandler/getJsonNoticeData.dart';
import 'package:online_class_schedule/src/utils/utils.dart';

class NoticeScreen extends StatefulWidget {
  const NoticeScreen({Key key}) : super(key: key);

  @override
  _NoticeScreenState createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notice Board"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: getJsonNoticeData(apiUrlNotice),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          if (snapshot.hasData) {
            Map rawData = snapshot.data;
            return successWidget(rawData);
          }
          return Center(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Container(
                    margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                  ),
                  Text(
                    "Sit Tight & Relax - Getting Notices...",
                    style: TextStyle(
                      letterSpacing: 2.0,
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget successWidget(Map rawData) {
    return Column(
      children: [
        Flexible(child: ListView.builder(
          padding: const EdgeInsets.all(8.0),
            reverse: false,
            itemCount: rawData["data"].length,
            itemBuilder: (_, int index) {
            return Wrap(
              direction: Axis.horizontal,
              children: [
                Card(
                  color: Colors.white10,
                  child: ListTile(
                    title: Text(rawData["data"][index]["department"], style: TextStyle(color: Color(0xFFDF8B00)),),
                    subtitle: Text(
                        "Dated: ${DateFormat.yMMMMd('en_US').format(DateTime(int.parse(rawData["data"][index]["date"].substring(0, 4)), int.parse(rawData["data"][index]["date"].substring(5, 7)), int.parse(rawData["data"][index]["date"].substring(8, 10))))}\n\n"+
                            rawData["data"][index]["message"]+"\n\n"+
                            rawData["data"][index]["designation"]+"\n"+
                            rawData["data"][index]["signatory"]
                    ),
                  ),
                ),
                Divider(
                  height: 5.0,
                )
              ],
            );
            }
        )),
        Divider(
          height: 5.0,
        )
      ],
    );
  }
}
