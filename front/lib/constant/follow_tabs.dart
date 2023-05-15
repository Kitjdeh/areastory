import 'package:flutter/material.dart';

class TabInfo {
  // 라벨(string)이 따로 표시되는게 없다.
  // 현재 임시로 자체 Icons에 있는걸 사용하지만, 추후 svg로 다운받아서 asset폴더에서 가져와야한다.
  final IconData icon;
  final String label;

  // 아마 새로운 게시글 생성하는것 관련은 공부를 해야한다.
  const TabInfo({required this.icon, required this.label});
}

const FOLLOWTABS = [
  TabInfo(icon: Icons.book_outlined, label: '팔로워'),
  TabInfo(icon: Icons.map_outlined, label: '팔로잉'),
];
