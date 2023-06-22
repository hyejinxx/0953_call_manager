import 'package:call_0953_manager/model/withdraw.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ExpansionTile(
          title: Text('출금 상태 선택'),
          children: [
            RadioListTile(
              title: Text("전체"),
              value: WithdrawStatus.all,
              groupValue: isAll,
              onChanged: (WithdrawStatus? value) {
                setState(() {
                  isAll = value!;
                });
              },
            ),
            RadioListTile(
              title: Text("출금 요청"),
              value: WithdrawStatus.waiting,
              groupValue: isAll,
              onChanged: (WithdrawStatus? value) {
                setState(() {
                  isAll = value!;
                });
              },
            ),
            RadioListTile(
              title: Text("출금 완료"),
              value: WithdrawStatus.completed,
              groupValue: isAll,
              onChanged: (WithdrawStatus? value) {
                setState(() {
                  isAll = value!;
                });
              },
            ),
            RadioListTile(
              title: Text("출금 거절"),
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
        const Divider(),
        Expanded(
            child: FutureBuilder(
          future: MileageService().getWithdraw(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              snapshot.data!.sort((a, b) => b.createdAt.compareTo(a.createdAt));
              List<Withdraw> result = snapshot.data!.where((element) {
                if (isAll == WithdrawStatus.all) {
                  return true;
                } else if (isAll == WithdrawStatus.waiting) {
                  return element.status == '요청대기';
                } else if (isAll == WithdrawStatus.completed) {
                  return element.status == '출금완료';
                } else if (isAll == WithdrawStatus.rejected) {
                  return element.status == '출금거절';
                } else {
                  return false;
                }
              }).toList();
              return ListView.builder(
                itemCount: result.length,
                itemBuilder: (context, index) {
                  return ExpansionTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(result[index].userCall),
                        Text('요청 금액: ${result[index].amount}원')
                      ],
                    ),
                    subtitle: Text(
                        result[index].status == '요청대기'
                            ? '요청 대기중'
                            : result[index].status == '출금완료'
                                ? '출금 완료'
                                : '출금 거절',),
                    expandedAlignment: Alignment.topLeft,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 20, bottom: 10, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                  '전화번호 : ${result[index].userCall}\n'
                                  '은행 : ${result[index].bank}\n'
                                  '계좌번호 : ${result[index].account}\n'
                                  '예금주 : ${result[index].name}\n'
                                  '출금 상태 : ${result[index].status}',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      height: 1.5)),
                              if(result[index].status == '요청대기')...[
                                Column(children: [
                                  ElevatedButton(onPressed: (){
                                    MileageService().updateWithdraw(result[index], '출금완료');
                                    setState(() {
                                      result[index].status = '출금완료';
                                    });
                                    setState(() {
                                      result[index].status = '출금완료';
                                    });
                                  }, child: const Text('출금 완료')),
                                  const SizedBox(height: 10,),
                                  ElevatedButton(onPressed: (){
                                    MileageService().updateWithdraw(result[index], '출금거절');
                                    setState(() {
                                      result[index].status = '출금거절';
                                    });
                                    setState(() {
                                      result[index].status = '출금거절';
                                    });

                                  }, child: const Text('출금 거절')),
                                ],),
                              ]

                              // InkWell(
                              //   onTap: () {
                              //     Navigator.push(
                              //         context,
                              //         MaterialPageRoute(
                              //           builder: (context) =>
                              //               UserMileageRecordScreen(
                              //                   user: result[index].userCall),
                              //         ));
                              //   },
                              //   child: Container(
                              //     padding: const EdgeInsets.symmetric(
                              //         horizontal: 8, vertical: 4),
                              //     decoration: BoxDecoration(
                              //         borderRadius: BorderRadius.circular(4),
                              //         border: Border.all(color: Colors.black)),
                              //     child: const Text('마일리지 내역'),
                              //   ),
                              // )
                            ],
                          ))
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
        ))
      ]),
    );
  }
}
