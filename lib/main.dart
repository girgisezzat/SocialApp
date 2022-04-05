 import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/social_app/cubit/state.dart';
import 'package:social_app/modules/social_app/login/login_screen.dart';
import 'package:social_app/shared/bloc_observer.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'package:social_app/shared/network/remote/dio_helper.dart';
import 'package:social_app/shared/styles/themes.dart';
import 'layout/social_app/cubit/cubit.dart';
import 'modules/social_app/on_boarding/OnBoardingScreen.dart';

 Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async
 {
   print('on background message');
   print(message.data.toString());

   showToast(
     text: 'on background message',
     state: ToastStates.SUCCESS,
   );
 }



void main() async{

  //بيتاكد ان كل حاججة هنا ف الميثود خلصت وبعدين يفتح الابليكاشن
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  var token = await FirebaseMessaging.instance.getToken();
  print(token);

  // foreground fcm
  FirebaseMessaging.onMessage.listen((event)
  {
    print('on message');
    print(event.data.toString());
    showToast(
      text: 'on message',
      state: ToastStates.SUCCESS,
    );
  });

  // when click on notification to open app
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    print('on message opened app');
    print(event.data.toString());
    showToast(
      text: 'on message opened app',
      state: ToastStates.SUCCESS,
    );
  });

  // background fcm
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();

   uId = CacheHelper.getData(key: 'uId');
   print(uId);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (BuildContext context) => SocialCubit()
              ..getUserData()
              ..getPostData()
              ..getMyPostData()
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: ThemeMode.light,
          home: OnBoardingScreen(),
        )
    );
  }
}
