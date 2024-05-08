import 'dart:async';

import 'main.dart';

class CallbackHandler {
  static final CallbackHandler _singleton = CallbackHandler.internal();

  factory CallbackHandler() {
    return _singleton;
  }

  CallbackHandler.internal();

  String name = "anaFetchAuthCode";

  Future callback(args) async {
    logger.d(args.toString());
    logger.i("callback anaFetchAuthCode ===$args");
    // Define the Completer that handle the process
    final completer = Completer();

    final code = args.first["Code"];
    logger.w("callback Code ===$code");

    completer.complete(code);
    return completer.future;
  }
}
