import 'package:call_0953_manager/model/call.dart';
import 'package:call_0953_manager/service/call_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

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
  bool isUser = true;

  late List<bool> isSelected;

  @override
  void initState() {
    isSelected = [isUser, !isUser];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final startDate = ref.watch(firstDate);
    final endDate = ref.watch(lastDate);

    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ToggleButtons(
              isSelected: isSelected,
              onPressed: (index) {
                setState(() {
                  if (index == 0) {
                    isUser = true;
                  } else {
                    isUser = false;
                  }
                });
              },
              children: const [
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('회원', style: TextStyle(fontSize: 18))),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('비회원', style: TextStyle(fontSize: 18))),
              ]),
          ExpansionTile(
            title: const Text('기간 선택'),
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
              future: isUser
                  ? CallService().getAllCall()
                  : CallService().getAllCallNotUser(),
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
                  return Stack(
                    children: [
                      SfDataGrid(source: CallDataSource(callData: snapshot.data!), columns: <GridColumn>[
                        GridColumn(
                            columnName: 'call',
                            label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                child: const Text(
                                  '전화번호',
                                  overflow: TextOverflow.ellipsis,
                                ))),
                        GridColumn(
                            columnName: 'name',
                            label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                child: const Text(
                                  '이름',
                                  overflow: TextOverflow.ellipsis,
                                ))),
                        GridColumn(
                            columnName: 'mileage',
                            label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                child: const Text(
                                  '적립',
                                  overflow: TextOverflow.ellipsis,
                                ))),
                        GridColumn(
                            columnName: 'bonusMileage',
                            label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                child: const Text(
                                  '이벤트 적립',
                                  overflow: TextOverflow.ellipsis,
                                ))),
                        GridColumn(
                            columnName: 'date',
                            label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                child: const Text(
                                  '일자',
                                  overflow: TextOverflow.ellipsis,
                                ))),
                        GridColumn(
                            columnName: 'price',
                            label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                child: const Text(
                                  '대리 금액',
                                  overflow: TextOverflow.ellipsis,
                                ))),
                      ]),
                      // ListView.builder(
                      //   itemCount: result.length,
                      //   itemBuilder: (context, index) {
                      //     return ExpansionTile(
                      //       title: Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Text(result[index].call),
                      //           Text('${result[index].price}원')
                      //         ],
                      //       ),
                      //       subtitle: Text(
                      //           result[index].date.replaceAll('-', '/') +
                      //               result[index].time),
                      //       expandedAlignment: Alignment.topLeft,
                      //       children: [
                      //         Padding(
                      //           padding:
                      //               const EdgeInsets.only(left: 20, bottom: 10),
                      //           child: Text(
                      //               '전화번호: ${result[index].call}\n닉네임: ${result[index].name}\n대리 요금: ${result[index].price.toString()}\n적립금: ${result[index].mileage}\n추가 적립금: ${result[index].bonusMileage}',
                      //               style: const TextStyle(
                      //                   fontSize: 16,
                      //                   fontWeight: FontWeight.w500,
                      //                   height: 1.5)),
                      //         )
                      //       ],
                      //     );
                      //   },
                      // ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: InkWell(
                            onTap: () {
                              CallService().deleteAllCallNotUser();
                            },
                            child: Container(
                              height: 50,
                              width: double.infinity,
                              color: Colors.white,
                              child: const Text('비회원 대리 기록 삭제하기'),
                            )),
                      )
                    ],
                  );
                } else {
                  return const Center(
                    child: Text('데이터가 없습니다.'),
                  );
                }
              },
            ),
          )
        ]));
  }
}
class CallDataSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  CallDataSource({required List<Call> callData}) {
    _callData = callData
        .map<DataGridRow>((e) => DataGridRow(cells: [
      DataGridCell<String>(columnName: 'call', value: e.call),
      DataGridCell<String>(columnName: 'name', value: e.name),
      DataGridCell<int>(columnName: 'mileage', value: e.mileage),
      DataGridCell<int>(columnName: 'bonusMileage', value: e.bonusMileage),
      DataGridCell<String>(
          columnName: 'date', value: '${e.date} ${e.time}'),
      DataGridCell<int>(columnName: 'price', value: e.price),
    ]))
        .toList();
  }

  List<DataGridRow> _callData = [];

  @override
  List<DataGridRow> get rows => _callData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            child: Text(e.value.toString()),
          );
        }).toList());
  }
}

