import 'package:flutter/material.dart';

class Option extends StatelessWidget {
  final Icon icon;
  final Text title;
  const Option({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            icon,
            const SizedBox(
              width: 20,
            ),
            title
          ],
        ),
      ),
    );
  }
}
