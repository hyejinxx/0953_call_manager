import 'package:call_0953_manager/model/withdraw.dart';
import 'package:flutter/material.dart';

import '../../../service/mileage_service.dart';

class WithdrawScreen extends StatefulWidget {
  WithdrawScreen({super.key, required this.withdraw});

  Withdraw withdraw;

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('출금 관리',
              style: TextStyle(color: Colors.black),
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
        ),
        body: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('출금 금액: '),
                    Text(widget.withdraw.amount.toString()),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('출금 은행: '),
                    Text(widget.withdraw.bank),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('출금 계좌: '),
                    Text(widget.withdraw.account),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('예금주: '),
                    Text(widget.withdraw.bank),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('출금 은행: '),
                    Text(widget.withdraw.bank),
                  ],
                ),
                const SizedBox(height: 20),
                if (widget.withdraw.status == '요청대기') ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      ElevatedButton(
                          onPressed: () async {
                            final re = await showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                      title: const Text('출금 완료'),
                                      content: const Text('출금을 완료하시겠습니까?'),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context, true);
                                            },
                                            child: const Text('확인')),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context, false);
                                            },
                                            child: const Text('취소')),
                                      ],
                                    ));
                            if (re == true) {
                              MileageService()
                                  .updateWithdraw(widget.withdraw, '출금완료');
                              setState(() {
                                widget.withdraw.status = '출금완료';
                              });
                            }
                          },
                          child: const Text('출금 완료')),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            final re = await showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                      title: const Text('출금 거절'),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text('출금을 거절하시겠습니까?'),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          TextField(
                                            controller: _controller,
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: '거절 사유',
                                            ),
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context, true);
                                            },
                                            child: const Text('확인')),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context, false);
                                            },
                                            child: const Text('취소')),
                                      ],
                                    ));
                            if (re) {
                              MileageService().updateWithdraw(
                                  widget.withdraw, '출금거절${_controller.text}');
                              setState(() {
                                widget.withdraw.status = '출금거절';
                              });
                              setState(() {
                                widget.withdraw.status = '출금거절';
                              });
                            }
                          },
                          child: const Text('출금 거절')),
                    ],
                  ),
                ]
              ],
            )));
  }
}
