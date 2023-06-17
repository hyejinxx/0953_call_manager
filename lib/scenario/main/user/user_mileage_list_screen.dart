import 'package:call_0953_manager/model/user.dart';
import 'package:call_0953_manager/scenario/main/mileage/mileage_add_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../model/mileage.dart';
import '../../../service/mileage_service.dart';

class UserMileageRecordScreen extends ConsumerStatefulWidget {
  const UserMileageRecordScreen({Key? key, required this.user})
      : super(key: key);

  final User user;

  @override
  UserMileageRecordScreenState createState() => UserMileageRecordScreenState();
}

class UserMileageRecordScreenState
    extends ConsumerState<UserMileageRecordScreen> {
  late FutureProvider<List<Mileage>> mileageProvider;

  @override
  void initState() {
    mileageProvider = FutureProvider<List<Mileage>>(
        (ref) => MileageService().getMileageRecordUser(widget.user.call));

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
    return Scaffold(
        appBar: AppBar(
            title: Text('${widget.user.name}의 마일리지 기록',
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
            child: Stack(
              children: [
                Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: mileage.when(
                          data: (data) =>
                              data.map((e) => _buildMileageItem(e)).toList(),
                          error: (error, stackTrace) {
                            return const [Text('- 원')];
                          },
                          loading: () {
                            return const [Text('- 원')];
                          }),
                    )),
                Positioned(
                  bottom: 0,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MileageAddScreen(
                                    call: widget.user.call,
                                    name: widget.user.name,
                                  )));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      color: Colors.yellow,
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(20),
                      child: const Text('마일리지 추가하기'),
                    ),
                  ),
                )
              ],
            )));
  }

  Widget _buildMileageItem(Mileage mileage) => Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              mileage.date.toString(),
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '적립금 : ${mileage.amount}',
                  style: const TextStyle(fontSize: 18),
                ),
                Text('적립 타입 : ${mileage.type}', style: const TextStyle(fontSize: 18))
              ],
            ),
            const Divider()
          ],
        ),
      );
}
