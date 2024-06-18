import 'dart:io';

import 'package:call_0953_manager/service/file_picker_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImageState extends StateNotifier<File?> {
  ImageState() : super(null);
  final FilePickerService picker = FilePickerService();

  @override
  set state(File? value) {
    super.state = value;
  }

  delImage(File image) {
    state = image;
  }

  Future getImage() async {
    picker.pickImageFile().then((value) {
      if (value != null) {
        state = value;
      }
    }).catchError((onError) {});
  }
}
