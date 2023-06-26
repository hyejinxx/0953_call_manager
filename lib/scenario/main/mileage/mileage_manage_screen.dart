import 'package:call_0953_manager/service/mileage_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/mileage.dart';

final firstDate =
    StateProvider((ref) => DateTime.now().subtract(const Duration(days: 365)));
final lastDate = StateProvider((ref) => DateTime.now());

class MileageManageScreen extends ConsumerStatefulWidget {
  const MileageManageScreen({super.key});

  @override
  _MileageManageScreenState createState() => _MileageManageScreenState();
}

class _MileageManageScreenState extends ConsumerState<MileageManageScreen> {
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
                child: const Text('모든 마일리지 보기'),
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
                        Text('시작 날짜 : ${startDate.toString().substring(0, 10)}',
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
                                      firstDate: DateTime.now()
                                          .subtract(const Duration(days: 365)),
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
          future: MileageService().getAllMileage(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              snapshot.data!.sort((a, b) => b.date.compareTo(a.date));
              List<Mileage> result = isAll
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
              return SfDataGrid(defaultColumnWidth: MediaQuery.of(context).size.width/5, source: MileageDataSource(mileageData: snapshot.data!), columns: <GridColumn>[
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
                    columnName: 'amount',
                    label: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: const Text(
                          '적립',
                          overflow: TextOverflow.ellipsis,
                        ))),
                GridColumn(
                    columnName: 'type',
                    label: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: const Text(
                          '적립 타입',
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

              ]);
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ))
      ]),
    );
  }
}

class MileageDataSource extends DataGridSource {

  /// Creates the employee data source class with required details.
  MileageDataSource({required List<Mileage> mileageData}) {
    _mileageData = mileageData
        .map<DataGridRow>((e) => DataGridRow(cells: [
      DataGridCell<String>(columnName: 'call', value: e.call),
      DataGridCell<String>(columnName: 'name', value: e.name),
      DataGridCell<int>(columnName: 'amount', value: e.amount),
      DataGridCell<String>(columnName: 'type', value: e.type),
      DataGridCell<String>(
          columnName: 'date', value: '${e.date} ${e.date}'),
    ]))
        .toList();
  }

  List<DataGridRow> _mileageData = [];

  @override
  List<DataGridRow> get rows => _mileageData;

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

