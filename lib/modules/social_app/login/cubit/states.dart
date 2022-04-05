abstract class SocialLoginState {}

class SocialLoginInitialState extends SocialLoginState{}

class SocialLoginLoadingState extends SocialLoginState{}
class SocialLoginSuccessState extends SocialLoginState
{
  late final String uId;
  SocialLoginSuccessState(this.uId);
}
class SocialLoginErrorState extends SocialLoginState
{
  late final String error;

  SocialLoginErrorState(this.error);
}


class SocialChangePasswordVisibilityState extends SocialLoginState{}