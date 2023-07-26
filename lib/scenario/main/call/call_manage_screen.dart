
import 'package:call_0953_manager/model/call.dart';
import 'package:call_0953_manager/service/call_service.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class CallManageScreen extends ConsumerStatefulWidget {
  const CallManageScreen({super.key});

  @override
  CallManageScreenState createState() => CallManageScreenState();
}

class CallManageScreenState extends ConsumerState<CallManageScreen> {
  final isUserProvider = StateProvider((ref) => true);

  late List<bool> isSelected;

  final tabIndexProvider = StateProvider<int>((ref) => 0);
  final FutureProvider callProvider = FutureProvider((ref) =>
      CallService().getAllCall()
  );
  final FutureProvider callNotUserProvider = FutureProvider((ref) =>
      CallService().getAllCall()
  );
  final FutureProvider callAllProvider = FutureProvider((ref) async {
    final call = await CallService().getAllCall();
    final callNotUser = await CallService().getAllCallNotUser();
    return call + callNotUser;
  });

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final callList = ref.watch(callProvider);
    final callNotUserList = ref.watch(callNotUserProvider);
    final callAllList = ref.watch(callAllProvider);
    final tabIndex = ref.watch(tabIndexProvider);

    return SizedBox(
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: MediaQuery
            .of(context)
            .size
            .height,
        child:
          TabView(currentIndex: tabIndex,
              onChanged: (index) {
                ref.read(tabIndexProvider.notifier).state = index;
              },
              tabs: [
            Tab(text: const Text('회원'), body: callList.when(data: (data) {
              return CallListWidget(callData: data);
            }, error: (e, st) => const Center(child: Text('기록을 불러오지 못했습니다')), loading: () {
              return const Center(child: ProgressRing());
            })),
            Tab(text: const Text('비회원'), body: callNotUserList.when(data: (data) {
              return CallListWidget(callData: data);
            }, error: (e, st) => const Center(child: Text('기록을 불러오지 못했습니다')), loading: () {
              return const Center(child: ProgressRing());
            })),
            Tab(text: const Text('전체'), body: callAllList.when(data: (data) {
              return CallListWidget(callData: data);
            }, error: (e, st) => const Center(child: Text('기록을 불러오지 못했습니다')), loading: () {
              return const Center(child: ProgressRing());
            })),
          ]),

          // InkWell(
          //     onTap: () {
          //       showDialog(
          //           context: context,
          //           builder: (BuildContext context) {
          //             return AlertDialog(
          //               title: const Text('비회원 대리 기록 삭제'),
          //               content: const Text('비회원 대리 기록을 모두 삭제하시겠습니까?'),
          //               actions: [
          //                 TextButton(
          //                     onPressed: () {
          //                       Navigator.pop(context, false);
          //                     },
          //                     child: const Text('취소')),
          //                 TextButton(
          //                     onPressed: () {
          //                       CallService().deleteAllCallNotUser();
          //                       Navigator.pop(context, true);
          //                     },
          //                     child: const Text('확인')),
          //               ],
          //             );
          //           });
          //     },
          //     child:
          //         Container(
          //         alignment: Alignment.center,
          //         height: 50,
          //         width: double.infinity,
          //         color: Colors.yellow,
          //         child: const Text(
          //           '회원 대리 기록 삭제하기',
          //           textAlign: TextAlign.center,
          //           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          //         )),
          //
          //
          // ),
        );
  }
}

class CallListWidget extends ConsumerStatefulWidget {
  CallListWidget({super.key, required this.callData});

  List<Call> callData = [];

  @override
  _CallListWidgetState createState() => _CallListWidgetState();
}

class _CallListWidgetState extends ConsumerState<CallListWidget> {
  final indexProvider = StateProvider<int>((ref) => 0);

  List<Call> result = [];

  @override
  void initState() {
    result = widget.callData;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final index = ref.watch(indexProvider);

    // if (index == 0) {
    //   setState(() {
    //     result.sort((a, b) => a.call.compareTo(b.call));
    //   });
    // } else if (index == 1) {
    //   setState(() {
    //     result.sort((a, b) => a.name.compareTo(b.name));
    //   });
    // } else if (index == 2) {
    //   setState(() {
    //     result.sort(
    //             (a, b) => a.mileage ?? 0.compareTo(b.mileage ?? 0));
    //   });
    // } else if (index == 3) {
    //   setState(() {
    //     result.sort((a, b) =>
    //     a.bonusMileage ?? 0.compareTo(b.bonusMileage ?? 0));
    //   });
    // } else if (index == 4) {
    //   setState(() {
    //     result.sort((a, b) =>
    //     a.sumMileage ?? 0.compareTo(b.sumMileage ?? 0));
    //   });
    // } else if (index == 6) {
    //   setState(() {
    //     result.sort((a, b) => a.price.compareTo(b.price));
    //   });
    // } else {
    //   setState(() {
    //     result.sort((a, b) => a.date.compareTo(b.date));
    //   });
    // }
    return Expanded(
      child:
      result.isNotEmpty ?
      SfDataGrid(
          defaultColumnWidth:
          MediaQuery
              .of(context)
              .size
              .width / 7,
          source: CallDataSource(callData: result),
          onCellDoubleTap: (details) {
            if (details.rowColumnIndex.rowIndex == 0) {
              ref
                  .read(indexProvider.notifier)
                  .state =
                  details.rowColumnIndex.columnIndex;
            }
          },
          sortingGestureType: SortingGestureType.doubleTap,
          allowSorting: true,
          showCheckboxColumn: true,
          showSortNumbers: true,
          shrinkWrapRows: true,
          shrinkWrapColumns: true,
          checkboxColumnSettings: const DataGridCheckboxColumnSettings(
              showCheckboxOnHeader: false),
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
                columnName: 'sumMileage',
                label: Container(
                    padding: const EdgeInsets.all(8.0),
                    alignment: Alignment.center,
                    child: const Text(
                      '소계',
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
                    )
                )
            )
            ,
          ]
      ) :
      const Center(
        child: Text('데이터가 없습니다.'),

      ),
    );
  }

}


class CallDataSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  CallDataSource({required List<Call> callData}) {
    _callData = callData
        .map<DataGridRow>((e) =>
        DataGridRow(cells: [
          DataGridCell<String>(columnName: 'call', value: e.call),
          DataGridCell<String>(columnName: 'name', value: e.name),
          DataGridCell<int>(columnName: 'mileage', value: e.mileage),
          DataGridCell<int>(
              columnName: 'bonusMileage', value: e.bonusMileage),
          DataGridCell<int>(columnName: 'sumMileage', value: e.sumMileage),
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
