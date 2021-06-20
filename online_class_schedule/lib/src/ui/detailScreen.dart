import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:online_class_schedule/src/apiDataHandler/getJsonData.dart';
import 'package:online_class_schedule/src/ui/noticeScreen.dart';
import 'package:online_class_schedule/src/ui/updateAppScreen.dart';
import 'package:online_class_schedule/src/utils/ad_helper.dart';
import 'package:online_class_schedule/src/utils/getBranchCode.dart';
import 'package:online_class_schedule/src/utils/getGroup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/utils.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({Key key}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  String _group;
  int _branchCode;
  String _strRollNo = "";

  BannerAd _ad1;
  BannerAd _ad2;
  bool _isAdLoaded = false;

  _getRollNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _strRollNo = (prefs.getString("strRollNo") ?? "");
      _group = getGroup(_strRollNo);
      _branchCode = getBranchCode(_strRollNo);
    });
  }

  _removeRollNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("strRollNo");
    _strRollNo = "";
  }

  BannerAd _bannerAd() {
    return BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print('Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
    );
  }

  @override
  void initState() {
    _getRollNumber();
    _ad1 = _bannerAd();
    _ad2 = _bannerAd();
    _ad1.load();
    _ad2.load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Online Class Schedule"),
        centerTitle: true,
        actions: [
          logoutButton(),
        ],
      ),
      body: _group == "groupNo"
          ? groupErrorWidget()
          : FutureBuilder(
              future: _branchCode == 10
                  ? getJsonData(apiUrlCS)
                  : getJsonData(apiUrlIT),
              builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
                if (snapshot.hasData) {
                  Map rawData = snapshot.data;
                  return groupSuccessWidget(rawData);
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
                          "Hold Tight - Getting your Stuff Ready...",
                          style: TextStyle(
                            letterSpacing: 2.0,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
      drawer: appDrawer(),
    );
  }

  Widget groupErrorWidget() {
    return Container();
  }

  Widget groupSuccessWidget(Map rawData) {
    return Stack(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Image.asset(
              "images/sapphire-min.jpg",
            fit: BoxFit.fill,
            color: Colors.black87,
            colorBlendMode: BlendMode.darken,
          ),
        ),
        (rawData[_group]["count"]["class"] +
                    rawData[_group]["count"]["tute"] +
                    rawData[_group]["count"]["lab"]) ==
                0
            ? Center(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "No Classes Today",
                        style: TextStyle(
                          fontSize: 25.0,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 5.0,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Column(
                children: [
                  _isAdLoaded?Container(
                    child: AdWidget(ad: _ad1),
                    width: MediaQuery.of(context).size.width,
                    height: 72.0,
                    alignment: Alignment.center,
                  ):Container(),
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "Today you have ${rawData[_group]["count"]["class"]} Lecture, ${rawData[_group]["count"]["tute"]} Tute and ${rawData[_group]["count"]["lab"]} Lab",
                        style: TextStyle(
                          fontSize: 17.0,
                          color: Color(0xFFEB596E),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: ListView.builder(
                        padding: const EdgeInsets.all(8.0),
                        reverse: false,
                        itemCount: 9,
                        itemBuilder: (_, int index) {
                          return Wrap(direction: Axis.horizontal, children: [
                            (rawData[_group]["detail"][index]).length == 2
                                ? Card(
                                    color: Colors.white10,
                                    child: Column(
                                      children: [
                                        ExpansionTile(
                                          title: Text(
                                            rawData[_group]["detail"][index][0]
                                                ["name"],
                                            style:
                                                TextStyle(color: Color(0xFF58A6FF)),
                                          ),
                                          subtitle: Text(rawData[_group]["detail"]
                                                  [index][0]["code"] +
                                              " | " +
                                              rawData[_group]["detail"][index][0]
                                                  ["teach"]),
                                          children: [
                                            Text(
                                              "Meeting ID: " +
                                                  rawData[_group]["detail"][index]
                                                      [0]["id"] +
                                                  "\n",
                                              style: TextStyle(fontSize: 15.0),
                                            ),
                                            Text(
                                              "Password: " +
                                                  rawData[_group]["detail"][index]
                                                      [0]["pwd"],
                                              style: TextStyle(fontSize: 15.0),
                                            ),
                                          ],
                                          expandedCrossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          expandedAlignment: Alignment.topLeft,
                                          childrenPadding:
                                              const EdgeInsets.all(15.0),
                                          leading: CircleAvatar(
                                            child: Text(
                                              rawData[_group]["detail"][index][0]
                                                      ["timeS"] +
                                                  "\n----------\n" +
                                                  rawData[_group]["detail"][index]
                                                      [0]["timeE"],
                                              style: TextStyle(fontSize: 13.0),
                                            ),
                                            radius: 30.0,
                                          ),
                                          trailing: ElevatedButton(
                                            child: Text("Join"),
                                            onPressed: rawData[_group]["detail"]
                                                        [index][0]["url"] ==
                                                    ""
                                                ? null
                                                : () async {
                                                    if (await canLaunch(
                                                        rawData[_group]["detail"]
                                                            [index][0]["url"])) {
                                                      await launch(rawData[_group]
                                                              ["detail"][index][0]
                                                          ["url"]);
                                                    } else {
                                                      throw 'Could not launch';
                                                    }
                                                  },
                                          ),
                                        ),
                                        ExpansionTile(
                                          title: Text(
                                            rawData[_group]["detail"][index][1]
                                                ["name"],
                                            style:
                                                TextStyle(color: Color(0xFF58A6FF)),
                                          ),
                                          subtitle: Text(rawData[_group]["detail"]
                                                  [index][1]["code"] +
                                              " | " +
                                              rawData[_group]["detail"][index][1]
                                                  ["teach"]),
                                          children: [
                                            Text(
                                              "Meeting ID: " +
                                                  rawData[_group]["detail"][index]
                                                      [1]["id"] +
                                                  "\n",
                                              style: TextStyle(fontSize: 15.0),
                                            ),
                                            Text(
                                              "Password: " +
                                                  rawData[_group]["detail"][index]
                                                      [1]["pwd"],
                                              style: TextStyle(fontSize: 15.0),
                                            ),
                                          ],
                                          expandedCrossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          expandedAlignment: Alignment.topLeft,
                                          childrenPadding:
                                              const EdgeInsets.all(15.0),
                                          leading: CircleAvatar(
                                            child: Text(
                                              rawData[_group]["detail"][index][1]
                                                      ["timeS"] +
                                                  "\n----------\n" +
                                                  rawData[_group]["detail"][index]
                                                      [1]["timeE"],
                                              style: TextStyle(fontSize: 13.0),
                                            ),
                                            radius: 30.0,
                                          ),
                                          trailing: ElevatedButton(
                                            child: Text("Join"),
                                            onPressed: rawData[_group]["detail"]
                                                        [index][1]["url"] ==
                                                    ""
                                                ? null
                                                : () async {
                                                    if (await canLaunch(
                                                        rawData[_group]["detail"]
                                                            [index][1]["url"])) {
                                                      await launch(rawData[_group]
                                                              ["detail"][index][1]
                                                          ["url"]);
                                                    } else {
                                                      throw 'Could not launch';
                                                    }
                                                  },
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Card(
                                    color: Colors.white10,
                                    child: IgnorePointer(
                                      ignoring: rawData[_group]["detail"][index]
                                              ["id"] ==
                                          "",
                                      child: ExpansionTile(
                                        title: Text(
                                          rawData[_group]["detail"][index]["name"],
                                          style:
                                              TextStyle(color: Color(0xFF58A6FF)),
                                        ),
                                        subtitle: Text((rawData[_group]["detail"]
                                                        [index]["code"] +
                                                    " | " +
                                                    rawData[_group]["detail"][index]
                                                        ["teach"]) ==
                                                " | "
                                            ? ""
                                            : rawData[_group]["detail"][index]
                                                    ["code"] +
                                                " | " +
                                                rawData[_group]["detail"][index]
                                                    ["teach"]),
                                        children: [
                                          Text(
                                            "Meeting ID: " +
                                                rawData[_group]["detail"][index]
                                                    ["id"] +
                                                "\n",
                                            style: TextStyle(fontSize: 15.0),
                                          ),
                                          Text(
                                            "Password: " +
                                                rawData[_group]["detail"][index]
                                                    ["pwd"],
                                            style: TextStyle(fontSize: 15.0),
                                          ),
                                        ],
                                        expandedCrossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        expandedAlignment: Alignment.topLeft,
                                        childrenPadding: const EdgeInsets.all(15.0),
                                        leading: CircleAvatar(
                                          child: Text(
                                            rawData[_group]["detail"][index]
                                                    ["timeS"] +
                                                "\n----------\n" +
                                                rawData[_group]["detail"][index]
                                                    ["timeE"],
                                            style: TextStyle(fontSize: 13.0),
                                          ),
                                          radius: 30.0,
                                        ),
                                        trailing: (rawData[_group]["detail"][index]
                                                        ["name"] ==
                                                    "One Hour Quiz" ||
                                                rawData[_group]["detail"][index]
                                                        ["name"] ==
                                                    "BREAK")
                                            ? Text("")
                                            : ElevatedButton(
                                                child: Text("Join"),
                                                onPressed: rawData[_group]["detail"]
                                                            [index]["url"] ==
                                                        ""
                                                    ? null
                                                    : () async {
                                                        if (await canLaunch(
                                                            rawData[_group]
                                                                    ["detail"]
                                                                [index]["url"])) {
                                                          await launch(
                                                              rawData[_group]
                                                                      ["detail"]
                                                                  [index]["url"]);
                                                        } else {
                                                          throw 'Could not launch';
                                                        }
                                                      },
                                              ),
                                      ),
                                    )),
                          ]);
                        }),
                  ),
                  Divider(
                    height: 2.0,
                  ),
                  _isAdLoaded?Container(
                    child: AdWidget(ad: _ad2),
                    width: MediaQuery.of(context).size.width,
                    height: 72.0,
                    alignment: Alignment.center,
                  ):Container(),
                  Wrap(
                    direction: Axis.horizontal,
                    children: [
                      Text(
                        "Crafted with ❤ by CRYP73R",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                      )
                    ],
                  ),
                ],
              ),
      ],
    );
  }

  Drawer appDrawer() {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(0.0),
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              // color: Color(0xFF151313),
              image: DecorationImage(image: AssetImage("images/cloud-min.jpg"), fit: BoxFit.fill, colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.dstATop),),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  child: _branchCode == 10
                      ? Text(
                          "CS",
                          style: TextStyle(fontSize: 50.0, letterSpacing: 4.0),
                        )
                      : Text(
                          "IT",
                          style: TextStyle(fontSize: 50.0, letterSpacing: 4.0),
                        ),
                  foregroundColor: Colors.black,
                  radius: 55.0,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 3.5, bottom: 3.5),
                ),
                Text(
                  _strRollNo,
                  style: TextStyle(
                    // fontStyle: FontStyle.italic,
                    fontSize: 17.0,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.notifications_active,
              color: Colors.red,
            ),
            title: Text("NOTICE BOARD"),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NoticeScreen()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.new_releases,
              color: Colors.orangeAccent,
            ),
            title: Text("DISCREPANCY"),
            onTap: () async {
              if (await canLaunch(discrepancyUrl)) {
                await launch(discrepancyUrl);
              } else {
                throw 'Could not launch';
              }
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: Icon(
              Icons.data_usage,
              color: Colors.purple,
            ),
            title: Text("MISSING DATA"),
            onTap: () async {
              if (await canLaunch(missingUrl)) {
                await launch(missingUrl);
              } else {
                throw 'Could not launch';
              }
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: Icon(
              Icons.next_week,
              color: Colors.grey,
            ),
            title: Text("NEW NOTICE"),
            onTap: () async {
              if (await canLaunch(newNoticeUrl)) {
                await launch(newNoticeUrl);
              } else {
                throw 'Could not launch';
              }
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: Icon(
              Icons.calendar_today,
              color: Colors.blue,
            ),
            title: Text("TIMETABLE CHANGED"),
            onTap: () async {
              if (await canLaunch(timeTableUrl)) {
                await launch(timeTableUrl);
              } else {
                throw 'Could not launch';
              }
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: Icon(
              Icons.report_problem,
              color: Colors.yellow,
            ),
            title: Text("REPORT PROBLEM"),
            onTap: () async {
              if (await canLaunch(reportPrbUrl)) {
                await launch(reportPrbUrl);
              } else {
                throw 'Could not launch';
              }
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: Icon(
              Icons.system_update,
              color: Colors.green,
            ),
            title: Text("CHECK FOR UPDATES"),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => UpdateAppScreen()));
            },
          ),
        ],
      ),
    );
  }

  IconButton logoutButton() {
    return IconButton(
        tooltip: "Logout",
        icon: Icon(Icons.logout),
        onPressed: () {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Alert!"),
                  content: const Text(
                      "You will be Logged Out. You will need to re-enter your Roll no. in order to use this app."),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("CANCEL")),
                    TextButton(
                        onPressed: () {
                          _removeRollNumber();
                          Navigator.pushNamedAndRemoveUntil(context, "/startScreen", (route) => false);
                        },
                        child: const Text("OK")),
                  ],
                );
              });
        });
  }

  @override
  void dispose() {
    _ad1.dispose();
    _ad2.dispose();
    super.dispose();
  }
}
