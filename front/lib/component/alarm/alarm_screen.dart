import 'package:flutter/material.dart';
import 'package:front/api/alarm/get_alarms.dart';
import 'package:front/api/alarm/patch_alarms.dart';
import 'package:front/component/alarm/alarm.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({
    Key? key,
    required this.userId,
    this.signal,
  }) : super(key: key);
  final int userId;
  final String? signal;

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  int _currentPage = 0;
  bool _hasNextPage = false;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;
  List _alarms = [];
  String signal = '';

  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    printAlarms();
    _controller.addListener(_loadMoreData);
    signal = widget.signal!;
  }

  @override
  void didUpdateWidget(covariant AlarmScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.signal != widget.signal) {
      setState(() {
        signal = widget.signal!;
      });
      handleSignal(signal);
    }
  }

  void handleSignal(String signal) {
    if (signal == '1') {
      printAlarms();
      signal = '';
    }
  }

  void cheAlarms() async {
    await checkAlarms();

    setState(() {});
  }

  void onDelete(int notificationId) async {
    setState(() {});
  }

  void printAlarms() async {
    setState(() {
      _isFirstLoadRunning = true;
    });
    _currentPage = 0;
    _alarms.clear();
    final alarmData = await getAlarms(
      userId: widget.userId,
      page: _currentPage,
    );
    _alarms.addAll(alarmData.notifications);
    _hasNextPage = alarmData.nextPage;

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  void _loadMoreData() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 500)
      setState(() {
        _isLoadMoreRunning = true;
      });
    _currentPage += 1;
    final newAlarms = await getAlarms(
      userId: widget.userId,
      page: _currentPage,
    );
    _alarms.addAll(newAlarms.notifications);
    _hasNextPage = newAlarms.nextPage;

    setState(() {
      // print('성공');
      _isLoadMoreRunning = false;
    });
  }

  void _updateIsChildActive(bool isChildActive) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "알람",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,

          /// 앱바 그림자효과 제거
          leading: IconButton(
            /// 뒤로가기버튼설정
            icon: Icon(Icons.arrow_back_ios_new_outlined),
            color: Colors.black,
            onPressed: () {
              // Get.find<BottomNavController>().willPopAction();
              Navigator.of(context).pop();
            },
          ),
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 10,
              ),
              child: ElevatedButton(
                onPressed: () {
                  cheAlarms();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                ),
                child: Text('모든 알림 체크'),
              ),
            )
          ],
        ),
        body: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(
                child: RefreshIndicator(
                  onRefresh: () async {
                    printAlarms();
                  },
                  child: ListView(
                    controller: _controller,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: List.generate(
                          _alarms.length,
                          (index) => AlarmComponent(
                            userId: widget.userId,
                            onDelete: onDelete,
                            notificationId: _alarms[index].notificationId,
                            height: 100,
                            onUpdateIsChildActive: _updateIsChildActive,
                          ),
                        ),
                      ),
                      if (_isLoadMoreRunning)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      if (!_isLoadMoreRunning && !_hasNextPage)
                        Container(
                          padding: const EdgeInsets.only(bottom: 10),
                          color: Colors.white,
                          height: 100,
                          child: const Center(
                            child: Text('더이상 알림이 없습니다'),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
