import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/utils/colors.dart';
import 'package:lottie/lottie.dart';
import '../widgets/post_card.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

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
            icon: Image.network(
              'https://firebasestorage.googleapis.com/v0/b/instagram-c0882.appspot.com/o/dummydp%2Fmessenger.png?alt=media&token=dc98640c-b6aa-4a6f-a3e0-047466fdfb58',
              color: primaryColor,
              height: 30,
            ),
          )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Lottie.network(
                'https://firebasestorage.googleapis.com/v0/b/instagram-c0882.appspot.com/o/animations%2Floading.json?alt=media&token=3c78f8c6-938b-46db-b98e-d8999e6e3b00',
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) => PostCard(
              snap: snapshot.data!.docs[index].data(),
            ),
          );
        },
      ),
    );
  }
}
