import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:social_app/layout/social_app/cubit/cubit.dart';
import 'package:social_app/layout/social_app/cubit/state.dart';
import 'package:social_app/modules/social_app/new_post/new_post_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/icon_broken.dart';


class SocialLayout extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<SocialCubit, SocialState>(
      listener: (context, state) {
        if(state is SocialNewPostState){
          navigateTo(
              context,
              NewPostScreen()
          );
        }
      },
      builder: (context, state) {
        var cubit = SocialCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.indigo,
            title: Text(
              cubit.titles[cubit.currentIndex],
            ),
            actions:
            [
              IconButton(
                icon: Icon(
                  IconBroken.Notification,
                ),
                onPressed: (){},
              ),
              IconButton(
                icon: Icon(
                  IconBroken.Search,
                ),
                onPressed: (){},
              ),
            ],
          ),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: CurvedNavigationBar(
            height: 60,
            index: cubit.currentIndex,
            onTap: (index)
            {
              cubit.changeBottomNavBar(index);
            },
            items: cubit.bottomItems,
          ),
        );
      },
    );
  }
}
