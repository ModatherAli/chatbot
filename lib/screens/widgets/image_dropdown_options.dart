import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_utils/get_utils.dart';
// import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import '../../modules/message_module.dart';

import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../../services/api/openai_api.dart';

ScreenshotController screenshotController = ScreenshotController();

class ImageDropdownOptions extends StatelessWidget {
  const ImageDropdownOptions({
    super.key,
    required this.child,
    required this.messageModule,
  });
  final Widget child;
  final MessageModule messageModule;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          buttonStyleData: const ButtonStyleData(
            // padding: EdgeInsets.symmetric(horizontal: 60),
            elevation: 0,
          ),
          customButton:
              Screenshot(controller: screenshotController, child: child),
          items: [
            ...MenuItems.firstItems.map(
              (item) => DropdownMenuItem<MenuItem>(
                value: item,
                child: MenuItems.buildItem(item),
              ),
            ),
          ],
          onChanged: (value) {
            MenuItems.onChanged(context, value as MenuItem,
                messageModule.message.toString().trim());
          },
          dropdownStyleData: DropdownStyleData(
            width: 160,
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              // color: Colors.redAccent,
            ),
            elevation: 8,
            offset: const Offset(0, 8),
          ),
          menuItemStyleData: MenuItemStyleData(
            customHeights: [
              ...List<double>.filled(MenuItems.firstItems.length, 48),
            ],
            padding: const EdgeInsets.only(left: 16, right: 16),
          ),
        ),
      ),
    );
  }
}

class MenuItem {
  final String text;
  final IconData icon;

  const MenuItem({
    required this.text,
    required this.icon,
  });
}

class MenuItems {
  static const List<MenuItem> firstItems = [download];
  // static const List<MenuItem> secondItems = [];

  static const download = MenuItem(text: 'Download', icon: Icons.download);
  late Future<File> _imageFile;

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(item.icon, size: 22),
        const SizedBox(
          width: 10,
        ),
        Text(
          item.text.tr,
          style: const TextStyle(
              // color: Colors.white,
              ),
        ),
      ],
    );
  }

  static saveImage() async {
    final directory = (await getApplicationDocumentsDirectory())
        .path; //from path_provide package
    String fileName = DateTime.now().microsecondsSinceEpoch.toString();
    String path = directory;

    screenshotController.captureAndSave(path, fileName: fileName);
  }

  static onChanged(BuildContext context, MenuItem item, String text) async {
    switch (item) {
      case MenuItems.download:
        saveImage();
        // await downloadImage(imageUrl: text);
        // await _getImageFileFromUrl(text);
        break;
    }
  }
}

Future<File> _getImageFileFromUrl(String url) async {
  // Get temporary directory for storing the downloaded image.
  await Permission.storage.request();
  EasyLoading.show();
  Directory tempDir = await getTemporaryDirectory();
  String fileName = url.split("/").last;
  File file = File('${tempDir.path}/${url.hashCode}.png');

  // If the file exists, return it.
  // if (await file.exists()) {
  //   return file;
  // }
  // else {
  //   file.create();
  // }

  // Otherwise, download the image and save it to the temporary directory.
  var response = await http.get(
    Uri.parse(url),
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $OPENAI_API_KEY"
    },
  );
  var imageData = response.bodyBytes;
  await file.writeAsBytes(imageData);
  log(file.path);
  await _saveImageToGallery(file);
  EasyLoading.showSuccess("");
  return file;
}

Future<void> _saveImageToGallery(File image) async {
  // Save the image to the user's gallery.
  log(image.path);
  final result = await ImageGallerySaver.saveImage(image.readAsBytesSync(),
      quality: 100, name: image.path.split('/').last // '${image.hashCode}.png',
      );
  log(result.toString());
}
