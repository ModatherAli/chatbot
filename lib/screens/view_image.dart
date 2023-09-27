import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

class ViewImage extends StatelessWidget {
  final String url;
  ViewImage({super.key, required this.url});
  final ScreenshotController _screenshotController = ScreenshotController();
  _saveImage() async {
    await Permission.storage.request();
    String fileName = DateTime.now().microsecondsSinceEpoch.toString();

    Uint8List? image = await _screenshotController.capture();
    final result = await ImageGallerySaver.saveImage(
      image!,
      quality: 100,
      name: fileName,
    );
    EasyLoading.showSuccess("Saved".tr);
    log(result.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          actions: [TextButton(onPressed: _saveImage, child: Text('Save'.tr))]),
      body: Center(
        child: InteractiveViewer(
          child: Screenshot(
            controller: _screenshotController,
            child: SizedBox(
              width: double.infinity,
              height: 350,
              child: CachedNetworkImage(
                imageUrl: url,
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
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.fill,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
