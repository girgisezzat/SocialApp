import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:social_app/layout/social_app/cubit/cubit.dart';
import 'package:social_app/layout/social_app/cubit/state.dart';
import 'package:social_app/models/social_app/social_user_model.dart';
import 'package:social_app/modules/social_app/chat_details/chat_details_screen.dart';
import 'package:social_app/shared/components/components.dart';

class ChatsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit,SocialState>(
      listener: (context,state){},
      builder: (context,state){
        return Conditional.single(
          context: context,
          conditionBuilder: (context)=> SocialCubit.get(context).usersList.length > 0,
          widgetBuilder: (context)=> ListView.separated(
            physics: BouncingScrollPhysics(),
            itemBuilder: (context,index) =>
                buildChatItem(SocialCubit.get(context).usersList[index],context),
            separatorBuilder: (context,index) => myDivider(),
            itemCount: SocialCubit.get(context).usersList.length,
          ),
          fallbackBuilder: (context)=> Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget buildChatItem(SocialUserModel model, context) => InkWell(
    onTap: () {
      navigateTo(
        context,
        ChatDetailsScreen(
           userModel: model,
        ),
      );
    },
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: FocusedMenuHolder(
        onPressed: (){},
        blurSize: 4.0,
        animateMenuItems: true,
        blurBackgroundColor: Colors.black,
        menuItems: <FocusedMenuItem>[
          FocusedMenuItem(
            title: Text('Archive'),
            onPressed: (){} ,
            trailingIcon: Icon(
              Icons.archive,
              color: Colors.indigo,
            ),
          ),
          FocusedMenuItem(
            title: Text('Delete'),
            onPressed: (){} ,
            trailingIcon: Icon(
              Icons.delete,
              color: Colors.indigo,
            ),
          ),
          FocusedMenuItem(
            title: Text('Block'),
            onPressed: (){} ,
            trailingIcon: Icon(
              Icons.block_outlined,
              color: Colors.indigo,
            ),
          ),
          FocusedMenuItem(
            title: Text('Mute Notification'),
            onPressed: (){} ,
            trailingIcon: Icon(
              Icons.notifications_off,
              color: Colors.indigo,
            ),
          ),
          FocusedMenuItem(
            title: Text('Create Group'),
            onPressed: (){} ,
            trailingIcon: Icon(
              Icons.group_add,
              color: Colors.indigo,
            ),
          ),
        ],
        child: Container(
          child: Row(
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
              Text(
                '${model.name}',
                style: TextStyle(
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
