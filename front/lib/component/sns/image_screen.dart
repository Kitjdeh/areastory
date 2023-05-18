import 'package:flutter/material.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({Key? key, required this.image}) : super(key: key);
  final String image;

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: InteractiveViewer(
        child: Image.network(widget.image),
      ),
    );
  }
}
