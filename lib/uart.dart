import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:dart_serial_port/dart_serial_port.dart';

class Uart {
  final _cash = <String, Uart>{};
  final String _name; //= SerialPort.availablePorts.first;
  SerialPort? _uart;
  SerialPortReader? _reader;

  String get name => _name;
  Stream<Uint8List>? get getStream {
    if (_uart == null) return null;

    if (_reader == null || !_uart!.isOpen) {
      if (!_uart!.isOpen) {
        if (!_uart!.openReadWrite()) {
          print('err');
          print(SerialPort.lastError);
          return null;
        }
        _reader = SerialPortReader(_uart!);
        _reader?.port.config.baudRate = 9600;
      }
    }
    return _reader?.stream;
  }

  Uart._internal(String name) : _name = name {
    var i = 0;
    for (final name in SerialPort.availablePorts) {
      final sp = SerialPort(name);
      print('${++i}) $name');
      print('\tDescription: ${sp.description}');
      print('\tManufacturer: ${sp.manufacturer}');
      print('\tSerial Number: ${sp.serialNumber}');
      print('\tProduct ID: 0x${sp.productId?.toRadixString(16)}');
      print('\tVendor ID: 0x${sp.vendorId?.toRadixString(16)}');
      sp.dispose();
    }

    var uart = _cash.putIfAbsent(name, () => this);
    uart._uart ??= SerialPort(name);
  }

  factory Uart({String? name}) {
    if (name == null) {
      if (SerialPort.availablePorts.isEmpty) {
        throw 'Not available ports';
      }
      name = SerialPort.availablePorts.first;
    }
    return Uart._internal(name);
  }
}

enum OpenMode { RW, R, W }
