abstract class SocialState {}

class SocialInitialState extends SocialState {}

//Get User Data
class SocialGetUserLoadingState extends SocialState {}
class SocialGetUserSuccessState extends SocialState {}
class SocialGetUserErrorState extends SocialState
{
  late final String error;
  SocialGetUserErrorState(this.error);
}

//Get Person Data
class SocialGetPersonLoadingState extends SocialState {}
class SocialGetPersonSuccessState extends SocialState {}
class SocialGetPersonErrorState extends SocialState
{
  late final String error;
  SocialGetPersonErrorState(this.error);
}


//Get All User Data
class SocialGetAllUserLoadingState extends SocialState {}
class SocialGetAllUserSuccessState extends SocialState {}
class SocialGetAllUserErrorState extends SocialState
{
  late final String error;
  SocialGetAllUserErrorState(this.error);
}


//Get All Person Data
class SocialGetAllPersonLoadingState extends SocialState {}
class SocialGetAllPersonSuccessState extends SocialState {}
class SocialGetAllPersonErrorState extends SocialState
{
  late final String error;
  SocialGetAllPersonErrorState(this.error);
}


//Get Post Data
class SocialGetPostLoadingState extends SocialState {}
class SocialGetPostSuccessState extends SocialState {}
class SocialGetPostErrorState extends SocialState
{
  late final String error;
  SocialGetPostErrorState(this.error);
}


//Get My Post Data
class SocialGetMyPostSuccessState extends SocialState {}
class SocialGetMyPostErrorState extends SocialState
{
  late final String error;
  SocialGetMyPostErrorState(this.error);
}


//Get Person Post Data
class SocialGetPersonPostSuccessState extends SocialState {}
class SocialGetPersonPostErrorState extends SocialState
{
  late final String error;
  SocialGetPersonPostErrorState(this.error);
}


//Get Like Data
class SocialLikePostSuccessState extends SocialState {}
class SocialLikePostErrorState extends SocialState
{
  late final String error;
  SocialLikePostErrorState(this.error);
}


//Get Comment Data
class SocialCommentPostSuccessState extends SocialState {}
class SocialCommentPostErrorState extends SocialState
{
  late final String error;
  SocialCommentPostErrorState(this.error);
}


//Bottom Nav Bar
class SocialChangeBottomNavState extends SocialState{}
class SocialNewPostState extends SocialState {}


//Profile Image Picker
class SocialProfileImagePickedSuccessState extends SocialState {}
class SocialProfileImagePickedErrorState extends SocialState {}


//Cover Image Picker
class SocialCoverImagePickedSuccessState extends SocialState {}
class SocialCoverImagePickedErrorState extends SocialState {}


//Upload Profile Image
class SocialUploadProfileImageSuccessState extends SocialState {}
class SocialUploadProfileImageErrorState extends SocialState {}


//Upload Cover Image
class SocialUploadCoverImageSuccessState extends SocialState {}
class SocialUploadCoverImageErrorState extends SocialState {}


//Update User
class SocialUserUpdateLoadingState extends SocialState {}
class SocialUserUpdateErrorState extends SocialState {}


//Create Post
class SocialCreatePostLoadingState extends SocialState {}
class SocialCreatePostSuccessState extends SocialState {}
class SocialCreatePostErrorState extends SocialState {}


//Post Image Picker
class SocialPostImagePickedSuccessState extends SocialState {}
class SocialPostImagePickedErrorState extends SocialState {}


//Remove Post Image
class SocialRemovePostImageState extends SocialState {}

// Send Message (chat)
class SocialSendMessageSuccessState extends SocialState {}
class SocialSendMessageErrorState extends SocialState
{
  late final String error;
  SocialSendMessageErrorState(this.error);
}
class SocialGetMessagesSuccessState extends SocialState {}


// Send Comment (chat)
class SocialSendCommentSuccessState extends SocialState {}
class SocialSendCommentErrorState extends SocialState
{
  late final String error;
  SocialSendCommentErrorState(this.error);
}
class SocialGetCommentsSuccessState extends SocialState {}


//Delete Post
class SocialDeletePostSuccessState extends SocialState {}
class SocialDeletePostErrorState extends SocialState
{
  late final String error;
  SocialDeletePostErrorState(this.error);
}


//Delete Chat
class SocialDeleteChatSuccessState extends SocialState {}
class SocialDeleteChatErrorState extends SocialState
{
  late final String error;
  SocialDeleteChatErrorState(this.error);
}


//Delete Message
class SocialMessageChatSuccessState extends SocialState {}
class SocialMessageChatErrorState extends SocialState
{
  late final String error;
  SocialMessageChatErrorState(this.error);
}


//Delete Comment
class SocialDeleteMessageCommentSuccessState extends SocialState {}
class SocialDeleteMessageCommentErrorState extends SocialState
{
  late final String error;
  SocialDeleteMessageCommentErrorState(this.error);
}
