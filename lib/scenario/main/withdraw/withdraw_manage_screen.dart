import 'package:call_0953_manager/model/withdraw.dart';
import 'package:call_0953_manager/scenario/main/withdraw/withdraw_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../service/mileage_service.dart';
import '../user/user_mileage_list_screen.dart';

enum WithdrawStatus { all, waiting, completed, rejected }

class WithdrawManageScreen extends ConsumerStatefulWidget {
  const WithdrawManageScreen({super.key});

  @override
  _WithdrawManageScreenState createState() => _WithdrawManageScreenState();
}

class _WithdrawManageScreenState extends ConsumerState<WithdrawManageScreen> {
  final firstDate = StateProvider(
      (ref) => DateTime.now().subtract(const Duration(days: 365)));
  final lastDate = StateProvider((ref) => DateTime.now());

  WithdrawStatus isAll = WithdrawStatus.all;
  final indexProvider = StateProvider<int>((ref) => 0);
  final withdrawListProvider =
      FutureProvider((ref) => MileageService().getWithdraw());
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final index = ref.watch(indexProvider);
    final withdrawList = ref.watch(withdrawListProvider);

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ExpansionTile(
          title: const Text('출금 상태 선택'),
          children: [
            RadioListTile(
              title: const Text("전체"),
              value: WithdrawStatus.all,
              groupValue: isAll,
              onChanged: (WithdrawStatus? value) {
                setState(() {
                  isAll = value!;
                });
              },
            ),
            RadioListTile(
              title: const Text("출금 요청"),
              value: WithdrawStatus.waiting,
              groupValue: isAll,
              onChanged: (WithdrawStatus? value) {
                setState(() {
                  isAll = value!;
                });
              },
            ),
            RadioListTile(
              title: const Text("출금 완료"),
              value: WithdrawStatus.completed,
              groupValue: isAll,
              onChanged: (WithdrawStatus? value) {
                setState(() {
                  isAll = value!;
                });
              },
            ),
            RadioListTile(
              title: const Text("출금 거절"),
              value: WithdrawStatus.rejected,
              groupValue: isAll,
              onChanged: (WithdrawStatus? value) {
                setState(() {
                  isAll = value!;
                });
              },
            ),
          ],
        ),
        Expanded(
            child: withdrawList.when(
                data: (data) {
                  if (data.isNotEmpty) {
                    List<Withdraw> result = data!.where((element) {
                      if (isAll == WithdrawStatus.all) {
                        return true;
                      } else if (isAll == WithdrawStatus.waiting) {
                        return element.status == '요청대기';
                      } else if (isAll == WithdrawStatus.completed) {
                        return element.status == '출금완료';
                      } else if (isAll == WithdrawStatus.rejected) {
                        return element.status!.contains('출금거절');
                      } else {
                        return false;
                      }
                    }).toList();

                    if (index == 0) {
                      result.sort((a, b) => a.userCall.compareTo(b.userCall));
                    } else if (index == 1) {
                      result.sort((a, b) => a.name.compareTo(b.name));
                    } else if (index == 2) {
                      result.sort((a, b) => a.amount.compareTo(b.amount));
                    } else if (index == 3) {
                      result.sort((a, b) => a.bank.compareTo(b.bank));
                    } else if (index == 4) {
                      result
                          .sort((a, b) => a.account.compareTo(b.account));
                    } else if (index == 5) {
                      result.sort((a, b) => a.createdAt.compareTo(b.createdAt));
                    } else {
                      result.sort((a, b) => a.status.compareTo(b.status));
                    }

                    return SfDataGrid(
                        onCellDoubleTap: (detail) {
                          if (detail.rowColumnIndex.rowIndex == 0) {
                            ref.read(indexProvider.notifier).state =
                                detail.rowColumnIndex.columnIndex;
                          }
                        },
                        onCellTap: (value) {
                          if (value.rowColumnIndex.rowIndex != 0) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WithdrawScreen(
                                          withdraw: result[
                                              value.rowColumnIndex.rowIndex -
                                                  1],
                                        )));
                          }
                        },
                        defaultColumnWidth:
                            MediaQuery.of(context).size.width / 7,
                        source: WithdrawSource(withdraw: result.reversed.toList()),
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
                                    '예금주',
                                    overflow: TextOverflow.ellipsis,
                                  ))),
                          GridColumn(
                              columnName: 'amount',
                              label: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    '요청금액',
                                    overflow: TextOverflow.ellipsis,
                                  ))),
                          GridColumn(
                              columnName: 'bank',
                              label: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    '은행',
                                    overflow: TextOverflow.ellipsis,
                                  ))),
                          GridColumn(
                              columnName: 'account',
                              label: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    '계좌번호',
                                    overflow: TextOverflow.ellipsis,
                                  ))),
                          GridColumn(
                              columnName: 'date',
                              label: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    '요청일',
                                    overflow: TextOverflow.ellipsis,
                                  ))),
                          GridColumn(
                              columnName: 'status',
                              label: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    '출금상태',
                                    overflow: TextOverflow.ellipsis,
                                  ))),
                        ]);
                  } else {
                    return Center(
                      child: Text('출금 내역이 없습니다.'),
                    );
                  }
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) {
                  return Center(
                    child: Text(error.toString()),
                  );
                }))
      ]),
    );
  }
}

class WithdrawSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  WithdrawSource({required List<Withdraw> withdraw}) {
    _withdraw = withdraw
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(columnName: 'call', value: e.userCall),
              DataGridCell<String>(columnName: 'name', value: e.name),
              DataGridCell<int>(columnName: 'amount', value: e.amount),
              DataGridCell<String>(columnName: 'bank', value: e.bank),
              DataGridCell<String>(columnName: 'account', value: e.account),
              DataGridCell<String>(columnName: 'date', value: e.createdAt),
              DataGridCell<String>(columnName: 'status', value: e.status!),
            ]))
        .toList();
  }

  List<DataGridRow> _withdraw = [];

  @override
  List<DataGridRow> get rows => _withdraw;

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
