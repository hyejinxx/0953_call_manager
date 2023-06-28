import 'package:call_0953_manager/service/manager_service.dart';
import 'package:flutter/material.dart';

class MileageSettingScreen extends StatefulWidget {
  const MileageSettingScreen({super.key});

  @override
  State<MileageSettingScreen> createState() => _MileageSettingScreenState();
}

class _MileageSettingScreenState extends State<MileageSettingScreen>
    with TickerProviderStateMixin {
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
          title: Text('마일리지 설정',
              style: const TextStyle(color: Colors.black),
              textAlign: TextAlign.center),
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
                    future: ManagerService().getMileageStandardForCash(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            itemCount: snapshot.data!.values.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                  onTap: (){
                                    controller.text = snapshot.data!.values.toList()[index].toString();
                                    showDialog(context: context, builder: (context){
                                      return AlertDialog(
                                        title: Text('마일리지 설정 변경 ( ${snapshot.data!.keys.toList()[index].replaceAll('a', '')} )'),
                                        content:  TextField(
                                          controller: controller,
                                          keyboardType: TextInputType.number,
                                        ),
                                        actions: [
                                          TextButton(onPressed: (){
                                            Navigator.pop(context);
                                          }, child: const Text('취소')),
                                          TextButton(onPressed: (){
                                            final standard = snapshot.data!.keys.toList()[index].toString();
                                            final mileage = int.parse(controller.text);
                                            ManagerService().updateMileageStandardForCash({standard: mileage});
                                            Navigator.pop(context);
                                            setState(() {

                                            });
                                          }, child: const Text('저장')),
                                        ],
                                      );

                                    });
                                  },
                                  child: ListTile(
                                  title: Text(
                                      '${snapshot.data!.keys.toList()[index].replaceAll('a', '')}원 이상 마일리지 : ${snapshot.data!.values.toList()[index]}원'),
                                 ));
                            });
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    }),
                    FutureBuilder(
                        future: ManagerService().getMileageStandardForCard(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                                itemCount: snapshot.data!.values.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                  onTap: (){
                                    controller.text = snapshot.data!.values.toList()[index].toString();
                                    showDialog(context: context, builder: (context){
                                      return AlertDialog(
                                        title: Text('마일리지 설정 변경 ( ${snapshot.data!.keys.toList()[index].replaceAll('a', '') + '원'}'),
                                        content:  TextField(
                                          controller: controller,
                                          keyboardType: TextInputType.number,
                                        ),
                                        actions: [
                                          TextButton(onPressed: (){
                                            Navigator.pop(context);
                                          }, child: const Text('취소')),
                                          TextButton(onPressed: (){
                                            final standard = snapshot.data!.keys.toList()[index].toString();
                                            final mileage = int.parse(controller.text);
                                            print({standard: mileage}.toString());
                                            ManagerService().updateMileageStandardForCard({standard: mileage});
                                            Navigator.pop(context);
                                            setState(() {

                                            });
                                          }, child: const Text('저장')),
                                        ],
                                      );

                                    });
                                  },
                                      child: ListTile(
                                      title: Text(
                                          '${snapshot.data!.keys.toList()[index].replaceAll('a', '')}원 이상 마일리지 : ${snapshot.data!.values.toList()[index]}원'),
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
