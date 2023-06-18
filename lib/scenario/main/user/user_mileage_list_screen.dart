import 'package:call_0953_manager/model/user.dart';
import 'package:call_0953_manager/scenario/main/mileage/mileage_add_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../model/mileage.dart';
import '../../../service/mileage_service.dart';
import '../../../service/user_service.dart';

class UserMileageRecordScreen extends ConsumerStatefulWidget {
  const UserMileageRecordScreen({Key? key, required this.user})
      : super(key: key);

  final String user;

  @override
  UserMileageRecordScreenState createState() => UserMileageRecordScreenState();
}

class UserMileageRecordScreenState
    extends ConsumerState<UserMileageRecordScreen>
    with TickerProviderStateMixin {
  late FutureProvider<List<Mileage>> mileageProvider;
  late FutureProvider<User?> userProvider;
  late TabController tabController;

  @override
  void initState() {
    mileageProvider = FutureProvider<List<Mileage>>(
        (ref) => MileageService().getMileageRecordUser(widget.user));

    userProvider =
        FutureProvider<User?>((ref) => UserService().getUser(widget.user));
    tabController = TabController(length: 2, vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    ref.invalidate(mileageProvider);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mileage = ref.watch(mileageProvider);
    final user = ref.watch(userProvider);
    return Scaffold(
        appBar: AppBar(
            title: Text('${widget.user} 의 마일리지 기록',
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
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              color: Colors.black,
              onPressed: () {
                Navigator.pop(context);
              },
            )),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              TabBar(
                controller: tabController,
                indicatorColor: Colors.yellow,
                tabs: const [
                  Tab(text: '입금 내역'),
                  Tab(text: '출금 내역'),
                ],
                labelColor: Colors.black,
              ),
              Expanded(
                  child: TabBarView(
                controller: tabController,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: mileage.when(data: (data) {
                        final list = data
                            .where((element) => element.type != "출금")
                            .toList();
                        return list.map((e) => _buildMileageItem(e)).toList();
                      }, error: (error, stackTrace) {
                        return const [Text('기록을 불러오는 중 오류가 발생했습니다.')];
                      }, loading: () {
                        return const [Text('기록을 불러오는 중...')];
                      }),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: mileage.when(data: (data) {
                        final list = data
                            .where((element) => element.type == "출금")
                            .toList();
                        return list.map((e) => _buildMileageItem(e)).toList();
                      }, error: (error, stackTrace) {
                        return const [Text('기록을 불러오는 중 오류가 발생했습니다.')];
                      }, loading: () {
                        return const [Text('기록을 불러오는 중...')];
                      }),
                    ),
                  ),
                ],
              )),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MileageAddScreen(
                                call: widget.user,
                                name: user.value?.name,
                              )));
                },
                child: Container(
                  height: 70,
                  alignment: Alignment.center,
                  color: Colors.yellow,
                  width: MediaQuery.of(context).size.width,
                  child: const Text('마일리지 적립'),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildMileageItem(Mileage mileage) => Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              mileage.date.toString().substring(0, 10),
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            if (mileage.type == '출금')
              Text(
                '출금 금액 : ${mileage.amount}',
                style: const TextStyle(fontSize: 18),
              )
            else
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                  '적립 금액 : ${mileage.amount}',
                  style: const TextStyle(fontSize: 18),
                ),
                Text(mileage.type, style: const TextStyle(fontSize: 15))
              ]),
            const Divider()
          ],
        ),
      );
}
