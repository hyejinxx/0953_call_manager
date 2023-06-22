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
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  final tab = [
    const AnnouncementPage(),
    const FAQPage(),
  ];

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
                          return ListTile(
                            title: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 7),
                                child: Text(
                                    'Q${index + 1}. ${snapshot.data![index].question}', style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600,))),
                            trailing: IconButton(
                              icon: const Icon(Icons.edit, size: 20),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NewFaQScreen(
                                              faq: snapshot.data![index],
                                            )));
                              },
                            ),
                            subtitle: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child:
                                    Text('A. ${snapshot.data![index].answer}', style: const TextStyle(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w500,))),
                          );
                        },
                        itemCount: snapshot.data!.length, separatorBuilder: (BuildContext context, int index) { return const Divider(); },
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      );
              }),
        ),
        InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NewFaQScreen()));
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
                          return ListTile(
                            title: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 7),
                                child: Row(children: [
                                  const Icon(Icons.arrow_right,
                                      size: 20, color: Colors.black),
                                  Text(snapshot.data![index].title, style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600,)
                                  )])),
                            trailing: IconButton(
                              icon: const Icon(Icons.edit, size: 20),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NewAnnoScreen(
                                          ann: snapshot.data![index],
                                        )));
                              },
                            ),
                            subtitle: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(snapshot.data![index].content, style: const TextStyle(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w500,))),
                          );
                        },
                        itemCount: snapshot.data!.length, separatorBuilder: (BuildContext context, int index) { return const Divider(); },
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      );
              }),
        ),
        InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NewAnnoScreen()));
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
