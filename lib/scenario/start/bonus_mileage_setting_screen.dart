import 'package:call_0953_manager/service/manager_service.dart';
import 'package:flutter/material.dart';

class BonusMileageSettingScreen extends StatefulWidget {
  const BonusMileageSettingScreen({super.key});

  @override
  State<BonusMileageSettingScreen> createState() => BonusMileageSettingScreenState();
}

class BonusMileageSettingScreenState extends State<BonusMileageSettingScreen> with TickerProviderStateMixin {
  late TabController tabController;
  final controller = TextEditingController();

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('이벤트 마일리지 설정', style: TextStyle(color: Colors.black), textAlign: TextAlign.center),
          backgroundColor: Colors.transparent,
          centerTitle: true,
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(0),
            child: Container(
              color: Colors.grey[300],
              height: 1,
            ),
          ),
          leadingWidth: 100,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: Colors.white,
        body: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(children: [
              TabBar(
                controller: tabController,
                indicatorColor: Colors.yellow,
                tabs: const [
                  Tab(text: '현금'),
                  Tab(text: '카드'),
                ],
                labelColor: Colors.black,
              ),
              Expanded(
                  child: TabBarView(controller: tabController, children: [
                FutureBuilder(
                    future: ManagerService().getBonusMileageStandardForCash(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.separated(
                            itemCount: snapshot.data!.values.length,
                            separatorBuilder: (BuildContext context, int index) {
                              return const Divider(
                                height: 1,
                                thickness: 1,
                              );
                            },
                            itemBuilder: (context, index) {
                              return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                          width: 100, padding: const EdgeInsets.only(left: 10), child: Text('${snapshot.data!.keys.toList()[index].replaceAll('a', '')}' + '원')),
                                      Container(
                                        width: 100,
                                        height: 30,
                                        child: TextField(
                                          controller: TextEditingController(text: snapshot.data!.values.toList()[index].toString()),
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                          ),
                                          onChanged: (value) {
                                            if (value.isNotEmpty) {
                                              final standard = snapshot.data!.keys.toList()[index].toString();
                                              print({standard: value}.toString());
                                              ManagerService().updateBonusMileageStandardForCash({standard: int.parse(value)});
                                            }
                                          },
                                        ),
                                      )
                                    ],
                                  ));
                            });
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    }),
                FutureBuilder(
                    future: ManagerService().getBonusMileageStandardForCard(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.separated(
                            itemCount: snapshot.data!.values.length,
                            separatorBuilder: (BuildContext context, int index) {
                              return const Divider(
                                height: 1,
                                thickness: 1,
                              );
                            },
                            itemBuilder: (context, index) {
                              return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                          width: 100, padding: const EdgeInsets.only(left: 10), child: Text('${snapshot.data!.keys.toList()[index].replaceAll('a', '')}' + '원')),
                                      Container(
                                        width: 100,
                                        height: 30,
                                        child: TextField(
                                          controller: TextEditingController(text: snapshot.data!.values.toList()[index].toString()),
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                          ),
                                          onChanged: (value) {
                                            final standard = snapshot.data!.keys.toList()[index].toString();
                                            print({standard: value}.toString());
                                            ManagerService().updateBonusMileageStandardForCard({standard: value});
                                          },
                                        ),
                                      )
                                    ],
                                  ));
                            });
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    }),
              ]))
            ])));
  }
}
