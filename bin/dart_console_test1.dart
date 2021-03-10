import 'dart:convert';

import 'package:gnss_l1l5/dart_console_test1.dart'
    as dart_console_test1;
import 'package:gnss_l1l5/uart.dart';

void main(List<String> arguments) async {
  print('Hello world: ${dart_console_test1.calculate()}!');

  try {
    final stream = Uart(name: 'COM3').getStream;
    if (stream == null) {
      print('Straem is empty');
    }
    List<int> line = [];
    await for (final data in stream!) {
      //print(data);
      final b = data.toList();
      print(ascii.decode(b, allowInvalid: true));
    }
    //if (stream == null) return;
    //final line =
    //    await utf8.decodeStream(stream.map<List<int>>((list) => list.toList()));
    //print(line);
  } catch (err, s) {
    print(err);
    print(s);
  }
}
