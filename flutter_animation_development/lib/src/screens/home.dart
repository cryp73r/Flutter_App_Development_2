import 'package:flutter/material.dart';
import 'package:flutter_animation_development/src/widgets/cat.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  Animation<double> catAnimation;
  AnimationController catController;

  @override
  void initState() {
    catController = AnimationController(
      duration: Duration(seconds: 2),
        vsync: this,
    );
    catAnimation = Tween(begin: 0.0, end: 100.0)
    .animate(
      CurvedAnimation(
          parent: catController,
          curve: Curves.easeIn,
      )
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Animation"),
      ),
      body: GestureDetector(
          child: Stack(
            children: [
              buildAnimation(),
              buildBox(),
            ],
          ),
        onTap: onTapped,
      ),
    );
  }

  Widget buildAnimation() {
    return AnimatedBuilder(
        animation: catAnimation,
        builder: (context, child) {
          return Container(
            child: child,
            margin: EdgeInsets.only(top: catAnimation.value),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Cat(),
          ],
        ),
    );
  }

  Widget buildBox() {
    return Center(
      child: Container(
        height: 250.0,
        width: 258.0,
        color: Colors.brown,
      ),
    );
  }

  onTapped() {
    if (catController.status==AnimationStatus.completed)
      catController.reverse();
    else if (catController.status==AnimationStatus.dismissed)
      catController.forward();
    else if (catController.status==AnimationStatus.forward)
      catController.reverse();
    else if (catController.status==AnimationStatus.reverse)
      catController.forward();
  }
}
