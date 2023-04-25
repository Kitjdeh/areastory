import 'package:flutter/material.dart';
import 'package:front/component/article.dart';
import 'package:front/const/article_test.dart';
import 'package:front/const/colors.dart';

class SnsScreen extends StatefulWidget {
  const SnsScreen({Key? key}) : super(key: key);

  @override
  State<SnsScreen> createState() => _SnsScreenState();
}

class _SnsScreenState extends State<SnsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFECF9FF),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'asset/img/logo.png',
                  height: 50,
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: PopupMenuButton(
                    itemBuilder: (BuildContext context) {
                      return [
                        PopupMenuItem(
                          child: Text('Option 1'),
                          value: 1,
                        ),
                        PopupMenuItem(
                          child: Text('Option 2'),
                          value: 2,
                        ),
                        PopupMenuItem(
                          child: Text('Option 3'),
                          value: 3,
                        ),
                      ];
                    },
                    onSelected: (value) {
                      // Do something when an option is selected
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(
                child: RefreshIndicator(
                  onRefresh: () async {
                    // 서버 요청
                    await Future.delayed(Duration(seconds: 3));
                  },
                  child: ListView.separated(
                    itemCount: 2,
                    itemBuilder: (BuildContext context, int index) {
                      return ArticleComponent(
                        nickname: articleTest["articles"][index]["nickname"],
                        image: articleTest["articles"][index]["image"],
                        profile: articleTest["articles"][index]["profile"],
                        content: articleTest["articles"][index]["content"],
                        likeCount: articleTest["articles"][index]["likeCount"],
                        commentCount: articleTest["articles"][index]
                            ["commentCount"],
                        isLike: articleTest["articles"][index]["isLike"],
                        height: 500,
                      );
                    },
                    separatorBuilder: (context, index) {
                      return renderContainer(height: 20);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget renderContainer({
    double? height,
  }) {
    return Container(
      height: height,
    );
  }
}
