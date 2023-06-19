import 'dart:io';
import 'package:file_picker/file_picker.dart';

class FilePickerService{
  Future<File?> pickFile() async {
    FilePickerResult? filePickerResult = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls', 'xlsb'],
    );
    if(filePickerResult == null) return null;
    return File(filePickerResult.files.first.path!);
  }
}