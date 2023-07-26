import 'package:call_0953_manager/service/user_service.dart';
import 'package:flutter/material.dart';

import '../../../model/user.dart';

class UserEditScreen extends StatefulWidget {
  const UserEditScreen({super.key, required this.user});

  final User user;

  @override
  State<UserEditScreen> createState() => _UserEditScreenState();
}

class _UserEditScreenState extends State<UserEditScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _storeController = TextEditingController();
  final TextEditingController _recommendCallController =
      TextEditingController();
  final TextEditingController _storeCallController = TextEditingController();
  final TextEditingController _storeAddressController = TextEditingController();
  bool isTermAgreed = true;
  bool isPrivacyAgreed = true;

  @override
  void initState() {
    _nameController.text = widget.user.name;
    _destinationController.text = widget.user.destination ?? '';
    _storeController.text = widget.user.store ?? '';
    _recommendCallController.text = widget.user.recommendUser ?? '';
    _storeCallController.text = widget.user.storeCall ?? '';
    _storeAddressController.text = widget.user.storeAddress ?? '';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user.call,
            style: const TextStyle(color: Colors.black),
            textAlign: TextAlign.center),
        backgroundColor: Colors.white,
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
        ),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: (context),
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('회원 탈퇴'),
                        content: const Text('회원을 탈퇴하시겠습니까?'),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('취소')),
                          TextButton(
                              onPressed: () {
                                UserService()
                                    .deleteUser(widget.user.call)
                                    .then((value) =>
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text('회원 탈퇴가 완료되었습니다.'),
                                            duration: Duration(seconds: 1),
                                          ),
                                        ))
                                    .onError((error, stackTrace) =>
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text('회원 탈퇴에 실패했습니다.'),
                                            duration: Duration(seconds: 1),
                                          ),
                                        ));
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: const Text('확인')),
                        ],
                      );
                    });
              },
              icon: const Icon(
                Icons.delete_forever,
                color: Colors.black,
              ))
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 40.0,
            bottom: 20.0,
            left: 20.0,
            right: 20.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      enabled: false,
                      controller: TextEditingController(text: widget.user.call),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      obscureText: false,
                    ),
                  ),
                ],
              ),
              inputContainer(_nameController, '이름'),
              inputContainer(
                _recommendCallController,
                '추천인 전화번호(선택)',
              ),
              inputContainer(
                _destinationController,
                '주 목적지(선택)',
              ),
              inputContainer(
                _storeController,
                '가맹점 이름(선택)',
              ),
              inputContainer(
                _storeCallController,
                '가맹점 전화번호(선택)',
              ),
              inputContainer(
                _storeAddressController,
                '가맹점 주소(선택)',
              ),
              const SizedBox(height: 10.0),
              ElevatedButton(
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(80, 50)),
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromRGBO(249, 224, 0, 1.0)),
                ),
                onPressed: () {
                  if (_nameController.text.isEmpty) {
                    showSnackBar('이름을 입력해주세요.');
                    return;
                  }
                  editUser();
                  ();
                },
                child: const Text('수정', style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget passwordInput(TextEditingController passwordController, String label) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: TextField(
        controller: passwordController,
        keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: label,
        ),
        obscureText: true,
      ),
    );
  }

  Widget inputContainer(
      TextEditingController textController, String labelText) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: TextField(
        controller: textController,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: labelText,
        ),
        obscureText: false,
      ),
    );
  }

  void editUser() async {
    UserService().editUser({
      'call': widget.user.call,
      'password': widget.user.password,
      'name': _nameController.text,
      'destination': _destinationController.text == ''
          ? null
          : _destinationController.text,
      'store': _storeController.text == '' ? null : _storeController.text,
      'recommendCall': _recommendCallController.text == ''
          ? null
          : _recommendCallController.text,
      'storeCall':
          _storeCallController.text == '' ? null : _storeCallController.text,
      'storeAddress': _storeAddressController.text == ''
          ? null
          : _storeAddressController.text,
    }).then((value) {
      showSnackBar('회원정보 수정에 성공했습니다.');
      Navigator.pop(context);
    }).onError((error, stackTrace) {
      showSnackBar('회원정보 수정에 실패했습니다.');
    });
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
