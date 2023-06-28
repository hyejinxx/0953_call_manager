import 'package:call_0953_manager/model/call.dart';
import 'package:call_0953_manager/model/user.dart';
import 'package:call_0953_manager/scenario/main/mileage/mileage_add_screen.dart';
import 'package:call_0953_manager/scenario/main/user/user_edit_screen.dart';
import 'package:call_0953_manager/service/call_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

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
  late FutureProvider<List<Call>> callProvider;
  late FutureProvider<User?> userProvider;
  late TabController tabController;

  final _selectedIndex = StateProvider((ref) => 0);
  final _callSelectedIndex = StateProvider((ref) => 0);

  @override
  void initState() {
    mileageProvider = FutureProvider<List<Mileage>>(
        (ref) => MileageService().getMileageRecordUser(widget.user));

    callProvider = FutureProvider<List<Call>>(
        (ref) => CallService().getCallForUser(widget.user));
    userProvider =
        FutureProvider<User?>((ref) => UserService().getUser(widget.user));
    tabController = TabController(length: 3, vsync: this);

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
    final selectedIndex = ref.watch(_selectedIndex);
    final callSelectedIndex = ref.watch(_callSelectedIndex);
    final call = ref.watch(callProvider);

    return user.when(
      data: (user) {
        if (user == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return Scaffold(
            appBar: AppBar(
              title: Text(user.call,
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
              actions: [
                // 회원 정보 수정 아이콘
                IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserEditScreen(user: user)));
                  },
                  icon: Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Icon(
                        Icons.edit,
                        color: Colors.black,
                      )),
                ),
              ],
            ),
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
                      Tab(text: '콜 내역'),
                    ],
                    labelColor: Colors.black,
                  ),
                  Expanded(
                      child: TabBarView(
                    controller: tabController,
                    children: [
                      mileage.when(data: (data) {
                        final list = data
                            .where((element) =>  !element.type.contains('출금'))
                            .toList();
                        if (selectedIndex == 0) {
                          list.sort((a, b) => a.date.compareTo(b.date));
                        } else if (selectedIndex == 1) {
                          list.sort((a, b) => a.type.compareTo(b.type));
                        } else if (selectedIndex == 2) {
                          list.sort((a, b) => a.amount.compareTo(b.amount));
                        } else if (selectedIndex == 3) {
                          list.sort(
                              (a, b) => a.sumMileage.compareTo(b.sumMileage));
                        } else {
                          list.sort((a, b) => a.date.compareTo(b.date));
                        }
                        return SfDataGrid(
                            defaultColumnWidth:
                                MediaQuery.of(context).size.width / 6,
                            source: UserMileageDataSource(
                                mileageData: list.reversed.toList()),
                            onCellDoubleTap: (details) {
                              if (details.rowColumnIndex.rowIndex == 0) {
                                ref.read(_selectedIndex.notifier).state =
                                    details.rowColumnIndex.columnIndex;
                              }
                            },
                            columns: <GridColumn>[
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
                                  columnName: 'type',
                                  label: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      alignment: Alignment.center,
                                      child: const Text(
                                        '적립유형',
                                        overflow: TextOverflow.ellipsis,
                                      ))),
                              GridColumn(
                                  columnName: 'amount',
                                  label: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      alignment: Alignment.center,
                                      child: const Text(
                                        '금액',
                                        overflow: TextOverflow.ellipsis,
                                      ))),
                              GridColumn(
                                  columnName: 'sumMileage',
                                  label: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      alignment: Alignment.center,
                                      child: const Text(
                                        '누적액',
                                        overflow: TextOverflow.ellipsis,
                                      ))),
                              GridColumn(
                                  columnName: 'startAddress',
                                  label: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      alignment: Alignment.center,
                                      child: const Text(
                                        '출발지',
                                        overflow: TextOverflow.ellipsis,
                                      ))),
                              GridColumn(
                                  columnName: 'endAddress',
                                  label: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      alignment: Alignment.center,
                                      child: const Text(
                                        '도착지',
                                        overflow: TextOverflow.ellipsis,
                                      )))
                            ]);
                      }, error: (error, stackTrace) {
                        return const Text('기록을 불러오는 중 오류가 발생했습니다.');
                      }, loading: () {
                        return const Text('기록을 불러오는 중...');
                      }),
                      mileage.when(data: (data) {
                        final list = data
                            .where((element) => element.type.contains('출금'))
                            .toList();
                        if (selectedIndex == 0) {
                          list.sort((a, b) => a.date.compareTo(b.date));
                        } else if (selectedIndex == 1) {
                          list.sort((a, b) => a.type.compareTo(b.type));
                        } else if (selectedIndex == 2) {
                          list.sort((a, b) => a.amount.compareTo(b.amount));
                        } else if (selectedIndex == 3) {
                          list.sort(
                              (a, b) => a.sumMileage.compareTo(b.sumMileage));
                        } else {
                          list.sort((a, b) => a.date.compareTo(b.date));
                        }
                        return SfDataGrid(
                            defaultColumnWidth:
                                MediaQuery.of(context).size.width / 6,
                            source: UserMileageDataSource(mileageData: list),
                            onCellDoubleTap: (details) {
                              if (details.rowColumnIndex.rowIndex == 0) {
                                ref.read(_selectedIndex.notifier).state =
                                    details.rowColumnIndex.columnIndex;
                              }
                            },
                            columns: <GridColumn>[
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
                                  columnName: 'type',
                                  label: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      alignment: Alignment.center,
                                      child: const Text(
                                        '적립유형',
                                        overflow: TextOverflow.ellipsis,
                                      ))),
                              GridColumn(
                                  columnName: 'amount',
                                  label: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      alignment: Alignment.center,
                                      child: const Text(
                                        '금액',
                                        overflow: TextOverflow.ellipsis,
                                      ))),
                              GridColumn(
                                  columnName: 'sumMileage',
                                  label: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      alignment: Alignment.center,
                                      child: const Text(
                                        '누적액',
                                        overflow: TextOverflow.ellipsis,
                                      ))),
                              GridColumn(
                                  columnName: 'startAddress',
                                  label: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      alignment: Alignment.center,
                                      child: const Text(
                                        '출발지',
                                        overflow: TextOverflow.ellipsis,
                                      ))),
                              GridColumn(
                                  columnName: 'endAddress',
                                  label: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      alignment: Alignment.center,
                                      child: const Text(
                                        '도착지',
                                        overflow: TextOverflow.ellipsis,
                                      )))
                            ]);
                      }, error: (error, stackTrace) {
                        return const Text('기록을 불러오는 중 오류가 발생했습니다.');
                      }, loading: () {
                        return const Text('기록을 불러오는 중...');
                      }),
                      call.when(data: (data) {
                        if (data.isEmpty) return const Text('기록이 없습니다.');

                        if (callSelectedIndex == 0) {
                          data.sort((a, b) => a.date.compareTo(b.date));
                        } else if (callSelectedIndex == 3) {
                          data.sort((a, b) => a.price.compareTo(b.price));
                        } else if (callSelectedIndex == 4) {
                          data.sort((a, b) =>
                              a.mileage ?? 0.compareTo(b.mileage ?? 0));
                        } else if (callSelectedIndex == 5) {
                          data.sort((a, b) =>
                              a.bonusMileage ??
                              0.compareTo(b.bonusMileage ?? 0));
                        } else if (callSelectedIndex == 6) {
                          data.sort((a, b) =>
                              a.sumMileage ?? 0.compareTo(b.sumMileage ?? 0));
                        } else {
                          data.sort((a, b) => a.date.compareTo(b.date));
                        }

                        return SfDataGrid(
                            defaultColumnWidth:
                                MediaQuery.of(context).size.width / 7,
                            source: UserCallDataSource(callData: data),
                            onCellDoubleTap: (details) {
                              if (details.rowColumnIndex.rowIndex == 0) {
                                ref.read(_callSelectedIndex.notifier).state =
                                    details.rowColumnIndex.columnIndex;
                              }
                            },
                            columns: <GridColumn>[
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
                                  columnName: 'startAddress',
                                  label: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      alignment: Alignment.center,
                                      child: const Text(
                                        '출발',
                                        overflow: TextOverflow.ellipsis,
                                      ))),
                              GridColumn(
                                  columnName: 'endAddress',
                                  label: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      alignment: Alignment.center,
                                      child: const Text(
                                        '도착',
                                        overflow: TextOverflow.ellipsis,
                                      ))),
                              GridColumn(
                                  columnName: 'price',
                                  label: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      alignment: Alignment.center,
                                      child: const Text(
                                        '콜 금액',
                                        overflow: TextOverflow.ellipsis,
                                      ))),
                              GridColumn(
                                  columnName: 'mileage',
                                  label: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      alignment: Alignment.center,
                                      child: const Text(
                                        '적립금',
                                        overflow: TextOverflow.ellipsis,
                                      ))),
                              GridColumn(
                                  columnName: 'bonusMileage',
                                  label: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      alignment: Alignment.center,
                                      child: const Text(
                                        '이벤트',
                                        overflow: TextOverflow.ellipsis,
                                      ))),
                              GridColumn(
                                  columnName: 'sumMileage',
                                  label: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      alignment: Alignment.center,
                                      child: const Text(
                                        '총 적립',
                                        overflow: TextOverflow.ellipsis,
                                      )))
                            ]);
                      }, error: (error, stackTrace) {
                        return const Text('기록을 불러오는 중 오류가 발생했습니다.');
                      }, loading: () {
                        return const Text('기록을 불러오는 중...');
                      }),
                    ],
                  )),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MileageAddScreen(
                                    call: widget.user,
                                    name: user.name,
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
      },
      error: (st, e) {
        return Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: const Center(
                child: Text('회원 정보를 불러오는 데에 실패했습니다',
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Colors.black))));
      },
      loading: () => Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: const Center(
              child: Text('회원 정보를 불러오고 있습니다',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Colors.black)))),
    );
  }
}

class UserMileageDataSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  UserMileageDataSource({required List<Mileage> mileageData}) {
    _mileageData = mileageData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(columnName: 'date', value: e.date),
              DataGridCell<String>(columnName: 'type', value: e.type),
              DataGridCell<int>(columnName: 'amount', value: e.amount),
              DataGridCell<int>(columnName: 'sumMileage', value: e.sumMileage),
              DataGridCell<String>(
                  columnName: 'startAddress', value: e.startAddress),
              DataGridCell<String>(
                  columnName: 'endAddress', value: e.endAddress),
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

class UserCallDataSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  UserCallDataSource({required List<Call> callData}) {
    _callData = callData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(columnName: 'date', value: e.date),
              DataGridCell<String>(
                  columnName: 'startAddress', value: e.startAddress),
              DataGridCell<String>(
                  columnName: 'endAddress', value: e.endAddress),
              DataGridCell<int>(columnName: 'price', value: e.price),
              DataGridCell<int>(columnName: 'mileage', value: e.mileage),
              DataGridCell<int>(
                  columnName: 'bonusMileage', value: e.bonusMileage),
              DataGridCell<int>(columnName: 'sumMileage', value: e.sumMileage),
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
