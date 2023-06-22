import 'dart:io';

// import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../provider/image_picker_provider.dart';

final imagePickerProvider = StateNotifierProvider<ImageState, File?>((ref) {
  return ImageState();
});

class NewAnnoScreen extends ConsumerStatefulWidget {
  const NewAnnoScreen({super.key});

  @override
  _NewAnnoScreenState createState() => _NewAnnoScreenState();
}

class _NewAnnoScreenState extends ConsumerState<NewAnnoScreen> {
  final titleTextController = TextEditingController();
  final contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final img = ref.watch(imagePickerProvider);
    return SizedBox(
      height: MediaQuery.of(context).size.height - 20,
        child: SingleChildScrollView(child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Column(
            children: [
          Row(children: [
            Container(
              width: MediaQuery.of(context).size.width - 100,
              height: 80,
              padding: const EdgeInsets.all(10),
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: InputBorder.none,
                  labelText: '제목',
                ),
              ),
            ),
            imageBox(img)
          ],),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: TextField(
                controller: contentController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                maxLength: 10000,
                style: const TextStyle(
                  fontSize: 14.0,
                ),
                decoration: InputDecoration(
                  focusedBorder:
                      const UnderlineInputBorder(borderSide: BorderSide.none),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: const EdgeInsets.all(16),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: '공지사항을 적어주세요',
                  hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.7),
                    fontSize: 14.0,
                  ),
                )),
          ),
          SizedBox(height: 20,),
            ],
          ),
          InkWell(
              onTap: () {

              },
              child: Container(
                color: Colors.yellow.withOpacity(0.7),
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text('등록하기',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0)),
              ))

        ],
    )
    ));
  }

  Widget imageBox(File? img) {
    double imgBoxSize = 60;

    return img == null
        ? InkWell(
            onTap: () => ref.read(imagePickerProvider.notifier).getImage(),
            child: Container(
              margin: const EdgeInsets.all(10),
              width: imgBoxSize,
              height: imgBoxSize,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image, color: Colors.grey[400]!),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'image',
                    style: TextStyle(
                        color: Colors.grey[400],
                        fontWeight: FontWeight.w500,
                        fontSize: 12.0),
                  )
                ],
              ),
            ))
        : GestureDetector(
            onTap: () => ref.read(imagePickerProvider.notifier).delImage(img),
            child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                width: imgBoxSize,
                height: imgBoxSize,
                child: Stack(children: [
                  Center(
                      child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: Image.file(File(img.path)).image),
                              borderRadius: BorderRadius.circular(10)),
                          width: imgBoxSize,
                          height: imgBoxSize)),
                  Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10)),
                          child: Icon(Icons.close,
                              size: 15, color: Colors.grey[400])))
                ])));
  }
}
