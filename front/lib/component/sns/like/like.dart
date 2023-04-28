import 'package:flutter/material.dart';

class LikeComponent extends StatelessWidget {
  final String writer;
  final String writerProfile;
  final double height;
  final Function(bool isChildActive) onUpdateIsChildActive;

  const LikeComponent({
    Key? key,
    required this.writer,
    required this.writerProfile,
    required this.height,
    required this.onUpdateIsChildActive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(writerProfile),
            radius: 20,
          ),
          SizedBox(width: 16),
          Text(
            writer,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
