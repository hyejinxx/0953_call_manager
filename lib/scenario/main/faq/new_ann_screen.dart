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
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => ContentDialog(
                                title: const Text('이전 화면으로 이동하시겠습니까?', style: TextStyle(fontSize: 20)),
                                actions: [
                                  Button(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('닫기')),
                                  Button(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                      child: const Text('이동'))
                                ],
                              ));
                    },
                    icon: const Icon(FluentIcons.receipt_check, size: 25)),
                const SizedBox(width: 10),
                IconButton(
                    icon: const Icon(
                      FluentIcons.accept,
                      size: 25,
                    ),
                    onPressed: () {
                      if (titleTextController.text.isEmpty ||
                          contentController.text.isEmpty) {
                        showInfoBar(
                            '입력 오류', '내용을 입력해주세요', InfoBarSeverity.warning);
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
                          .then((value) async {
                        await showDialog(
                            context: context,
                            builder: (context) => ContentDialog(
                                  title: const Text('업데이트 알림을 전송하시겠습니까?'),
                                  actions: [
                                    Button(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('닫기')),
                                    Button(
                                        onPressed: () {
                                          AnnouncementService()
                                              .pushFCM(isUpdate);
                                          Navigator.pop(context);
                                        },
                                        child: const Text('전송'))
                                  ],
                                ));
                        showInfoBar(
                            '등록 완료', '등록 완료되었습니다.', InfoBarSeverity.success);
                        Navigator.pop(context);
                      }).onError((error, stackTrace) {
                        showInfoBar(
                            '등록 실패', '등록에 실패했습니다.', InfoBarSeverity.error);
                      }).whenComplete(() {
                        titleTextController.clear();
                        contentController.clear();
                      });
                    })
              ],
            ),
            InfoLabel(
              label: '제목',
              child: TextBox(
                placeholder: '제목입력',
                expands: false,
                controller: titleTextController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                maxLength: 10000,
              ),
            ),
            const SizedBox(height: 10),
            InfoLabel(
              label: '내용',
              child: TextBox(
                placeholder: '내용입력',
                expands: true,
                controller: contentController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                maxLength: 10000,
              ),
            ),
          ]),
    );
  }

  showInfoBar(
      String title, String content, InfoBarSeverity infoBarSeverity) async {
    await displayInfoBar(context, builder: (context, close) {
      return InfoBar(
        title: Text(title),
        content: Text(content),
        action: IconButton(
          icon: const Icon(FluentIcons.clear),
          onPressed: close,
        ),
        severity: infoBarSeverity,
      );
    });
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
