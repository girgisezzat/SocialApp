import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/layout/social_app/cubit/state.dart';
import 'package:social_app/models/social_app/comment_model.dart';
import 'package:social_app/models/social_app/message_model.dart';
import 'package:social_app/models/social_app/post_model.dart';
import 'package:social_app/models/social_app/social_user_model.dart';
import 'package:social_app/modules/social_app/chats/Chats_screen.dart';
import 'package:social_app/modules/social_app/feeds/feeds_screen.dart';
import 'package:social_app/modules/social_app/my_profile/my_profile_screen.dart';
import 'package:social_app/modules/social_app/new_post/new_post_screen.dart';
import 'package:social_app/modules/social_app/users/users_screen.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/styles/icon_broken.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;



class SocialCubit extends Cubit<SocialState>
{
  SocialCubit() : super(SocialInitialState());

  //to be more easily when use this cubit in many places
  static SocialCubit get(context)=>BlocProvider.of(context);


  List<Widget> bottomItems=
  [
    Icon(
      IconBroken.Home,
      size: 20,
    ),
    Icon(
      IconBroken.Chat,
      size: 20,
    ),
    Icon(
      IconBroken.Paper_Upload,
      size: 20,
    ),
    Icon(
      IconBroken.Profile,
      size: 20,
    ),
  ];


  List<Widget> screens =
  [
    FeedsScreen(),
    ChatsScreen(),
    NewPostScreen(),
    MyProfileScreen(),
  ];


  List<String> titles =
  [
    'Feeds',
    'Chats',
    'Post',
    'Profile',
  ];


  int currentIndex = 0;
  void changeBottomNavBar(int index)
  {
    if(index == 1)
      getAllUserData();
    if(index == 2)
      emit(SocialNewPostState());
    else{
      currentIndex = index;
      emit(SocialChangeBottomNavState());
    }
  }

