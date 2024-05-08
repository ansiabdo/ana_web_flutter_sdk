import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'dart:developer' as developer;

class AppLog {
  static Logger logger = Logger(
    filter: null,
    printer: PrettyPrinter(),
    output: null,
  );

  static get isInDebugMode {
    //bool inDebugMode = false;
    bool inDebugMode = !const bool.fromEnvironment("dart.vm.product");
    assert(inDebugMode = true);
    return inDebugMode;
  }

  static debug(String? msg, String TAG) {
    if (AppLog.isInDebugMode) {
      if (kIsWeb)
        print("$TAG: $msg");
      else {
        developer.log("$msg", name: TAG);
        //logger.d("$msg");
      }
    }
  }

  static pdebug(String msg) {
    if (AppLog.isInDebugMode) print("$msg");
  }
}
