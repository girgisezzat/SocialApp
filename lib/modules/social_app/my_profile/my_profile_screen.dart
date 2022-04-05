import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:social_app/layout/social_app/cubit/cubit.dart';
import 'package:social_app/layout/social_app/cubit/state.dart';
import 'package:social_app/models/social_app/post_model.dart';
import 'package:social_app/modules/social_app/comments/comments_screen.dart';
import 'package:social_app/modules/social_app/edit_profile/edit_profile_screen.dart';
import 'package:social_app/modules/social_app/new_post/new_post_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class MyProfileScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit,SocialState>(
      listener:(context,state){},
      builder: (context,state){

        SocialCubit cubit = SocialCubit.get(context);
        var userModel = SocialCubit.get(context).userModel;

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Conditional.single(
            context: context,
            conditionBuilder:(context)=> SocialCubit.get(context).myPosts.length > 0
                && SocialCubit.get(context).userModel !=null,
            widgetBuilder:(context)=> SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children:
                [
                  Container(
                    height: 190.0,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children:
                      [
                        Align(
                          child: Container(
                            height: 140.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(4.0),
                                topRight: Radius.circular(4.0),
                              ),
                              image: DecorationImage(
                                image: NetworkImage(
                                  '${userModel!.cover}',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          alignment: AlignmentDirectional.topCenter,
                        ),
                        CircleAvatar(
                          radius: 64.0,
                          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                          child: CircleAvatar(
                            radius: 60.0,
                            backgroundImage: NetworkImage(
                              '${userModel.image}',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    '${userModel.name}',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  Text(
                    '${userModel.bio}',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                    ),
                    child: Row(
                      children:
                      [
                        Expanded(
                          child: InkWell(
                            child: Column(
                              children:
                              [
                                Text(
                                  '${cubit.myPosts.length}',
                                  style: Theme.of(context).textTheme.subtitle2,
                                ),
                                Text(
                                  'Posts',
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ],
                            ),
                            onTap: (){},
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            child: Column(
                              children: [
                                Text(
                                  '${cubit.myImages.length}',
                                  style: Theme.of(context).textTheme.subtitle2,
                                ),
                                Text(
                                  'Photos',
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ],
                            ),
                            onTap: () {},
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            child: Column(
                              children: [
                                Text(
                                  '${cubit.usersList.length}',
                                  style: Theme.of(context).textTheme.subtitle2,
                                ),
                                Text(
                                  'Friends',
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ],
                            ),
                            onTap: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children:
                    [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: (){
                            navigateTo(context,NewPostScreen());
                          },
                          child: Text(
                            'Add Photos',
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      OutlinedButton(
                        onPressed: (){
                          navigateTo(
                            context,
                            EditProfileScreen(),
                          );
                        },
                        child: Icon(
                          Icons.edit,
                          size: 16.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) =>
                        buildMyPostItem(SocialCubit.get(context).myPosts[index],context,index),
                    separatorBuilder:(context, index) => SizedBox(height: 8.0,),
                    itemCount: SocialCubit.get(context).myPosts.length,
                  ),
                ],
              ),
            ),
            fallbackBuilder:(context)=> Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }

  Widget buildMyPostItem(PostModel model,context,index) => Card(
    clipBehavior: Clip.antiAliasWithSaveLayer,
    elevation: 5.0,
    margin: EdgeInsets.symmetric(
      horizontal: 8.0,
    ),
    child: Padding(
      padding: const EdgeInsets.all(
          10.0
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25.0,
                backgroundImage: NetworkImage(
                  '${model.image}',
                ),
              ),
              SizedBox(
                width: 15.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${model.name}',
                          style: TextStyle(
                            height: 1.4,
                          ),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Icon(
                          Icons.check_circle,
                          color: Colors.blue,
                          size: 16.0,
                        ),
                      ],
                    ),
                    Text(
                      '${model.dateTime}',
                      style: Theme.of(context).textTheme.caption!.copyWith(
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 15.0,
              ),

              // IconButton(
              //   icon: Icon(
              //     Icons.more_horiz,
              //     size: 16.0,
              //   ),
              //   onPressed: () {
              //     Row(
              //       children: [
              //         IconButton(
              //           icon: Icon(
              //             Icons.delete_outline,
              //             size: 16.0,
              //           ),
              //           onPressed: (){},
              //         ),
              //         SizedBox(
              //           width: 5.0,
              //         ),
              //         Text(
              //           'Delete Post'
              //         ),
              //       ],
              //     );
              //     Row(
              //       children: [
              //         IconButton(
              //           icon: Icon(
              //             Icons.save_alt_rounded,
              //             size: 16.0,
              //           ),
              //           onPressed: (){},
              //         ),
              //         SizedBox(
              //           width: 5.0,
              //         ),
              //         Text(
              //             'Save Post'
              //         ),
              //       ],
              //     );
              //     Row(
              //       children: [
              //         IconButton(
              //           icon: Icon(
              //             Icons.share,
              //             size: 16.0,
              //           ),
              //           onPressed: (){},
              //         ),
              //         SizedBox(
              //           width: 5.0,
              //         ),
              //         Text(
              //             'Share Post'
              //         ),
              //       ],
              //     );
              //     Row(
              //       children: [
              //         IconButton(
              //           icon: Icon(
              //             Icons.cancel_outlined,
              //             size: 16.0,
              //           ),
              //           onPressed: (){},
              //         ),
              //         SizedBox(
              //           width: 5.0,
              //         ),
              //         Text(
              //             'Cancel'
              //         ),
              //       ],
              //     );
              //   },
              // ),

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
                    value: 'save',
                    child: ListTile(
                      leading: Icon(Icons.save_alt_rounded),
                      title: Text('Save'),
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'share',
                    child: ListTile(
                      leading: Icon(Icons.share),
                      title: Text('Share'),
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'cancel',
                    child: ListTile(
                      leading: Icon(Icons.cancel),
                      title: Text('Cancel'),
                    ),
                  ),
                ],
                onSelected: (choice){
                  switch(choice){
                    case 'delete':
                      SocialCubit.get(context).deletePost(SocialCubit.get(context).myPostsId[index]);
                      break;
                  }
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 15.0,
            ),
            child: Container(
              width: double.infinity,
              height: 1.0,
              color: Colors.grey[300],
            ),
          ),
          Text(
            '${model.text}',
            style: Theme.of(context).textTheme.subtitle1,
          ),

          // Padding(
          //   padding: const EdgeInsets.only(
          //     bottom: 10.0,
          //     top: 5.0,
          //   ),
          //   child: Container(
          //     width: double.infinity,
          //     child: Wrap(
          //       children: [
          //         Padding(
          //           padding: const EdgeInsetsDirectional.only(
          //             end: 6.0,
          //           ),
          //           child: Container(
          //             height: 25.0,
          //             child: MaterialButton(
          //               onPressed: () {},
          //               minWidth: 1.0,
          //               padding: EdgeInsets.zero,
          //               child: Text(
          //                 '#software',
          //                 style:
          //                 Theme.of(context).textTheme.caption!.copyWith(
          //                   color: Colors.blue,
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //         Padding(
          //           padding: const EdgeInsetsDirectional.only(
          //             end: 6.0,
          //           ),
          //           child: Container(
          //             height: 25.0,
          //             child: MaterialButton(
          //               onPressed: () {},
          //               minWidth: 1.0,
          //               padding: EdgeInsets.zero,
          //               child: Text(
          //                 '#flutter',
          //                 style:
          //                 Theme.of(context).textTheme.caption!.copyWith(
          //                   color: Colors.blue,
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),

          if(model.postImage !='')
            Padding(
              padding: const EdgeInsetsDirectional.only(
                  top: 15.0
              ),
              child: Container(
                height: 500.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    4.0,
                  ),
                  image: DecorationImage(
                    image: NetworkImage(
                      '${model.postImage}',
                    ),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 5.0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5.0,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            IconBroken.Heart,
                            size: 16.0,
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            '${SocialCubit.get(context).likesNum[index]}',
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ],
                      ),
                    ),
                    onTap: () {},
                  ),
                ),
                Expanded(
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children:
                        [
                          Icon(
                            IconBroken.Chat,
                            size: 16.0,
                            color: Colors.amber,
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            '${SocialCubit.get(context).commentsNum[index]} comments',
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ],
                      ),
                    ),
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 10.0,
            ),
            child: Container(
              width: double.infinity,
              height: 1.0,
              color: Colors.grey[300],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  child: Row(
                    children:
                    [
                      CircleAvatar(
                        radius: 18.0,
                        backgroundImage: NetworkImage(
                          '${SocialCubit.get(context).userModel!.image}',
                        ),
                      ),
                      SizedBox(
                        width: 15.0,
                      ),
                      Text(
                        'write a comment ...',
                        style:
                        Theme.of(context).textTheme.caption!.copyWith(),
                      ),
                    ],
                  ),
                  onTap: () {
                    SocialCubit.get(context).commentPost(SocialCubit.get(context).postsId[index]);
                    navigateTo(
                        context,
                        CommentsScreen(
                          SocialCubit.get(context).postsId[index],
                          SocialCubit.get(context).userModel!.uId.toString(),
                        ));
                  },
                ),
              ),
              InkWell(
                child: Row(
                  children:
                  [
                    Icon(
                      IconBroken.Heart,
                      size: 16.0,
                      color: Colors.red,
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      'Like',
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
                onTap: () {
                  SocialCubit.get(context).likePost(SocialCubit.get(context).postsId[index]);
                },
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
