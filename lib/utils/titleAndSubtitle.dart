// ignore_for_file: file_names

import 'package:flutter/material.dart';

class TitleAndSubtitleWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  const TitleAndSubtitleWidget(
      {Key? key, required this.title, required this.subtitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          textScaleFactor: 2.3,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 6,
        ),
        Text(subtitle,
        textScaleFactor: 1.1,
         style: const TextStyle(
          color: Colors.grey
        ),),
      ],
    );
  }
}
