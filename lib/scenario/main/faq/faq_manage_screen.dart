import 'package:call_0953_manager/model/faq.dart';
import 'package:call_0953_manager/scenario/main/faq/new_ann_screen.dart';
import 'package:call_0953_manager/scenario/main/faq/new_faq_screen.dart';
import 'package:call_0953_manager/service/announcement_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FAQManageScreen extends ConsumerStatefulWidget {
  const FAQManageScreen({Key? key}) : super(key: key);

  @override
  FAQManageScreenState createState() => FAQManageScreenState();
}

class FAQManageScreenState extends ConsumerState<FAQManageScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  final tab = [const AnnouncementPage(), const FAQPage(), const NewFAQPage()];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(controller: _tabController, tabs: [
          Container(
            height: 80,
            alignment: Alignment.center,
            child: const Text(
              '공지사항',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          Container(
            height: 80,
            alignment: Alignment.center,
            child: const Text(
              'FAQ',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ]),
        Expanded(child: TabBarView(controller: _tabController, children: tab))
      ],
    );
  }
}

class FAQPage extends StatefulWidget {
  const FAQPage({Key? key}) : super(key: key);

  @override
  State<FAQPage> createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: FutureBuilder(
              future: AnnouncementService().getFAQ(),
              builder: (context, snapshot) {
                return snapshot.hasData
                    ? ListView.separated(
                        itemBuilder: (context, index) {
                          return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NewFaQScreen(
                                              faq: snapshot.data![index],
                                            )));
                              },
                              child: ListTile(
                                title: Container(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 7),
                                    child: Text(
                                        'Q${index + 1}. ${snapshot.data![index].question}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                        ))),
                                subtitle: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text(
                                        'A. ${snapshot.data![index].answer.replaceAll('\\n', '\n').replaceAll('\\', '')}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w500,
                                        ))),
                              ));
                        },
                        itemCount: snapshot.data!.length,
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider();
                        },
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      );
              }),
        ),
        InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NewFaQScreen()));
            },
            child: Container(
              color: Colors.yellow.withOpacity(0.7),
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: const Text('새 FaQ 작성'),
            ))
      ],
    );
  }
}

class AnnouncementPage extends StatefulWidget {
  const AnnouncementPage({Key? key}) : super(key: key);

  @override
  State<AnnouncementPage> createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: FutureBuilder(
              future: AnnouncementService().getAnnouncement(),
              builder: (context, snapshot) {
                return snapshot.hasData
                    ? ListView.separated(
                        itemBuilder: (context, index) {
                          return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NewAnnoScreen(
                                              ann: snapshot.data![index],
                                            )));
                              },
                              child: ListTile(
                                title: Container(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 7),
                                    child: Row(children: [
                                      const Icon(Icons.arrow_right,
                                          size: 20, color: Colors.black),
                                      Text(snapshot.data![index].title,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                          ))
                                    ])),
                                subtitle: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text(
                                        snapshot.data![index].content
                                            .replaceAll('\\n', '\n')
                                            .replaceAll('\\', ''),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w500,
                                        ))),
                              ));
                        },
                        itemCount: snapshot.data!.length,
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider();
                        },
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      );
              }),
        ),
        InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NewAnnoScreen()));
            },
            child: Container(
              color: Colors.yellow.withOpacity(0.7),
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: const Text('새 공지 작성'),
            ))
      ],
    );
  }
}

class NewFAQPage extends StatefulWidget {
  const NewFAQPage({Key? key}) : super(key: key);

  @override
  State<FAQPage> createState() => NewFAQPageState();
}

class NewFAQPageState extends State<FAQPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: FutureBuilder(
              future: AnnouncementService().getNewFAQ(),
              builder: (context, snapshot) {
                return snapshot.hasData
                    ? ListView.separated(
                        itemBuilder: (context, index) {
                          return InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) => AnswerScreen(
                                          faq: snapshot.data![index],
                                        ));
                              },
                              child: ListTile(
                                title: Container(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 7),
                                    child: Text(
                                        'Q${index + 1}. ${snapshot.data![index].question}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                        ))),
                                subtitle: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text(
                                        snapshot.data![index].answer == ''
                                            ? '아직 답변을 하지 않았습니다'
                                            : 'A. ${snapshot.data![index].answer.replaceAll('\\n', '\n').replaceAll('\\', '')}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w500,
                                        ))),
                                trailing: IconButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                                content: Text('삭제하시겠습니까?'), actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('취소')),
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context, true);
                                                  },
                                                  child: const Text('확인'))
                                            ]);
                                          }).then((value) => {
                                            if (value == true)
                                              {
                                                AnnouncementService()
                                                    .deleteNewFAQ(snapshot
                                                        .data![index].createdAt)
                                              }
                                          });
                                    },
                                    icon: const Icon(Icons.delete)),
                              ));
                        },
                        itemCount: snapshot.data!.length,
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider();
                        },
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      );
              }),
        ),
        // InkWell(
        //     onTap: () {
        //
        //     },
        //     child: Container(
        //       color: Colors.yellow.withOpacity(0.7),
        //       width: MediaQuery.of(context).size.width,
        //       alignment: Alignment.center,
        //       padding: const EdgeInsets.symmetric(vertical: 16),
        //       child: const Text('새 FaQ 작성'),
        //     ))
      ],
    );
  }
}

class AnswerScreen extends StatefulWidget {
  const AnswerScreen({super.key, required this.faq});

  final FAQ faq;

  @override
  State<AnswerScreen> createState() => AnswerScreenState();
}

class AnswerScreenState extends State<AnswerScreen> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(widget.faq.question,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            )),
        const SizedBox(height: 20),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: TextField(
                controller: controller,
                maxLines: 10,
                decoration: const InputDecoration(
                    hintText: '답변을 입력해주세요',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey))))),
        InkWell(
            onTap: () {
              widget.faq.answer = controller.text;
              AnnouncementService().saveAnswerFAQ(widget.faq);
            },
            child: Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.yellow,
                height: 60,
                alignment: Alignment.center,
                child: const Text(
                  '답변하기',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                )))
      ],
    );
  }
}
