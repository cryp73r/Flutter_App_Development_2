import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({Key key}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Online Class Schedule"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Flexible(
            child: ListView.builder(
                padding: EdgeInsets.all(8.0),
                reverse: false,
                itemCount: 8,
                itemBuilder: (_, int index) {
                  return Wrap(
                    direction: Axis.horizontal,
                    children: [
                      Card(
                        color: Colors.white10,
                        child: ListTile(
                          title: Text("Subject Name", style: TextStyle(color: Color(0xFF58A6FF)),),
                          subtitle: Text("Subject Code | Subject Teacher"),
                          onTap: () => debugPrint("Card Tapped!"),
                          trailing: ElevatedButton(
                              child: Text("Join"),
                              onPressed: () => debugPrint("Meeting Joined!"),
                          ),
                        ),
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
      ),
    );
  }
}
