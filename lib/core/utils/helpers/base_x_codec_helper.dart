import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:base_x/base_x.dart';

class BaseXCodecHelper {
  final BaseXCodec base;

  BaseXCodecHelper() : base = BaseXCodec('ABCDEFGHIJKLMNOP');

  String encode(Uint8List data) => base.encoder.convert(data);

  Uint8List decode(String data) => base.decoder.convert(data);

  void encodeBaseWorker(Map<String, dynamic> message) {
    final data = message['data'] as Uint8List;
    final sendPort = message['sendPort'] as SendPort;

    // Encode the data
    String encodedData = base.encoder.convert(data);

    // Send the encoded data back to the main isolate
    sendPort.send({'encodedData': encodedData});
  }

  Future<String> encodeBaseWithIsolate(Uint8List data) async {
    // Create a receive port to get messages from the worker isolate
    final receivePort = ReceivePort();
    final completer = Completer<String>();

    // Start the worker isolate
    await Isolate.spawn(encodeBaseWorker, {
      'data': data,
      'sendPort': receivePort.sendPort,
    });

    // Listen for messages from the worker isolate
    receivePort.listen((message) {
      if (message is Map<String, dynamic>) {
        if (message.containsKey('encodedData')) {
          completer.complete(message['encodedData']);
          receivePort.close(); // Close the port when done
        }
      }
    });

    return completer.future;
  }
}
