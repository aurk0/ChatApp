import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageSelect {
  static ImageSelect get instance => ImageSelect();

  Future<File> cropImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    final File imageFileFromLibrary = File(pickedFile.path);

    // Start crop iamge then take the file.
    File cropPhoto = await ImageCropper.cropImage(
        sourcePath: imageFileFromLibrary.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    return cropPhoto != null ? cropPhoto : null;
  }
}