  /* get user data from fireStore */
  SocialUserModel? userModel;
  // void getUserData()
  // {
  //   emit(SocialGetUserLoadingState());
  //   FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(uId)
  //       .get()
  //       .then((value){
  //         userModel = SocialUserModel.fromJson(value.data()!);
  //         emit(SocialGetUserSuccessState());
  //   }).catchError((error){
  //     emit(SocialGetUserErrorState(error.toString()));
  //     print(error.toString());
  //   });
  // }
  void getUserData()
  {
    emit(SocialGetUserLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .snapshots()
        .listen((event) {
          userModel = null;
          userModel = SocialUserModel.fromJson(event.data()!);
          emit(SocialGetUserSuccessState());
       });
  }


  /* get another user data from fireStore */
  SocialUserModel? personModel;
  void getPersonData({
    required String personId,
  })
  {
    emit(SocialGetPersonLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(personId)
        .snapshots()
        .listen((event) {
          personModel = null;
          personModel = SocialUserModel.fromJson(event.data()!);
          emit(SocialGetPersonSuccessState());
    });
  }


  var picker = ImagePicker();

  File? profileImage;
  Future<void> getProfileImage() async
  {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      print(pickedFile.path);
      emit(SocialProfileImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(SocialProfileImagePickedErrorState());
    }
  }


  File? coverImage;
  Future<void> getCoverImage() async
  {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(SocialCoverImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(SocialCoverImagePickedErrorState());
    }
  }


  // String profileImageUrl = '';
  // void uploadProfileImage1(){
  //   firebase_storage.FirebaseStorage.instance
  //       .ref()
  //       .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
  //       .putFile(profileImage!)
  //       .then((value) {
  //         value.ref.getDownloadURL().then((value)
  //         {
  //           emit(SocialUploadProfileImageSuccessState());
  //           print(value);
  //           profileImageUrl = value;
  //         }).catchError((error){
  //           emit(SocialUploadProfileImageErrorState());
  //         });
  //       }).catchError((error) {
  //     emit(SocialUploadProfileImageErrorState());
  //   });
  // }

  // String coverImageUrl = '';
  // void uploadCoverImage1(){
  //   firebase_storage.FirebaseStorage.instance
  //       .ref()
  //       .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
  //       .putFile(coverImage!)
  //       .then((value) {
  //     value.ref.getDownloadURL().then((value)
  //     {
  //       emit(SocialUploadCoverImageSuccessState());
  //       print(value);
  //       coverImageUrl = value;
  //     }).catchError((error){
  //       emit(SocialUploadCoverImageErrorState());
  //     });
  //   }).catchError((error) {
  //     emit(SocialUploadCoverImageErrorState());
  //   });
  // }


  void updateUser({
    required String name,
    required String phone,
    required String bio,
    String? cover,
    String? image,
  })
  {
    SocialUserModel model = SocialUserModel(
      name: name,
      phone: phone,
      bio: bio,
      email: userModel!.email,
      cover: cover??userModel!.cover,
      image: image??userModel!.image,
      uId: userModel!.uId,
      isEmailVerified: false,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .update(model.toMap())
        .then((value) {
          getUserData();
    }).catchError((error)
    {
      emit(SocialUserUpdateErrorState());
      print(error.toString());
    });
  }


  void uploadProfileImage({
    required String name,
    required String phone,
    required String bio,
  })
  {
    emit(SocialUserUpdateLoadingState());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value)
      {
        //emit(SocialUploadProfileImageSuccessState());
        print(value);
        updateUser(
          name:name,
          phone:phone,
          bio:bio,
          image:value,
        );
      }).catchError((error) {
        emit(SocialUploadProfileImageErrorState());
        print(error.toString());
      });
    }).catchError((error) {
      emit(SocialUploadProfileImageErrorState());
      print(error.toString());
    });
  }


  void uploadCoverImage({
    required String name,
    required String phone,
    required String bio,
  })
  {
    emit(SocialUserUpdateLoadingState());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        //emit(SocialUploadCoverImageSuccessState());
        print(value);
        updateUser(
          name:name,
          phone:phone,
          bio:bio,
          cover:value,
        );
      }).catchError((error)
      {
        emit(SocialUploadCoverImageErrorState());
        print(error.toString());
      });
    }).catchError((error)
    {
      emit(SocialUploadCoverImageErrorState());
      print(error.toString());
    });
  }



  File? postImage;
  Future<void> getPostImage() async
  {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(SocialPostImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(SocialPostImagePickedErrorState());
    }
  }


  void createPost({
    required String dateTime,
    required String text,
    String? postImage,
  })
  {
    emit(SocialCreatePostLoadingState());

    PostModel model = PostModel(
      name: userModel!.name,
      image: userModel!.image,
      uId: userModel!.uId,
      dateTime: dateTime,
      text: text,
      postImage: postImage??'',
    );

    FirebaseFirestore.instance
        .collection('posts')
        .add(model.toMap())
        .then((value)
    {
      emit(SocialCreatePostSuccessState());

    }).catchError((error)
    {
      emit(SocialCreatePostErrorState());
    });
  }


  void uploadPostImage({
    required String dateTime,
    required String text,
  })
  {
    emit(SocialCreatePostLoadingState());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value)
      {
        print(value);
        createPost(
          text: text,
          dateTime: dateTime,
          postImage: value,
        );
      }).catchError((error)
      {
        emit(SocialCreatePostErrorState());
      });
    }).catchError((error)
    {
      emit(SocialCreatePostErrorState());
    });
  }


  void removePostImage()
  {
    postImage = null;
    emit(SocialRemovePostImageState());
  }


  List<SocialUserModel> usersList = [];
  List<SocialUserModel> personsList = [];
  List<PostModel> postsList = [];
  List<MessageModel> messagesList = [];
  List<CommentModel> commentList = [];
  List<String> postsId = [];
  List<String> commentsId = [];
  List<String> messagesId = [];
  List<int> likesNum = [];
  List<int> commentsNum = [];

  // void getPostData()
  // {
  //   FirebaseFirestore.instance
  //       .collection('posts')
  //       .get()
  //       .then((value) {
  //         value.docs.forEach((element) {
  //
  //           element.reference
  //           .collection('likes')
  //           .get()
  //           .then((value) {
  //             likesNum.add(value.docs.length);
  //             postsId.add(element.id);
  //             postsList.add(PostModel.fromJson(element.data()));
  //           }).catchError((error){});
  //
  //           element.reference
  //               .collection('comments')
  //               .get()
  //               .then((value) {
  //             commentsNum.add(value.docs.length);
  //             postsId.add(element.id);
  //             postsList.add(PostModel.fromJson(element.data()));
  //           }).catchError((error){});
  //         });
  //
  //         emit(SocialGetPostSuccessState());
  //
  //   }).catchError((error){
  //     emit(SocialGetPostErrorState(error.toString()));
  //     print(error.toString());
  //   });
  // }

  void getPostData()
  {
    FirebaseFirestore.instance
        .collection('posts')
        .orderBy('dateTime' , descending: true)
        .snapshots()
        .listen((event) {
          postsList = [];
          postsId = [];
          likesNum = [];
          commentsNum = [];

          event.docs.forEach((element) {

            element.reference
                .collection('likes')
                .get()
                .then((value) {
                  likesNum.add(value.docs.length);
                  commentsNum.add(value.docs.length);
                  postsId.add(element.id);
                  postsList.add(PostModel.fromJson(element.data()));
                }).catchError((error){});

          });

          emit(SocialGetPostSuccessState());
        });
  }

  void getAllUserData()
  {
    if(usersList.length == 0)
      FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((value) {
          value.docs.forEach((element) {
            if(element.data()['uId'] != userModel!.uId)
              usersList.add(SocialUserModel.fromJson(element.data()));
          });

          emit(SocialGetAllUserSuccessState());
        }).catchError((error){
          emit(SocialGetAllUserErrorState(error.toString()));
          print(error.toString());
        });
  }


  void getAllPersonData({
    required String personId,
  })
  {
    if(personsList.length == 0)
      FirebaseFirestore.instance
          .collection('users')
          .get()
          .then((value) {
        value.docs.forEach((element) {
          if(element.data()['uId'] != personId)
            personsList.add(SocialUserModel.fromJson(element.data()));
        });

        emit(SocialGetAllUserSuccessState());
      }).catchError((error){
        emit(SocialGetAllUserErrorState(error.toString()));
        print(error.toString());
      });
  }


  void likePost(String postId)
  {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userModel!.uId)
        .set({'like':true,})
        .then((value){
          emit(SocialLikePostSuccessState());
    }).catchError((error){
      emit(SocialLikePostErrorState(error.toString()));
      print(error.toString());
    });
  }


  void commentPost(String postId)
  {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(userModel!.uId)
        .set({'comment':true,})
        .then((value){
      emit(SocialCommentPostSuccessState());
    }).catchError((error){
      emit(SocialCommentPostErrorState(error.toString()));
      print(error.toString());
    });
  }


  void sendMessage({
  required String receiverID,
  required String dateTime,
  required String text,
})
  {
    MessageModel messageModel = MessageModel(
      text: text,
      senderID: userModel!.uId,
      receiverID: receiverID,
      dateTime: dateTime,
    );

    // set my chats
    FirebaseFirestore.instance
    .collection('users')
    .doc(userModel!.uId)
    .collection('chats')
    .doc(receiverID)
    .collection('messages')
    .add(messageModel.toMap())
    .then((value) {

      emit(SocialSendMessageSuccessState());
    }).catchError((error){

      emit(SocialSendMessageErrorState(error.toString()));
      print(error.toString());
    });

    // set receiver chats
    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverID)
        .collection('chats')
        .doc(userModel!.uId)
        .collection('messages')
        .add(messageModel.toMap())
        .then((value) {
          emit(SocialSendMessageSuccessState());
    }).catchError((error){
      emit(SocialSendMessageErrorState(error.toString()));
      print(error.toString());
    });
  }


  void getMessageData({
    required String receiverID,
  })
  {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverID)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {

          messagesList =[];
          messagesId = [];

          event.docs.forEach((element) {
            messagesId.add(element.id);
            messagesList.add(MessageModel.fromJson(element.data()));
          });

          emit(SocialGetMessagesSuccessState());
    });
  }


  void sendComment({
    required String text,
    required String dateTime,
    required String postId,
  })
  {
    CommentModel commentModel = CommentModel(
      text: text,
      dateTime: dateTime,
      senderId: userModel!.uId,
      profileImage: userModel!.image,
      commenterName:userModel!.name,
    );

    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .add(commentModel.toMap())
        .then((value) {
          emit(SocialSendCommentSuccessState());
    }).catchError((error){
      emit(SocialSendCommentErrorState(error.toString()));
      print(error.toString());
    });


  }


  void getCommentData({
    required String postId,
  })
  {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
          commentList = [];
          commentsId = [];

          event.docs.forEach((element) {
            commentsId.add(element.id);
            commentList.add(CommentModel.fromJson(element.data()));
          });
          emit(SocialGetCommentsSuccessState());
    });
  }


  List<PostModel> myPosts = [];
  List<String> myPostsId = [];
  List<int> myLikes = [];
  List<int> myComments = [];
  List<bool> myLikedByMe = [];
  List<String> myImages = [];
  List<String> myTextOfImages = [];

  void getMyPostData()
  {
    FirebaseFirestore.instance
        .collection('posts')
        .orderBy('dateTime', descending: true)
        .snapshots()
        .listen((event) {
          myPosts = [];
          myPostsId = [];
          myLikes = [];
          myComments = [];
          myImages = [];
          myTextOfImages = [];

          event.docs.forEach((element) {
            if (element.data()['uId'] == userModel!.uId) {
              element.reference
                  .collection('likes')
                  .get()
                  .then((value) {
                    myLikes.add(value.docs.length);
                    myPostsId.add(element.id);
                    myPosts.add(PostModel.fromJson(element.data()));
                  }).catchError((error) {});

              if (element.data()['postImage'] != '') {

                  myImages.add(element.data()['postImage']);
                  myTextOfImages.add(element.data()['text']);
              }
            }
          });
          emit(SocialGetMyPostSuccessState());
        });
  }


  List<PostModel> personPosts = [];
  List<String> personPostsId = [];
  List<int> personLikes = [];
  List<int> personComments = [];
  List<String> personImages = [];
  List<String> personTexts = [];
  List<bool> personIsLikedByMe =[];


  void getPersonPosts({
    required String personId,
  })
  {
    FirebaseFirestore.instance
        .collection('posts')
        .orderBy('dateTime' , descending: true)
        .snapshots()
        .listen((event) {
          personPosts = [];
          personPostsId = [];
          personLikes = [];
          personComments = [];
          personImages = [];
          personTexts = [];

          event.docs.forEach((element) {
            if (element.data()['uId'] == personId) {
              element.reference
                  .collection('likes')
                  .get()
                  .then((value) {
                    personLikes.add(value.docs.length);
                    personPostsId.add(element.id);
                    personPosts.add(PostModel.fromJson(element.data()));
                  }).catchError((error){});

              if (element.data()['postImage'] != '') {
                personImages.add(element.data()['postImage']);
                personTexts.add(element.data()['text']);
              }
            }
          });
          emit(SocialGetPersonPostSuccessState());
        });
  }


  void deletePost(String postId)
  {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .delete()
        .then((value) {
          emit(SocialDeletePostSuccessState());
    }).catchError((error){
      emit(SocialDeletePostErrorState(error.toString()));
      print(error.toString());
      print('error in deleting post');
    });

  }


  void deleteChat(String receiverID)
  {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverID)
        .delete()
        .then((value) {
          emit(SocialDeleteChatSuccessState());
    }).catchError((error){
      emit(SocialDeleteChatErrorState(error.toString()));
      print(error.toString());
      print('error in deleting chat');
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverID)
        .collection('chats')
        .doc(userModel!.uId)
        .delete()
        .then((value) {
          emit(SocialDeleteChatSuccessState());
    }).catchError((error){
      emit(SocialDeleteChatErrorState(error.toString()));
      print(error.toString());
      print('error in deleting chat');
    });

  }


  void deleteMessage(String receiverID,String messageID)
  {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverID)
        .collection('messages')
        .doc(messageID)
        .delete()
        .then((value) {
      emit(SocialMessageChatSuccessState());
    }).catchError((error){
      emit(SocialMessageChatErrorState(error.toString()));
      print(error.toString());
      print('error in deleting message');
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverID)
        .collection('chats')
        .doc(userModel!.uId)
        .collection('messages')
        .doc(messageID)
        .delete()
        .then((value) {
      emit(SocialDeleteChatSuccessState());
    }).catchError((error){
      emit(SocialDeleteChatErrorState(error.toString()));
      print(error.toString());
      print('error in deleting message');
    });

  }


  void deleteComment(String postId,String commentId)
  {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .delete()
        .then((value) {
      emit(SocialDeleteMessageCommentSuccessState());
    }).catchError((error){
      emit(SocialDeleteMessageCommentErrorState(error.toString()));
      print(error.toString());
      print('error in deleting comment');
    });

  }

}