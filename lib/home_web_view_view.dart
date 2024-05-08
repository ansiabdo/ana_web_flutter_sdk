import 'dart:collection';
import 'dart:convert';

import 'package:anaweb_flutter_sdk/utils/utils.dart';
import 'package:anaweb_flutter_sdk/views/console_message_bottom_sheet.dart';
import 'package:anaweb_flutter_sdk/views/title_responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'callbackhandler.dart';
import 'home_web_view_controller.dart';
import 'main.dart';

class HomeWebViewScreen extends StatelessWidget {
  static const String routeName = '/home_web_view_screen';
  const HomeWebViewScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeWebViewController>(
      init: HomeWebViewController(),
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            var result = await controller.onBack(
              byDeviceBackButton: true,
            );
            if (result) {
              return await _onPop();
            }
            return result;
          },
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Get.theme.colorScheme.surface,
              foregroundColor: Get.theme.colorScheme.onSurface,
              automaticallyImplyLeading: false,
              title: TitleResponsive(
                onBack: () => controller.onBack(),
                actions: [
                  ConsoleMessageBottomSheet(
                    controller: controller,
                  ),
                  IconButton(
                    icon: const Icon(Icons.highlight_off),
                    onPressed: () => Get.back(),
                  ),
                ],
                child: const Text("ANA-WEB Flutter SDK"),
              ),
            ),
            body: Obx(() {
              controller.progress.value;
              return Stack(
                children: [
                  InAppWebView(
                    initialUrlRequest: URLRequest(
                      url: WebUri.uri(Uri.parse(controller.url)),
                    ),
                    initialUserScripts: UnmodifiableListView<UserScript>([]),
                    initialSettings: InAppWebViewSettings(
                      ///android AndroidInAppWebViewOptions
                      useHybridComposition: true,
                      cacheMode: CacheMode.LOAD_NO_CACHE,
                      clearSessionCache: true,

                      /// ios IOSInAppWebViewOptions
                      allowsInlineMediaPlayback: true,

                      ///crossPlatform InAppWebViewOptions
                      supportZoom: false,
                      mediaPlaybackRequiresUserGesture: false,
                      allowFileAccessFromFileURLs: true,
                      allowUniversalAccessFromFileURLs: true,
                      // cacheEnabled: false,
                      // clearCache: true,

                      cacheEnabled: true,
                      clearCache: true,
                      disableContextMenu: true,
                      // hardwareAcceleration: true,
                      // rendererPriorityPolicy: RendererPriorityPolicy()
                    ),
                    onReceivedServerTrustAuthRequest:
                        (controller, challenge) async {
                      return ServerTrustAuthResponse(
                          action: ServerTrustAuthResponseAction.PROCEED);
                    },
                    shouldOverrideUrlLoading:
                        (controllerInApp, navigationAction) async {
                      var uri = navigationAction.request.url!;
                      if (![
                        "http",
                        "https",
                        "file",
                        "chrome",
                        "data",
                        "javascript",
                        "about"
                      ].contains(uri.scheme)) {
                        await openUrlLink(urlLink: uri.path);
                        return NavigationActionPolicy.CANCEL;
                      }
                      return NavigationActionPolicy.ALLOW;
                    },
                    onWebViewCreated: (controllerInApp) {
                      controller.webController = controllerInApp;
                      controllerInApp.addJavaScriptHandler(
                          handlerName: CallbackHandler().name,
                          callback: CallbackHandler().callback);
                    },
                    onLoadStart: (controllerInApp, url) async {
                      if (url!.queryParameters.containsKey('isconsent')) {
                        var auth_code =
                            url.queryParameters.entries.elementAt(1);
                        var params = url.queryParameters;
                        logger.d(
                          "isconsent : $auth_code",
                        );
                        controllerInApp.stopLoading();
                        Get.offAllNamed("/", parameters: params);
                      }
                      logger.d(
                        "[onLoadStop]: ${url.path} -- ${jsonEncode(url.queryParameters)}",
                      );
                    },
                    onLoadStop: (controllerInApp, url) async {
                      controller.progressStatus.value = ProgressStatus.ready;
                      logger.d(
                        "[onLoadStop]: ${url?.path} -- ${jsonEncode(url?.queryParameters)}",
                      );

                      await controllerInApp.evaluateJavascript(source: """
                        var JSBridge = {
                          call: window.flutter_inappwebview.callHandler,
                          flutterCall: function(name,args,callback){
                            console.log("flutterCall"+JSON.stringify(args));
                             //console.log("flutterCall"+args);
                            JSBridge.call(name,args)
                            .then(callback);
                          },
                          status:1
                        };
                        window.dispatchEvent(new MessageEvent("JSBridgeReady", {
                          data:{locale:'${controller.lang}'}
                        }));
                      """);
                    },
                    onReceivedError: (InAppWebViewController controller,
                        WebResourceRequest request, WebResourceError error) {
                      // onReceivedError: (controllerInApp, req, web) {
                      logger.d('onReceivedError :${error.toString()}');
                    },
                    onProgressChanged: (controllerInApp, progress) {
                      controller.progress.value = progress / 100;
                      logger.d("progress :$progress");
                      if (progress == 100) {
                        controller.progressStatus.value = ProgressStatus.ready;
                      }
                    },
                    onConsoleMessage: (_, consoleMessage) {
                      AppLog.debug("[Console]: ${consoleMessage.message}",
                          'onConsoleMessage');

                      logger.d("[Console-d]: ${consoleMessage.message}");
                      controller.consoleMessagesList
                          .add(consoleMessage.message);
                    },
                  ),
                  if (controller.progressStatus.value != ProgressStatus.ready &&
                      controller.progressStatus.value == ProgressStatus.load &&
                      controller.progress.value <= 1.0)
                    Center(
                      child: LoadingProgressBar(),
                    )
                ],
              );
            }),
          ),
        );
      },
    );
  }

  Future<bool> _onPop() {
    final controller = Get.find<HomeWebViewController>();
    DateTime now = DateTime.now();
    if (controller.currentBackPressTime == null ||
        now.difference(controller.currentBackPressTime!) >
            const Duration(seconds: 2)) {
      controller.currentBackPressTime = now;
      controller.toastMessage(
        "Start",
      );
      return Future.value(false);
    }
    return Future.value(true);
  }

  static Future<void> openUrlLink({required String? urlLink}) async {
    if (urlLink == null || urlLink.isEmpty) {
      return;
    }
    final uri = Uri.parse(urlLink);
    logger.d("urlLink :$urlLink");
    if (await canLaunchUrl(uri)) {
      logger.d("if (await canLaunchUrl(uri)) :${await canLaunchUrl(uri)}");
      var config = const WebViewConfiguration();
      await launchUrl(uri,
          mode: LaunchMode.externalApplication, webViewConfiguration: config);
    }
  }

  LoadingProgressBar() {
    return const CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
    );
  }
}
