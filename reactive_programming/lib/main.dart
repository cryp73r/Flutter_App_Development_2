import 'dart:async';

import 'package:flutter/cupertino.dart';

class Cake {}
class Order {
  String type;
  Order(this.type);
}

void main() {
  final controller = StreamController();

  final order = Order('chocolate');

  final baker = StreamTransformer.fromHandlers(
    handleData: (cakeType, sink) {
      if (cakeType=="chocolate") {
        sink.add(Cake());
      }
      else {
        sink.addError("Can't bake that Type!!!");
      }
    }
  );

  controller.sink.add(order);
  
  controller.stream
      .map((order) => order.type)
      .transform(baker)
      .listen(
        (cake) => debugPrint('Here is your cake $cake'),
        onError: (err) => debugPrint(err)
  );

  controller.close();
}