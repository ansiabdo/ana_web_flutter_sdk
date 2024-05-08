import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../home_web_view_controller.dart';

class ConsoleMessageBottomSheet extends StatelessWidget {
  const ConsoleMessageBottomSheet({
    super.key,
    required this.controller,
  });

  final HomeWebViewController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return controller.consoleMessagesList.isEmpty
          ? const SizedBox.shrink()
          : IconButton(
              icon: const Icon(Icons.code),
              onPressed: () {
                Get.bottomSheet(
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: Get.height - Get.width / 2,
                    ),
                    child: Card(
                      margin: EdgeInsets.zero,
                      clipBehavior: Clip.antiAlias,
                      shape: bottomSheetShape,
                      child: Column(
                        children: [
                          Text(
                            'Web View Log',
                            style: Get.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            width: Get.width / 2,
                            height: 8.0,
                            margin: const EdgeInsets.symmetric(
                              vertical: 8.0,
                            ),
                            decoration: BoxDecoration(
                              color: Get.theme.dividerColor,
                              borderRadius: BorderRadius.circular(
                                24,
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView.separated(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              shrinkWrap: true,
                              itemCount: controller.consoleMessagesList.length,
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const Divider(),
                              itemBuilder: (BuildContext context, int index) {
                                String message =
                                    controller.consoleMessagesList[index];
                                return Text(
                                  '${index + 1}- $message',
                                );
                              },
                            ),
                          ),
                          // UiHelper.verticalSpaceMedium,
                        ],
                      ).paddingSymmetric(
                        vertical: 12.0,
                      ),
                    ),
                  ),
                  isScrollControlled: true,
                );
              },
            );
    });
  }

  static RoundedRectangleBorder get bottomSheetShape =>
      const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(32.0),
        ),
      );
}
