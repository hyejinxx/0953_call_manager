import 'dart:io';

import 'package:call_0953_manager/service/announcement_service.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../model/announcement.dart';
import '../../../provider/image_picker_provider.dart';

final imagePickerProvider = StateNotifierProvider<ImageState, File?>((ref) {
  return ImageState();
});

class NewAnnoScreen extends ConsumerStatefulWidget {
  NewAnnoScreen({super.key, this.ann});

  Announcement? ann;

  @override
  _NewAnnoScreenState createState() => _NewAnnoScreenState();
}

class _NewAnnoScreenState extends ConsumerState<NewAnnoScreen> {
  final titleTextController = TextEditingController();
  final contentController = TextEditingController();

  @override
  void initState() {
    if (widget.ann != null) {
      titleTextController.text = widget.ann!.title;
      contentController.text = widget.ann!.content;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final img = ref.watch(imagePickerProvider);
    return Container(color: Colors.white, child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(FluentIcons.back)),
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width - 100,
                  height: 80,
                  padding: const EdgeInsets.all(10),
                  child: TextFormBox(
                    controller: titleTextController,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5)),
                    placeholder: '제목',
                  ),
                ),
                // imageBox(img)
              ],
            ),
            Expanded(
                child: Container(

              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white),
              child: TextFormBox(
                  controller: contentController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  maxLength: 10000,
                  style: const TextStyle(
                    fontSize: 14.0,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                  placeholder: '내용을 적어주세요'),
            )),
            GestureDetector(
                onTap: () {
                  if (titleTextController.text.isEmpty ||
                      contentController.text.isEmpty) {
                    showSnackbar(
                        context, Snackbar(content: Text('내용을 입력해주세요')));
                    return;
                  }
                  final announcement = Announcement(
                      title: titleTextController.text,
                      content: contentController.text,
                      createdAt: widget.ann == null
                          ? DateTime.now().toString()
                          : widget.ann!.createdAt,
                      date: widget.ann == null
                          ? DateFormat('yyyy-MM-dd').format(DateTime.now())
                          : widget.ann!.date,
                      image: null);
                  final isUpdate = widget.ann != null;
                  AnnouncementService()
                      .saveAnnouncement(announcement)
                      .then((value) async{

                    await showDialog(
                        context: context,
                        builder: (context) => ContentDialog(
                          title: const Text('업데이트 알림을 전송하시겠습니까?'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('닫기')),
                            TextButton(
                                onPressed: () {
                                  AnnouncementService().pushFCM(isUpdate);
                                  Navigator.pop(context);
                                },
                                child: const Text('전송'))
                          ],
                        ));
                    showSnackbar(context, Snackbar(content: Text('등록되었습니다')));
                    Navigator.pop(context);
                  }).onError((error, stackTrace) {
                    showSnackbar(context,
                        Snackbar(content: Text('등록에 실패했습니다. 다시 시도해주세요')));
                  }).whenComplete(() {
                    titleTextController.clear();
                    contentController.clear();
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
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
        ));
  }

  Widget imageBox(File? img) {
    double imgBoxSize = 60;

    return img == null
        ? GestureDetector(
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
                  Icon(FluentIcons.image_crosshair, color: Colors.grey[400]!),
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
                          child: Icon(FluentIcons.close_pane,
                              size: 15, color: Colors.grey[400])))
                ])));
  }
}
