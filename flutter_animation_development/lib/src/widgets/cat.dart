import 'package:flutter/material.dart';

class Cat extends StatelessWidget {
  const Cat({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR2V3q9SintaiYjCRKH4PLPyNsgaLW7OW7Cqg&usqp=CAU"
    );
  }
}
