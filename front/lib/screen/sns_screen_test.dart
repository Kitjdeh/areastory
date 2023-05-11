// import 'package:flutter/material.dart';
// import 'package:front/api/sns/get_articles.dart';
// import 'package:front/component/sns/article/article.dart';
// import 'package:front/const/auto_search_test.dart';
//
// const List<String> list = <String>['인기순', '최신순'];
//
// class SnsScreen extends StatefulWidget {
//   const SnsScreen({Key? key, required this.userId}) : super(key: key);
//   final String userId;
//
//   @override
//   State<SnsScreen> createState() => _SnsScreenState();
// }
//
// class _SnsScreenState extends State<SnsScreen> {
//   int _currentPage = 1;
//   int? _lastPage = 0;
//   List _articles = [];
//   String dropdownValue = list.first;
//   String seletedLocationDosi = '';
//   String seletedLocationSigungu = '';
//   String seletedLocationDongeupmyeon = '';
//
//   late final userId = int.parse(widget.userId);
//
//   @override
//   void initState() {
//     super.initState();
//     printArticles();
//   }
//
//   void printArticles() async {
//     _currentPage = 1;
//     _articles.clear();
//     final articleData = await getArticles(
//       sort: dropdownValue == '인기순' ? 'likeCount' : 'articleId',
//       page: _currentPage,
//       dosi: seletedLocationDosi,
//       sigungu: seletedLocationSigungu,
//       dongeupmyeon: seletedLocationDongeupmyeon,
//     );
//     _articles.addAll(articleData.articles);
//     _lastPage = articleData.totalPageNumber;
//     setState(() {});
//   }
//
//   void _loadMoreData() async {
//     _currentPage++;
//     final newArticles = await getArticles(
//       sort: dropdownValue == '인기순' ? 'likeCount' : 'articleId',
//       page: _currentPage,
//       dosi: seletedLocationDosi,
//       sigungu: seletedLocationSigungu,
//       dongeupmyeon: seletedLocationDongeupmyeon,
//     );
//     _articles.addAll(newArticles.articles);
//     _lastPage = newArticles.totalPageNumber;
//
//     setState(() {
//       // scrollToIndex(5);
//     });
//   }
//
//   final ScrollController _scrollController = ScrollController();
//
//   void scrollToIndex(int index) {
//     _scrollController.jumpTo(index * 520); // jumpTo 메서드를 사용하여 스크롤합니다.
//   }
//
//   void onDelete(int articleId) {
//     setState(() {});
//   }
//
//   void _updateIsChildActive(followingId) async {}
//
//   void handleLocationSelected(String selectedLocation) {
//     List<String> locationParts = selectedLocation.split(' ');
//     print(locationParts);
//
//     if (locationParts.length == 3) {
//       seletedLocationDosi = locationParts[0];
//       seletedLocationSigungu = locationParts[1];
//       seletedLocationDongeupmyeon = locationParts[2];
//     } else {
//       seletedLocationDosi = locationParts[0];
//       seletedLocationSigungu = locationParts[1] + ' ' + locationParts[2];
//       seletedLocationDongeupmyeon = locationParts[3];
//     }
//
//     print(seletedLocationDosi);
//     print(seletedLocationSigungu);
//     print(seletedLocationDongeupmyeon);
//
//     setState(() {
//       printArticles();
//     });
//   }
//
//   void onChangeSort(String dropdownValue) {
//     setState(() {
//       printArticles();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(30.0),
//         child: AppBar(
//           backgroundColor: Colors.white,
//           elevation: 0,
//           title: Image.asset(
//             'asset/img/logo.png',
//             height: 120,
//             width: 120,
//           ),
//           actions: [
//             LocationSearch(
//               onLocationSelected: handleLocationSelected,
//             ),
//             DropdownButton<String>(
//               value: dropdownValue,
//               style: const TextStyle(color: Colors.black),
//               underline: null,
//               autofocus: true,
//               dropdownColor: Colors.white,
//               borderRadius: BorderRadius.all(Radius.circular(15)),
//               onChanged: (String? value) {
//                 dropdownValue = value!;
//                 onChangeSort(value!);
//               },
//               items: list.map<DropdownMenuItem<String>>((String value) {
//                 return DropdownMenuItem<String>(
//                   value: value,
//                   child: Text(value),
//                 );
//               }).toList(),
//             )
//           ],
//         ),
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             SizedBox(
//               height: 10,
//             ),
//             Expanded(
//               child: Container(
//                 child: RefreshIndicator(
//                   onRefresh: () async {
//                     printArticles();
//                   },
//                   child: ListView.separated(
//                     controller: _scrollController,
//                     itemCount: _articles.length + 1,
//                     itemBuilder: (BuildContext context, int index) {
//                       if (index < _articles.length) {
//                         return ArticleComponent(
//                           userId: userId,
//                           onDelete: onDelete,
//                           articleId: _articles[index].articleId,
//                           followingId: _articles[index].userId,
//                           height: 350,
//                           onUpdateIsChildActive: _updateIsChildActive,
//                         );
//                       } else if (_currentPage < _lastPage!) {
//                         _loadMoreData();
//                         return Container(
//                           height: 50,
//                           alignment: Alignment.center,
//                           child: const CircularProgressIndicator(),
//                         );
//                       }
//                     },
//                     separatorBuilder: (context, index) {
//                       return renderContainer(height: 20);
//                     },
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget renderContainer({
//     double? height,
//   }) {
//     return Container(
//       height: height,
//     );
//   }
// }
