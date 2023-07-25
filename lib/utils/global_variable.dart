import 'package:flutter/material.dart';

import '../screens/add_post_screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  const Center(child: Text('feed')),
  const Center(child: Text('search')),
  AddPostScreen(),
  const Center(child: Text('notifications')),
  const Center(child: Text('profile'))
];
