import 'package:ai/screens/view_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants.dart';
import '../../controller/theme_controller.dart';
import '../../modules/message_module.dart';

class ImageMessage extends StatelessWidget {
  const ImageMessage({
    super.key,
    required this.messageModule,
  });
  final MessageModule messageModule;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(builder: (themeController) {
      return GestureDetector(
        onTap: () {
          Get.to(() => ViewImage(url: messageModule.message.toString().trim()));
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                alignment: Alignment.center,
                height: 250,
                width: 250,
                margin: const EdgeInsets.symmetric(horizontal: 15),
                constraints: BoxConstraints(
                  maxWidth: Get.width * 0.85,
                ),
                decoration: BoxDecoration(
                  color: themeController.isDark
                      ? Constants.darkColor
                      : Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: CachedNetworkImage(
                  imageUrl: messageModule.message.toString().trim(),
                  fit: BoxFit.fill,
                  width: double.infinity,
                  height: double.infinity,
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  fadeInDuration: const Duration(milliseconds: 500),
                  fadeOutDuration: const Duration(milliseconds: 500),
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Center(
                    child: CircularProgressIndicator(
                        value: downloadProgress.progress),
                  ),
                  imageBuilder: (context, imageProvider) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.fill,
                        ),
                      ),
                    );
                  },
                )),
          ],
        ),
      );
    });
  }
}
