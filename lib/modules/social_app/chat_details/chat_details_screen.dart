import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:social_app/layout/social_app/cubit/cubit.dart';
import 'package:social_app/layout/social_app/cubit/state.dart';
import 'package:social_app/models/social_app/message_model.dart';
import 'package:social_app/models/social_app/social_user_model.dart';

class ChatDetailsScreen extends StatelessWidget {

  late SocialUserModel userModel;
  ChatDetailsScreen({required this.userModel});

  var messageController = TextEditingController();

  void clearController()
  {
    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        SocialCubit.get(context).getMessageData(
          receiverID: userModel.uId.toString(),
        );

        return BlocConsumer<SocialCubit,SocialState>(
          listener: (context,state){},
          builder: (context,state){
            return Scaffold(
              appBar: AppBar(
                titleSpacing: 0.0,
                title: Row(
                  children:
                  [
                    CircleAvatar(
                      radius: 20.0,
                      backgroundImage: NetworkImage(
                        '${userModel.image}',
                      ),

                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Text(
                      '${userModel.name}',
                    ),
                  ],
                ),
              ),
              body: Conditional.single(
                  context: context,
                  conditionBuilder:(context)=> SocialCubit.get(context).messagesList.length >= 0,
                  widgetBuilder: (context)=>Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.separated(
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index)
                            {
                              var message = SocialCubit.get(context).messagesList[index];

                              if(SocialCubit.get(context).userModel!.uId == message.senderID)
                                return buildMyMessage(message,context,index);

                              return buildMessage(message,context,index);
                            },
                            separatorBuilder: (context, index) => SizedBox(
                              height: 15.0,
                            ),
                            itemCount: SocialCubit.get(context).messagesList.length,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(
                              15.0,
                            ),
                          ),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0,
                                  ),
                                  child: TextFormField(
                                    controller: messageController,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'type your message here ...',
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 50.0,
                                color: Colors.blue,
                                child: MaterialButton(
                                  onPressed: () {
                                    SocialCubit.get(context).sendMessage(
                                      receiverID: userModel.uId.toString(),
                                      dateTime: DateTime.now().toString(),
                                      text: messageController.text,
                                    );
                                    clearController();
                                  },
                                  minWidth: 1.0,
                                  child: Icon(
                                    Icons.send,
                                    size: 16.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  fallbackBuilder: (context)=> Center(child: CircularProgressIndicator()),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildMessage(MessageModel messageModel,context,index) => Align(
    alignment: AlignmentDirectional.centerStart,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadiusDirectional.only(
          topStart: Radius.circular(
              10.0
          ),
          topEnd: Radius.circular(
              10.0
          ),
          bottomEnd: Radius.circular(
              10.0
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: 10.0,
      ),
      child: FocusedMenuHolder(
        onPressed: (){},
        blurSize: 4.0,
        animateMenuItems: true,
        blurBackgroundColor: Colors.black,
        menuItems: <FocusedMenuItem>[
          FocusedMenuItem(
            title: Text('Copy'),
            onPressed: (){} ,
            trailingIcon: Icon(
              Icons.copy_outlined,
              color: Colors.indigo,
            ),
          ),
          FocusedMenuItem(
            title: Text('Replay'),
            onPressed: (){} ,
            trailingIcon: Icon(
              Icons.reply_all_outlined,
              color: Colors.indigo,
            ),
          ),
          FocusedMenuItem(
            title: Text('Forward'),
            onPressed: (){} ,
            trailingIcon: Icon(
              Icons.forward,
              color: Colors.indigo,
            ),
          ),
          FocusedMenuItem(
            title: Text('Remove'),
            onPressed: (){
              SocialCubit.get(context).deleteMessage(
                  userModel.uId.toString(),SocialCubit.get(context).messagesId[index]);
              } ,
            trailingIcon: Icon(
              Icons.delete,
              color: Colors.indigo,
            ),
          ),
        ],
        child: Text(
          '${messageModel.text}',
        ),
      ),
    ),
  );

  Widget buildMyMessage(MessageModel messageModel,context,index) => Align(
    alignment: AlignmentDirectional.centerEnd,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.2),
        borderRadius: BorderRadiusDirectional.only(
          topStart: Radius.circular(
              10.0
          ),
          topEnd: Radius.circular(
              10.0
          ),
          bottomStart: Radius.circular(
              10.0
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: 10.0,
      ),
      child: FocusedMenuHolder(
        onPressed: (){},
        blurSize: 4.0,
        animateMenuItems: true,
        blurBackgroundColor: Colors.black,
        menuItems: <FocusedMenuItem>[
          FocusedMenuItem(
            title: Text('Copy'),
            onPressed: (){} ,
            trailingIcon: Icon(
              Icons.copy_outlined,
              color: Colors.indigo,
            ),
          ),
          FocusedMenuItem(
            title: Text('Replay'),
            onPressed: (){} ,
            trailingIcon: Icon(
              Icons.reply_all_outlined,
              color: Colors.indigo,
            ),
          ),
          FocusedMenuItem(
            title: Text('Forward'),
            onPressed: (){} ,
            trailingIcon: Icon(
              Icons.forward,
              color: Colors.indigo,
            ),
          ),
          FocusedMenuItem(
            title: Text('Remove'),
            onPressed: (){
              SocialCubit.get(context).deleteMessage(
                  userModel.uId.toString(),SocialCubit.get(context).messagesId[index]);
              } ,
            trailingIcon: Icon(
              Icons.delete,
              color: Colors.indigo,
            ),
          ),
        ],
        child: Text(
          '${messageModel.text}',
        ),
      ),
    ),
  );
}
