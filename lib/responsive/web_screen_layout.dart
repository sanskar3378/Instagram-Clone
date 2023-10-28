import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/colors.dart';

class WebScreenLayout extends StatelessWidget {
  const WebScreenLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: SvgPicture.asset(
          'assets/instagram_logo.svg',
          // ignore: deprecated_member_use
          color: primaryColor,
          height: 45,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            //messenger icon
            icon: const Icon(
              Icons.home,
              color: primaryColor,
            ),
          ),
          IconButton(
              onPressed: () {},
              //messenger icon
              icon: const Icon(Icons.search)),
          IconButton(
              onPressed: () {},
              //messenger icon
              icon: const Icon(Icons.add_a_photo)),
          IconButton(
              onPressed: () {},
              //messenger icon
              icon: const Icon(Icons.favorite_outline_outlined)),
          IconButton(
            onPressed: () {},
            //messenger icon
            icon: Image.network(
              'https://firebasestorage.googleapis.com/v0/b/instagram-c0882.appspot.com/o/dummydp%2Fmessenger.png?alt=media&token=dc98640c-b6aa-4a6f-a3e0-047466fdfb58',
              color: primaryColor,
              height: 30,
            ),
          ),
        ],
      ),
      body: const Center(child: Text('This is Web layout')),
    );
  }
}
