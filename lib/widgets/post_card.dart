import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../model/user.dart';
import '../providers/user_provider.dart';
import '../screens/comments_screen.dart';
import '../resources/firestore_methods.dart';
import '../utils/utils.dart';
import '../widgets/like_animation.dart';
import '../utils/colors.dart';

class PostCard extends StatefulWidget {
  final snap;

  const PostCard({super.key, required this.snap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  _confirmDelete() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            shape:
                BeveledRectangleBorder(borderRadius: BorderRadius.circular(8)),
            alignment: Alignment.center,
            title: const Text(
              'Are you sure?',
              textAlign: TextAlign.center,
            ),
            children: <Widget>[
              SimpleDialogOption(
                  padding: const EdgeInsets.all(20),
                  child: const Text(
                    'Yes',
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () async {
                    FirestoreMethods().deletePost(widget.snap['postId']);
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  }),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text(
                  'No',
                  textAlign: TextAlign.center,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  bool isLikeAnimating = false;
  int commentLength = 0;
  @override
  void initState() {
    super.initState();
    getComments();
  }

  void getComments() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();

      setState(() {
        commentLength = snap.docs.length;
      });
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() {});
  }

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
                      builder: (context) => Padding(
                        padding: const EdgeInsets.all(4),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              borderRadius: BorderRadius.circular(8),
                              // onTap: () async {
                              //   // FirestoreMethods()
                              //   //     .deletePost(widget.snap['postId']);
                              //   // Navigator.of(context).pop();
                              // },
                              onTap: _confirmDelete,
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(children: [
                                  Icon(
                                    Icons.delete_outline_outlined,
                                    color: Colors.red,
                                    size: 32,
                                  ),
                                  Text(
                                    ' Delete',
                                    style: TextStyle(
                                        fontSize: 22, color: Colors.red),
                                  ),
                                ]),
                              ),
                            ),
                            InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onTap: () {},
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(children: [
                                  Icon(
                                    Icons.history_rounded,
                                    size: 28,
                                  ),
                                  Text(
                                    '  Archive',
                                    style: TextStyle(fontSize: 19),
                                  )
                                ]),
                              ),
                            ),
                            InkWell(
                              onTap: () {},
                              borderRadius: BorderRadius.circular(8),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(children: [
                                  Icon(
                                    Icons.account_circle_outlined,
                                    size: 27,
                                  ),
                                  Text(
                                    '  About this account',
                                    style: TextStyle(fontSize: 20),
                                  )
                                ]),
                              ),
                            ),
                            InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onTap: () {},
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(children: [
                                  Icon(
                                    Icons.report,
                                    color: Colors.red,
                                    size: 28,
                                  ),
                                  Text(
                                    '  Report',
                                    style: TextStyle(
                                        fontSize: 21, color: Colors.red),
                                  )
                                ]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
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
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CommentScreen(
                    snap: widget.snap,
                  ),
                ),
              ),
              //comment icon
              icon: Image.network(
                'https://firebasestorage.googleapis.com/v0/b/instagram-c0882.appspot.com/o/dummydp%2Fcomment.png?alt=media&token=0e0de507-3fb0-41d9-ba20-d247ee770271',
                color: Colors.white,
                height: 30,
              ),
            ),
            IconButton(
              onPressed: () {},
              //share icon
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
                  child: Text(
                    'View all $commentLength comments',
                    style: const TextStyle(fontSize: 16, color: secondaryColor),
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
