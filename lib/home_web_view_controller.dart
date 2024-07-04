import 'package:anaweb_flutter_sdk/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

import 'SDK/ClientProperties.dart';
import 'SDK/constants.dart';

enum ProgressStatus { download, uncompress, load, ready, failed }

class HomeWebViewController extends GetxController {
  DateTime? currentBackPressTime;

  InAppWebViewController? webController;

  InAppWebViewSettings settings = InAppWebViewSettings(
    isInspectable: kDebugMode,
    mediaPlaybackRequiresUserGesture: false,
    allowsInlineMediaPlayback: true,
    iframeAllow: "camera; microphone",
    iframeAllowFullscreen: true,

    ///android AndroidInAppWebViewOptions
    useHybridComposition: true,
    cacheMode: CacheMode.LOAD_NO_CACHE,
    clearSessionCache: true,

    /// ios IOSInAppWebViewOptions

    ///crossPlatform InAppWebViewOptions
    supportZoom: false,
    allowFileAccessFromFileURLs: true,
    allowUniversalAccessFromFileURLs: true,
    // cacheEnabled: false,
    // clearCache: true,

    cacheEnabled: true,
    clearCache: true,
    disableContextMenu: true,
    // hardwareAcceleration: true,
    // rendererPriorityPolicy: RendererPriorityPolicy()
  );
  PullToRefreshController? pullToRefreshController;
  String url = "";

  ClientProperties clientProperties = ClientProperties(
      authority: BASE_URL,
      clientId: CLIENT_ID,
      scopes: SCOPE,
      channel: CHANNEL,
      responseType: RESPONSE_TYPE,
      //your callback uri
      callbackUri: "",
      redirectUri: REDIRECT_URI,
      ConsentMode: CONSENT_MODE);

  String lang = 'ar';

  final progressStatus = ProgressStatus.load.obs;

  final progress = 0.0.obs;
  RxList<String> consoleMessagesList = RxList();

  Future<bool> onBack({bool byDeviceBackButton = false}) async {
    bool? x = await InAppWebViewController.setSafeBrowsingAllowlist(
        hosts: [clientProperties.getStartUrl()]);
    logger.w("setSafeBrowsingAllowlist :$x");
    String? navUrl = (await webController?.getUrl())?.toString();
    if (navUrl?.endsWith("/") == true) {
      navUrl = navUrl?.substring(0, navUrl.length - 1);
    }
    final miniAppBaseUrl = Uri.encodeFull(clientProperties.getStartUrl());
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

  String getURL() {
    final url = clientProperties.getStartUrl();
    logger.d("url :$url");
    return url;
  }

  void toastMessage(param0) {}
}
