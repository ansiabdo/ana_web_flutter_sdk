import 'package:anaweb_flutter_sdk/main.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

enum ProgressStatus { download, uncompress, load, ready, failed }

class HomeWebViewController extends GetxController {
  DateTime? currentBackPressTime;

  InAppWebViewController? webController;

  String lang = 'ar';

  final progressStatus = ProgressStatus.load.obs;

  final progress = 0.0.obs;
  RxList<String> consoleMessagesList = RxList();

  String url = 'https://anawebykb.web.app/conn/auth?response_type=code&client_id=ykb_lite_app&scope=user.profile%20idCard%20phone%20mail&redirect_uri=https:%2F%2Fstagebas.yk-bank.com:9104%2Fapi%2Fv1%2Fauth%2Fcallback&channel=api&callbackUri=https:%2F%2Flocalhost';
  // String url = 'https://stagebas.yk-bank.com:9104/conn/auth?response_type=code&client_id=ykb_lite_app&scope=user.profile%20idCard%20phone%20mail&redirect_uri=https:%2F%2Fstagebas.yk-bank.com:9104%2Fapi%2Fv1%2Fauth%2Fcallback&channel=api&callbackUri=https:%2F%2Flocalhost&sdk=1';

  Future<bool> onBack({bool byDeviceBackButton = false}) async {
    bool? x =
        await InAppWebViewController.setSafeBrowsingAllowlist(hosts: [url]);
    logger.w("setSafeBrowsingAllowlist :$x");
    String? navUrl = (await webController?.getUrl())?.toString();
    if (navUrl?.endsWith("/") == true) {
      navUrl = navUrl?.substring(0, navUrl.length - 1);
    }
    final miniAppBaseUrl = Uri.encodeFull(url);
    bool isInHomeOfMiniApp = await webController?.canGoBack() == false;
    bool canBackWithGet =
        isInHomeOfMiniApp || navUrl == null || navUrl == miniAppBaseUrl;

    if (canBackWithGet) {
      if (byDeviceBackButton) {
        return true;
      }
      return true;
    } else {
      webController?.goBack();
      return false;
    }
  }

  void toastMessage(param0) {}
}
