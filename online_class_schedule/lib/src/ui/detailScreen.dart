import 'package:flutter/material.dart';
import 'package:online_class_schedule/src/apiDataHandler/getJsonClassData.dart';
import 'package:online_class_schedule/src/utils/getGroup.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/utils.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({Key key}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  String _group;
  String _strRollNo = "";

  _getRollNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _strRollNo = (prefs.getString("strRollNo") ?? "");
      _group = getGroup(_strRollNo);
    });
  }

  _removeRollNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("strRollNo");
    _strRollNo = "";
  }

  @override
  void initState() {
    _getRollNumber();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Online Class Schedule"),
        centerTitle: true,
        actions: [
          popUpMenuButton(),
        ],
      ),
      body: _group=="groupNo"?groupErrorWidget():FutureBuilder(
        future: getJsonClassData(),
          builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          if (snapshot.hasData) {
            Map rawData = snapshot.data;
            return groupSuccessWidget(rawData);
          }
          return Center(child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                Container(margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),),
                Text("Hold Tight - Getting your Stuff Ready...",
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

  Widget groupErrorWidget() {
    return Container();
  }

  Widget groupSuccessWidget(Map rawData) {
    return (rawData[_group]["count"]["class"]+rawData[_group]["count"]["tute"]+rawData[_group]["count"]["lab"])==0?
    Center(child: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("No Classes Today",
            style: TextStyle(
              fontSize: 25.0,
              color: Colors.red,
              fontWeight: FontWeight.bold,
              letterSpacing: 5.0,
            ),
          ),
        ],
      ),
    ),)
        :Column(
      children: [
        Center(child: Container(
          margin: const EdgeInsets.only(bottom: 8.0),
          child: Text("Today you have ${rawData[_group]["count"]["class"]} Lecture, ${rawData[_group]["count"]["tute"]} Tute and ${rawData[_group]["count"]["lab"]} Lab",
            style: TextStyle(
              fontSize: 17.0,
              color: Colors.purpleAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),),
        Flexible(
          child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              reverse: false,
              itemCount: 9,
              itemBuilder: (_, int index) {
                return Wrap(
                    direction: Axis.horizontal,
                    children: [(rawData[_group]["detail"][index]).length==2?
                    Card(
                      color: Colors.white10,
                      child: Column(
                        children: [
                          ExpansionTile(
                            title: Text(rawData[_group]["detail"][index][0]["name"], style: TextStyle(color: Color(0xFF58A6FF)),),
                            subtitle: Text(rawData[_group]["detail"][index][0]["code"]+" | "+rawData[_group]["detail"][index][0]["teach"]),
                            children: [
                              Text("Meeting ID: "+rawData[_group]["detail"][index][0]["id"]+"\n",
                                style: TextStyle(
                                  fontSize: 15.0
                                ),
                              ),
                              Text("Password: "+rawData[_group]["detail"][index][0]["pwd"],
                                style: TextStyle(
                                    fontSize: 15.0
                                ),
                              ),
                            ],
                            expandedCrossAxisAlignment: CrossAxisAlignment.start,
                            expandedAlignment: Alignment.topLeft,
                            childrenPadding: const EdgeInsets.all(15.0),
                            leading: CircleAvatar(
                              child: Text(rawData[_group]["detail"][index][0]["timeS"]+"\n----------\n"+rawData[_group]["detail"][index][0]["timeE"],
                                style: TextStyle(
                                    fontSize: 13.0
                                ),
                              ),
                              radius: 30.0,
                            ),
                            trailing: ElevatedButton(
                              child: Text("Join"),
                              onPressed: rawData[_group]["detail"][index][0]["url"]==""?null:() async {
                                if (await canLaunch(rawData[_group]["detail"][index][0]["url"])) {
                                  await launch(rawData[_group]["detail"][index][0]["url"]);
                                } else {
                                  throw 'Could not launch';
                                }
                              },
                            ),
                          ),
                          ExpansionTile(
                            title: Text(rawData[_group]["detail"][index][1]["name"], style: TextStyle(color: Color(0xFF58A6FF)),),
                            subtitle: Text(rawData[_group]["detail"][index][1]["code"]+" | "+rawData[_group]["detail"][index][1]["teach"]),
                            children: [
                              Text("Meeting ID: "+rawData[_group]["detail"][index][1]["id"]+"\n",
                                style: TextStyle(
                                    fontSize: 15.0
                                ),
                              ),
                              Text("Password: "+rawData[_group]["detail"][index][1]["pwd"],
                                style: TextStyle(
                                    fontSize: 15.0
                                ),
                              ),
                            ],
                            expandedCrossAxisAlignment: CrossAxisAlignment.start,
                            expandedAlignment: Alignment.topLeft,
                            childrenPadding: const EdgeInsets.all(15.0),
                            leading: CircleAvatar(
                              child: Text(rawData[_group]["detail"][index][1]["timeS"]+"\n----------\n"+rawData[_group]["detail"][index][1]["timeE"],
                                style: TextStyle(
                                    fontSize: 13.0
                                ),
                              ),
                              radius: 30.0,
                            ),
                            trailing: ElevatedButton(
                              child: Text("Join"),
                              onPressed: rawData[_group]["detail"][index][1]["url"]==""?null:() async {
                                if (await canLaunch(rawData[_group]["detail"][index][1]["url"])) {
                                  await launch(rawData[_group]["detail"][index][1]["url"]);
                                } else {
                                  throw 'Could not launch';
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ):
                    Card(
                      color: Colors.white10,
                      child: IgnorePointer(
                        ignoring: rawData[_group]["detail"][index]["id"]=="",
                        child: ExpansionTile(
                          title: Text(rawData[_group]["detail"][index]["name"], style: TextStyle(color: Color(0xFF58A6FF)),),
                          subtitle: Text(
                              (rawData[_group]["detail"][index]["code"]+" | "+rawData[_group]["detail"][index]["teach"])==" | "?"":
                              rawData[_group]["detail"][index]["code"]+" | "+rawData[_group]["detail"][index]["teach"]
                          ),
                          children: [
                            Text("Meeting ID: "+rawData[_group]["detail"][index]["id"]+"\n",
                              style: TextStyle(
                                  fontSize: 15.0
                              ),
                            ),
                            Text("Password: "+rawData[_group]["detail"][index]["pwd"],
                              style: TextStyle(
                                  fontSize: 15.0
                              ),
                            ),
                          ],
                          expandedCrossAxisAlignment: CrossAxisAlignment.start,
                          expandedAlignment: Alignment.topLeft,
                          childrenPadding: const EdgeInsets.all(15.0),
                          leading: CircleAvatar(
                            child: Text(rawData[_group]["detail"][index]["timeS"]+"\n----------\n"+rawData[_group]["detail"][index]["timeE"],
                              style: TextStyle(
                                  fontSize: 13.0
                              ),
                            ),
                            radius: 30.0,
                          ),
                          trailing: (rawData[_group]["detail"][index]["name"]=="One Hour Quiz" || rawData[_group]["detail"][index]["name"]=="BREAK")?
                          Text(""):ElevatedButton(
                            child: Text("Join"),
                            onPressed: rawData[_group]["detail"][index]["url"]==""?null:() async {
                              if (await canLaunch(rawData[_group]["detail"][index]["url"])) {
                                await launch(rawData[_group]["detail"][index]["url"]);
                              } else {
                                throw 'Could not launch';
                              }
                            },
                          ),
                        ),
                      )
                    ),
                    ]
                );
              }),
        ),
        Divider(
          height: 1.0,
        ),
        Wrap(
          direction: Axis.horizontal,
          children: [
            Text("Crafted with ❤ by CRYP73R",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget popUpMenuButton() {
    return PopupMenuButton(
      icon: Icon(Icons.more_vert),
      tooltip: "Menu",
      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
        const PopupMenuItem(
          child: Text("Discrepancy"),
          value: "discrepancy",
        ),
        const PopupMenuItem(
          child: Text("Missing"),
          value: "missing",
        ),
        const PopupMenuItem(
          child: Text("Change Roll No"),
          value: "change",
        ),
        const PopupMenuItem(
          child: Text("Report a Problem"),
          value: "reportPrb",
        ),
      ],
      onSelected: (value) async {
        if (value.toString()=="discrepancy") {
          if (await canLaunch(discrepancyUrl)) {
            await launch(discrepancyUrl);
          } else {
            throw 'Could not launch';
          }
        }
        else if (value.toString()=="missing") {
          if (await canLaunch(missingUrl)) {
            await launch(missingUrl);
          } else {
            throw 'Could not launch';
          }
        }
        else if (value.toString()=="change") {
          _removeRollNumber();
          Navigator.pushReplacementNamed(context, "/startScreen");
        }
        else if (value.toString()=="reportPrb") {
          if (await canLaunch(reportPrbUrl)) {
            await launch(reportPrbUrl);
          } else {
            throw 'Could not launch';
          }
        }
      },
    );
  }
}
