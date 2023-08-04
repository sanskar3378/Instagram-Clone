import 'package:flutter/material.dart';
import 'package:instagram/model/user.dart';
import 'package:instagram/providers/user_provider.dart';
import 'package:instagram/resources/firestore_methods.dart';
import 'package:instagram/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../utils/colors.dart';
import '../widgets/options.dart';

class PostCard extends StatefulWidget {
  final snap;

  const PostCard({super.key, required this.snap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    return Container(
      color: mobileBackgroundColor,
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Column(children: [
        //Header section
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
              .copyWith(right: 0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(widget.snap['profImage']),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.snap['username'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                        showDragHandle: true,
                        backgroundColor: const Color.fromARGB(255, 30, 30, 30),
                        // backgroundColor: mobileBackgroundColor,
                        shape: const BeveledRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8))),
                        context: context,
                        builder: (context) => const Padding(
                              padding: EdgeInsets.all(4),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Option(
                                      icon: Icon(
                                        Icons.delete_outline_outlined,
                                        color: Colors.red,
                                        size: 32,
                                      ),
                                      title: Text(
                                        'Delete',
                                        style: TextStyle(
                                            fontSize: 22, color: Colors.red),
                                      )),
                                  Option(
                                      icon: Icon(
                                        Icons.history_rounded,
                                        size: 28,
                                      ),
                                      title: Text(
                                        'Archive',
                                        style: TextStyle(fontSize: 19),
                                      )),
                                  Option(
                                      icon: Icon(
                                        Icons.account_circle_outlined,
                                        size: 27,
                                      ),
                                      title: Text(
                                        'About this account',
                                        style: TextStyle(fontSize: 20),
                                      )),
                                  Option(
                                      icon: Icon(
                                        Icons.report,
                                        color: Colors.red,
                                        size: 28,
                                      ),
                                      title: Text(
                                        'Report',
                                        style: TextStyle(
                                            fontSize: 21, color: Colors.red),
                                      ))
                                ],
                              ),
                            ));
                  },
                  icon: const Icon(Icons.more_vert_rounded))
            ],
          ),
        ),
        //Image section
        GestureDetector(
          onDoubleTap: () async {
            await FirestoreMethods().likePost2(
                widget.snap['postId'], user.uid, widget.snap['likes']);
            setState(() {
              isLikeAnimating = true;
            });
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                width: double.infinity,
                child: Image.network(
                  widget.snap['postUrl'],
                  fit: BoxFit.cover,
                ),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isLikeAnimating ? 1 : 0,
                child: LikeAnimation(
                  duration: const Duration(milliseconds: 400),
                  isAnimating: isLikeAnimating,
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 120,
                  ),
                  onEnd: () {
                    setState(() {
                      isLikeAnimating = false;
                    });
                  },
                ),
              )
            ],
          ),
        ),

        // like - comment section
        Row(
          children: [
            LikeAnimation(
              isAnimating: widget.snap['likes'].contains(user.uid),
              smallLike: true,
              child: IconButton(
                  onPressed: () async {
                    await FirestoreMethods().likePost(
                        widget.snap['postId'], user.uid, widget.snap['likes']);
                  },
                  icon: Icon(
                    widget.snap['likes'].contains(user.uid)
                        ? Icons.favorite
                        : Icons.favorite_outline_outlined,
                    color: widget.snap['likes'].contains(user.uid)
                        ? Colors.red
                        : Colors.white,
                    size: 27,
                  )),
            ),
            IconButton(
              onPressed: () {},
              icon: Image.network(
                'https://firebasestorage.googleapis.com/v0/b/instagram-c0882.appspot.com/o/dummydp%2Fcomment.png?alt=media&token=0e0de507-3fb0-41d9-ba20-d247ee770271',
                color: Colors.white,
                height: 30,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Image.network(
                'https://firebasestorage.googleapis.com/v0/b/instagram-c0882.appspot.com/o/dummydp%2Fsend.png?alt=media&token=ed1163ef-2e4a-48a3-9b81-39d5151a1874',
                color: primaryColor,
                height: 21,
              ),
            ),
            Expanded(
                child: Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.bookmark_border_rounded,
                    size: 30,
                  )),
            ))
          ],
        ),
        //Description ans comments
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DefaultTextStyle(
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                  child: Text(
                    '${widget.snap['likes'].length} likes',
                    style: Theme.of(context).textTheme.bodyLarge,
                  )),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 8),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      color: primaryColor,
                    ),
                    children: [
                      TextSpan(
                        text: '${widget.snap['username']} ',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: widget.snap['description'],
                      )
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: const Text(
                    'View all 300 comments',
                    style: TextStyle(fontSize: 16, color: secondaryColor),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  DateFormat.yMMMd()
                      .format(widget.snap['datePublished'].toDate()),
                  style: const TextStyle(
                    fontSize: 12,
                    color: secondaryColor,
                  ),
                ),
              ),
            ],
          ),
        )
      ]),
    );
  }
}
