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
  final isUserProvider = StateProvider((ref) => true);
  bool isAll = true;

  late List<bool> isSelected;

  @override
  Widget build(BuildContext context) {
    final startDate = ref.watch(firstDate);
    final endDate = ref.watch(lastDate);
    final isUser = ref.watch(isUserProvider);

    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ToggleButtons(
              isSelected: [isUser, !isUser],
              onPressed: (index) {
                setState(() {
                  if (index == 0) {
                   ref.read(isUserProvider.notifier).state = true;
                  } else {
                    ref.read(isUserProvider.notifier).state = false;
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
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
                  return SfDataGrid(
                      defaultColumnWidth: MediaQuery.of(context).size.width / 6,
                      source: CallDataSource(callData: result),
                      onCellDoubleTap: (details){
                        if (details.rowColumnIndex.rowIndex == 0) {
                          final index = details.rowColumnIndex.columnIndex;
                          if (index == 0) {
                            result.sort((a, b) => a.call.compareTo(b.call));
                          } else if (index == 1) {
                            result.sort((a, b) => a.name.compareTo(b.name));
                          } else if (index == 2) {
                            result.sort((a, b) => a.mileage??0.compareTo(b.mileage??0));
                          } else if (index == 3) {
                            result.sort((a, b) => a.bonusMileage??0.compareTo(b.bonusMileage??0));
                          } else if (index == 4) {
                            result.sort((a, b) => a.date.compareTo(b.date));
                          } else if (index == 5) {
                            result.sort((a, b) => a.price.compareTo(b.price));
                          }
                          setState(() {});
                        }
                      },
                      columns: <GridColumn>[
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
                      ]);
                } else {
                  return const Center(
                    child: Text('데이터가 없습니다.'),
                  );
                }
              },
            ),
          ),
          InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('비회원 대리 기록 삭제'),
                        content: const Text('비회원 대리 기록을 모두 삭제하시겠습니까?'),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context, false);
                              },
                              child: const Text('취소')),
                          TextButton(
                              onPressed: () {
                                CallService().deleteAllCallNotUser();
                                Navigator.pop(context, true);
                              },
                              child: const Text('확인')),
                        ],
                      );
                    });
              },
              child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  width: double.infinity,
                  color: Colors.yellow,
                  child: const Text(
                    '비회원 대리 기록 삭제하기',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )))
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
              DataGridCell<int>(
                  columnName: 'bonusMileage', value: e.bonusMileage),
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
