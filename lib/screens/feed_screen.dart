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
            //messenger icon
            icon: Image.network(
              'https://firebasestorage.googleapis.com/v0/b/instagram-c0882.appspot.com/o/dummydp%2Fmessenger.png?alt=media&token=dc98640c-b6aa-4a6f-a3e0-047466fdfb58',
              color: primaryColor,
              height: 30,
            ),
          )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              //skeleton loading screen
              child: Lottie.network(
                'https://firebasestorage.googleapis.com/v0/b/instagram-c0882.appspot.com/o/animations%2Fskeleton_loading.json?alt=media&token=17315d73-193b-41f0-a784-3d4ebde65bfd',
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
