import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:social_app/layout/social_app/cubit/cubit.dart';
import 'package:social_app/layout/social_app/cubit/state.dart';
import 'package:social_app/models/social_app/comment_model.dart';
import 'package:social_app/models/social_app/post_model.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class CommentsScreen extends StatelessWidget {

  final String postId;
  final String receiverUid;

  CommentsScreen(this.postId, this.receiverUid);

  var commentController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  void clearController()
  {
    commentController.clear();
  }

  @override
  Widget build(BuildContext context) {

    return Builder(
        builder: (BuildContext context) {
          SocialCubit.get(context).getCommentData(
              postId: postId,
          );

          return BlocConsumer<SocialCubit,SocialState>(
            listener: (context,state){},
            builder: (context,state){

              SocialCubit cubit = SocialCubit.get(context);

              return Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      IconBroken.Arrow___Left_2,
                    ),
                  ),
                  centerTitle: true,
                  elevation: 0,
                  backgroundColor: Colors.indigo,
                  title: Text(
                    'Comments',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 25,
                    ),
                  ),
                ),
                body: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .doc(postId)
                      .collection('comments')
                      .orderBy('dateTime', descending: true)
                      .snapshots(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      cubit.commentList = [];
                      snapshot.data.docs.forEach((element) {
                        cubit.commentList.add(CommentModel.fromJson(element.data()));
                      });
                      return Conditional.single(
                          context: context,
                          conditionBuilder: (BuildContext context) =>
                          snapshot.hasData == true &&
                              cubit.commentList.length > 0 == true,
                          widgetBuilder: (BuildContext context) => Column(
                            children:
                            [
                              Expanded(
                                child: ListView.separated(
                                  physics: BouncingScrollPhysics(),
                                  reverse: false,
                                  itemBuilder: (context, index) {
                                    return buildComment(cubit.commentList[index],context,index);
                                  },
                                  separatorBuilder: (context, index) => SizedBox(
                                    height: 0,
                                  ),
                                  itemCount: cubit.commentList.length,
                                ),
                              ),
                              Container(
                                color: GREEN.withOpacity(0.3),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10,
                                      right: 10,
                                      bottom: 5
                                  ),
                                  child: Form(
                                    key: formKey,
                                    child: Row(
                                      children: [
                                        IconButton(
                                          icon: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 0,
                                                right: 7
                                            ),
                                            child: Transform.rotate(
                                                angle: 0,
                                                child: CircleAvatar(
                                                    radius: 20,
                                                    backgroundColor:
                                                    GREEN.withOpacity(0.1),
                                                    child: Icon(
                                                      IconBroken.Image,
                                                      size: 20,
                                                    ))),
                                          ),
                                          onPressed: () {
                                            print('add image');
                                          },
                                        ),
                                        Expanded(
                                          child: TextFormField(
                                            autofocus: false,
                                            keyboardType: TextInputType.text,
                                            enableInteractiveSelection: true,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                            ),
                                            enableSuggestions: true,
                                            scrollPhysics:
                                            BouncingScrollPhysics(),
                                            decoration: InputDecoration(
                                              icon: SizedBox(
                                                width: 5,
                                              ),
                                              focusedBorder: InputBorder.none,
                                              disabledBorder: InputBorder.none,
                                              border: InputBorder.none,
                                              fillColor: Colors.grey,
                                              hintText: 'comment..',
                                            ),
                                            autocorrect: true,
                                            controller: commentController,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'The comment can\'t be empty';
                                              }
                                              return null;
                                            },
                                            onFieldSubmitted: (value) {},
                                          ),
                                        ),
                                        IconButton(
                                          icon: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 0,
                                                right: 7
                                            ),
                                            child: Transform.rotate(
                                                angle: 2400,
                                                child: CircleAvatar(
                                                    radius: 20,
                                                    backgroundColor:
                                                    GREEN.withOpacity(0.1),
                                                    child: Icon(
                                                      IconBroken.Send,
                                                      size: 20,
                                                    ))),
                                          ),
                                          onPressed: () {
                                            if (formKey.currentState!.validate() == true) {
                                              print('comment');
                                              SocialCubit.get(context).sendComment(
                                                dateTime: DateTime.now().toString(),
                                                text: commentController.text,
                                                postId: postId,
                                              );
                                            }
                                            clearController();
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          fallbackBuilder: (BuildContext context) => Column(
                            children: [
                              Expanded(
                                  child: Container(
                                    child: Center(
                                        child: Text(
                                            'No comments yet,\nPut your comment')
                                    ),
                                  )
                              ),
                              Container(
                                color: GREEN.withOpacity(0.3),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10,
                                      right: 10,
                                      bottom: 5
                                  ),
                                  child: Form(
                                    key: formKey,
                                    child: Row(
                                      children: [
                                        IconButton(
                                          icon: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 0,
                                                right: 7
                                            ),
                                            child: Transform.rotate(
                                                angle: 0,
                                                child: CircleAvatar(
                                                    radius: 20,
                                                    backgroundColor:
                                                    GREEN.withOpacity(0.1),
                                                    child: Icon(
                                                      IconBroken.Image,
                                                      size: 20,
                                                    ))),
                                          ),
                                          onPressed: () {
                                            print('add image');
                                          },
                                        ),
                                        Expanded(
                                          child: TextFormField(
                                            autofocus: false,
                                            keyboardType: TextInputType.text,
                                            enableInteractiveSelection: true,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                            ),
                                            enableSuggestions: true,
                                            scrollPhysics:
                                            BouncingScrollPhysics(),
                                            decoration: InputDecoration(
                                              icon: SizedBox(
                                                width: 5,
                                              ),
                                              focusedBorder: InputBorder.none,
                                              disabledBorder: InputBorder.none,
                                              border: InputBorder.none,
                                              fillColor: Colors.grey,
                                              hintText: 'comment..',
                                            ),
                                            autocorrect: true,
                                            controller: commentController,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'The comment can\'t be empty';
                                              }
                                              return null;
                                            },
                                            onFieldSubmitted: (value) {},
                                          ),
                                        ),
                                        IconButton(
                                          icon: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 0, right: 7),
                                            child: Transform.rotate(
                                                angle: 2400,
                                                child: CircleAvatar(
                                                    radius: 20,
                                                    backgroundColor:
                                                    GREEN.withOpacity(0.1),
                                                    child: Icon(
                                                      IconBroken.Send,
                                                      size: 20,
                                                    ))),
                                          ),
                                          onPressed: () {
                                            if (formKey.currentState!.validate() == true) {
                                              print('comment');
                                              SocialCubit.get(context).sendComment(
                                                dateTime: DateTime.now().toString(),
                                                text: commentController.text,
                                                postId: postId,
                                              );
                                            }
                                            clearController();
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ));
                    }
                  },
                ),
              );
            },
          );
        },
    );
  }

  Widget buildComment(CommentModel comment,context,index) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 8,
            ),
            child: CircleAvatar(
              radius: 15,
              backgroundImage: NetworkImage(
                '${comment.profileImage}',
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  color: Colors.grey.withOpacity(0.2)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${comment.commenterName}',
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 17,
                          color: BROWN,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                    Text(
                      '${comment.text}',
                      style: TextStyle(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          PopupMenuButton(
            icon: Icon(
              Icons.more_horiz,
              size: 16.0,
            ),
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              const PopupMenuItem(
                value: 'delete',
                child: ListTile(
                  leading: Icon(Icons.delete_outline),
                  title: Text('Delete'),
                ),
              ),
              const PopupMenuItem(
                value: 'reply',
                child: ListTile(
                  leading: Icon(Icons.replay_5_outlined),
                  title: Text('Reply'),
                ),
              ),
              const PopupMenuItem(
                value: 'copy',
                child: ListTile(
                  leading: Icon(Icons.copy_outlined),
                  title: Text('Copy'),
                ),
              ),
              const PopupMenuItem(
                value: 'cut',
                child: ListTile(
                  leading: Icon(Icons.cut_outlined),
                  title: Text('Cut'),
                ),
              ),
            ],
            onSelected: (choice){
              switch(choice){
                case 'delete':
                  SocialCubit.get(context).deleteComment(postId,SocialCubit.get(context).commentsId[index]);
                  break;
              }
            },
          ),
        ],
      ),
    );
  }
}
