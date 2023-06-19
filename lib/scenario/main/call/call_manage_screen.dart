import 'package:call_0953_manager/model/call.dart';
import 'package:call_0953_manager/service/call_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class CallManageScreen extends ConsumerStatefulWidget {
  const CallManageScreen({super.key});

  @override
  CallManageScreenState createState() => CallManageScreenState();
}

class CallManageScreenState extends ConsumerState<CallManageScreen> {
  final firstDate = StateProvider(
      (ref) => DateTime.now().subtract(const Duration(days: 365)));
  final lastDate = StateProvider((ref) => DateTime.now());
  bool isAll = true;

  @override
  Widget build(BuildContext context) {
    final startDate = ref.watch(firstDate);
    final endDate = ref.watch(lastDate);

    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ExpansionTile(
            title: Text('기간 선택'),
            children: [
              CheckboxListTile(
                title: InkWell(
                  onTap: () {
                    setState(() {
                      isAll = !isAll;
                    });
                  },
                  child: const Text('모든 대리 기록 보기'),
                ),
                value: isAll,
                onChanged: (value) {
                  setState(() {
                    isAll = value!;
                  });
                },
              ),
              if (!isAll) ...[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              '시작 날짜 : ${startDate.toString().substring(0, 10)}',
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black)),
                          ElevatedButton(
                              onPressed: () {
                                showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now().subtract(
                                            const Duration(days: 365 * 3)),
                                        lastDate: DateTime.now())
                                    .then((value) {
                                  if (value != null) {
                                    ref.read(firstDate.notifier).state = value;
                                  }
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.yellow,
                              ),
                              child: const Text('날짜선택',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black))),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('끝 날짜 : ${endDate.toString().substring(0, 10)}',
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black)),
                          ElevatedButton(
                              onPressed: () {
                                showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now().subtract(
                                            const Duration(days: 365)),
                                        lastDate: DateTime.now())
                                    .then((value) {
                                  if (value != null) {
                                    ref.read(lastDate.notifier).state = value;
                                  }
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.yellow,
                              ),
                              child: const Text('날짜선택',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black))),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
          const Divider(),
          Expanded(
            child: FutureBuilder(
              future: CallService().getAllCall(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  snapshot.data!.sort((a, b) => b.date.compareTo(a.date));
                  List<Call> result = isAll
                      ? snapshot.data!
                      : snapshot.data!
                          .where((element) =>
                              DateFormat('yyyy-MM-dd')
                                  .parse(element.date)
                                  .add(const Duration(days: 1))
                                  .isAfter(startDate) &&
                              DateFormat('yyyy-MM-dd')
                                  .parse(element.date)
                                  .subtract(const Duration(days: 1))
                                  .isBefore(endDate))
                          .toList();
                  return ListView.builder(
                    itemCount: result.length,
                    itemBuilder: (context, index) {
                      return ExpansionTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(result[index].name),
                            Text('${result[index].price}원')
                          ],
                        ),
                        subtitle: Text(
                            result[index].date.toString().replaceAll('-', '/')),
                        expandedAlignment: Alignment.topLeft,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 20, bottom: 10),
                            child: Text(
                                '전화번호 : ${result[index].call}\n닉네임 : ${result[index].name}\n대리 금액 : ${result[index].price.toString()}\n적립금: ${result[index].mileage}',
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    height: 1.5)),
                          )
                        ],
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          )
        ]));
  }
}
