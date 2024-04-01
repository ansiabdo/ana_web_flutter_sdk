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

    // Get [clientId] required the authenticate miniapp with user.
    final code = args.first["Code"];

    completer.complete(code);
    // controller().checkUserConsent(
    //   //miniAppId: controller().miniapp?.id,
    //     clientId: clientId,
    //     onPass: (result) {
    //       logger.d(result.toString() /*, "basFetchAuthCode"*/);
    //       completer.complete(result);
    //     },
    //     onConsent: (authCodeData) {
    //       AdutilsDialog.showCustomDialog(
    //           titleWidget: Align(
    //             alignment: Alignment.topCenter,
    //             child: Column(
    //               children: [
    //                 CircleAvatar(
    //                     backgroundColor: Get.theme.colorScheme.background,
    //                     minRadius: 36,
    //                     child: CircleAvatar(
    //                         backgroundColor: Get.theme.colorScheme.onPrimary,
    //                         maxRadius: 32,
    //                         child: Padding(
    //                             padding: const EdgeInsets.all(16),
    //                             child: authCodeData.consent?.clientLogoUrl ==
    //                                 null
    //                                 ? Image.asset(
    //                               controller().miniApp?.image ??
    //                                   "assets/images/light_logo.png",
    //                               height: 60,
    //                             )
    //                                 : CachedNetworkImage(
    //                               imageUrl: NetworkProvider.getImageUrl(
    //                                   prefix: authCodeData
    //                                       .consent?.clientLogoUrl),
    //                               filterQuality: FilterQuality.none,
    //                               placeholder: (context, url) =>
    //                                   Container(
    //                                     decoration: BoxDecoration(
    //                                         color: AppColors.StringColors(
    //                                             AppStrings.placeholder)),
    //                                     child: const Padding(
    //                                       padding: EdgeInsets.all(20),
    //                                       child: Center(
    //                                           child:
    //                                           CircularProgressIndicator()),
    //                                     ),
    //                                   ),
    //                               imageBuilder: (context,
    //                                   imageProvider) =>
    //                                   Container(
    //                                       decoration: BoxDecoration(
    //                                         // borderRadius: BorderRadius.circular(10),
    //                                           image: DecorationImage(
    //                                             image: imageProvider,
    //                                             fit: BoxFit.cover,
    //                                           ),
    //                                           color:
    //                                           AppColors.StringColors(
    //                                               AppStrings
    //                                                   .placeholder))),
    //                               errorWidget: (context, url, error) =>
    //                                   Container(
    //                                     decoration: BoxDecoration(
    //                                         color: AppColors.StringColors(
    //                                             AppStrings.placeholder)),
    //                                     child: const Center(
    //                                         child: Icon(
    //                                           Icons.error,
    //                                           color: Colors.black12,
    //                                         )),
    //                                   ),
    //                               fit: BoxFit.cover,
    //                             ) //,
    //                         ))),
    //                 Padding(
    //                   padding: const EdgeInsets.symmetric(
    //                       horizontal: 8.0, vertical: 8),
    //                   child: Text(
    //                     "${authCodeData.consent?.clientName ?? controller().miniApp?.name} ${LangConfig.text("requesting for accessing your profile data")}",
    //                     style: Get.theme.textTheme.titleLarge,
    //                     textAlign: TextAlign.center,
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //           contentWidget: Column(
    //             children: [
    //               //   const SizedBox(height: 16,),
    //
    //               ListTile(
    //                 // contentPadding: const EdgeInsetsDirectional.all(0),
    //
    //                 title: Text(LangConfig.text("User name"),
    //                     style: Get.theme.textTheme.bodyMedium),
    //                 subtitle: Text(LangConfig.text("Your bas profile name"),
    //                     style: Get.theme.textTheme.bodySmall),
    //                 leading: CircleAvatar(
    //                   backgroundColor: Get.theme.colorScheme.background,
    //                   foregroundColor: Get.theme.colorScheme.primary,
    //                   child: const Icon(Icons.account_circle),
    //                 ),
    //               ),
    //               ListTile(
    //                 title: Text(LangConfig.text("Phone number"),
    //                     style: Get.theme.textTheme.bodyMedium),
    //                 subtitle: Text(LangConfig.text("Your bas phone number"),
    //                     style: Get.theme.textTheme.bodySmall),
    //                 leading: CircleAvatar(
    //                   backgroundColor: Get.theme.colorScheme.background,
    //                   foregroundColor: Get.theme.colorScheme.primary,
    //                   child: const Icon(Icons.phone),
    //                 ),
    //               ),
    //               ListTile(
    //                 title: Text(LangConfig.text("Email"),
    //                     style: Get.theme.textTheme.bodyMedium),
    //                 subtitle: Text(LangConfig.text("Your bas email address"),
    //                     style: Get.theme.textTheme.bodySmall),
    //                 leading: CircleAvatar(
    //                   backgroundColor: Get.theme.colorScheme.background,
    //                   foregroundColor: Get.theme.colorScheme.primary,
    //                   child: const Icon(Icons.email),
    //                 ),
    //               ),
    //               Padding(
    //                 padding: const EdgeInsets.all(8.0),
    //                 child: Text(
    //                     LangConfig.text("No other information will be shared"),
    //                     style: Get.theme.textTheme.bodyMedium),
    //               ),
    //               const SizedBox(
    //                 height: 16,
    //               )
    //             ],
    //           ),
    //           positiveText: LangConfig.text("Allow"),
    //           onPositive: (_) async {
    //             final result = await controller()
    //                 .setUserConsent(authCodeData: authCodeData, action: true);
    //             logger.d(result);
    //             completer.complete(result);
    //             //return result;
    //           },
    //           negativeText: LangConfig.text("Deny"),
    //           onNegative: (_) async => completer.complete(
    //               OAuthResponse(status: -1, messages: ["User denied consent"])
    //                   .toJson()));
    //       /*AdutilsDialog.showAvatarBottomSheetDialog(
    //         titleWidget: Align(
    //           alignment: Alignment.topCenter,
    //           child: Column(
    //             children: [
    //               CircleAvatar(
    //                   backgroundColor: Get.theme.colorScheme.background,
    //                   minRadius: 36,
    //                   child: CircleAvatar(
    //                       backgroundColor: Get.theme.colorScheme.onPrimary,
    //                       maxRadius: 32,
    //                       child: Padding(
    //                         padding: const EdgeInsets.all(16),
    //                         child: Image.asset(controller().miniapp!.image!,height:60 ,),
    //                       )
    //                   )
    //               ),
    //               Padding(
    //                 padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 8),
    //                 child: Text("${controller().miniapp?.name} ${LangConfig.text("requesting for accessing your profile data")}",style: Get.theme.textTheme.headline6,textAlign: TextAlign.center,),
    //               ),
    //             ],
    //           ),
    //         ),
    //         contentWidget: Column(
    //           children: [
    //             const SizedBox(height: 64,),
    //
    //             ListTile(
    //               // contentPadding: const EdgeInsetsDirectional.all(0),
    //
    //               title: Text(LangConfig.text("User name"),style: Get.theme.textTheme.bodyMedium),
    //               subtitle: Text(LangConfig.text("Your bas profile name"),style: Get.theme.textTheme.bodySmall),
    //               leading: CircleAvatar(
    //                 backgroundColor:  Get.theme.colorScheme.background,
    //                 foregroundColor:  Get.theme.colorScheme.primary,
    //                 child: const Icon(Icons.account_circle),
    //               ),
    //             ),
    //             ListTile(
    //               title: Text(LangConfig.text("Phone number"),style: Get.theme.textTheme.bodyMedium),
    //               subtitle: Text(LangConfig.text("Your bas phone number"),style: Get.theme.textTheme.bodySmall),
    //               leading: CircleAvatar(
    //                 backgroundColor:  Get.theme.colorScheme.background,
    //                 foregroundColor:  Get.theme.colorScheme.primary,
    //                 child: const Icon(Icons.phone),
    //               ),
    //             ),
    //             ListTile(
    //               title: Text(LangConfig.text("Email"),style: Get.theme.textTheme.bodyMedium),
    //               subtitle: Text(LangConfig.text("Your bas email address"),style: Get.theme.textTheme.bodySmall),
    //               leading: CircleAvatar(
    //                 backgroundColor:  Get.theme.colorScheme.background,
    //                 foregroundColor:  Get.theme.colorScheme.primary,
    //                 child: const Icon(Icons.email),
    //               ),
    //             ),
    //             Padding(
    //               padding: const EdgeInsets.all(8.0),
    //               child: Text(LangConfig.text("No other information will be shared"),style: Get.theme.textTheme.bodyMedium),
    //             ),
    //             const SizedBox(height: 16,)
    //           ],
    //         ),
    //         positiveText: LangConfig.text("Allow"),
    //         onPositive: (_) async {
    //           final result=await controller().setUserConsent(authCodeData.returnUrl);
    //           completer.complete(result);
    //           //return result;
    //         },
    //         negativeText: LangConfig.text("Deny"),
    //         onNegative: (_) async =>completer.complete(AuthCodeResponse(status: -1,messages: ["User denied consent"]).toJson())
    //     );*/
    //     },
    //     onUndefined: (result) {
    //       completer.complete(result);
    //     });
    return completer.future;
  }
}
