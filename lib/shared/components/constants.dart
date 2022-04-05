// POST
// UPDATE
// DELETE

// GET

// base url : https://newsapi.org/
// method (url) : v2/top-headlines?
// queries : country=eg&category=business&apiKey=65f7f556ec76449fa7dc7c0069f040ca

//https://newsapi.org/v2/top-headlines?country=eg&category=business&apiKey=65f7f556ec76449fa7dc7c0069f040ca

import 'dart:ui';

import 'package:intl/intl.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'components.dart';

// void signOut(context)
// {
//   CacheHelper.removeData(
//     key: 'token',
//   ).then((value)
//   {
//     if (value)
//     {
//       navigateAndFinish(context,);
//     }
//   });
// }

void printFullText(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

String token = '';
dynamic uId = '';

String getDateTomorrow ()
{
  DateTime dateTime =  DateTime.now().add(Duration(days: 1));
  String date =  DateFormat.yMMMd().format(dateTime);
  return date;
}

const Color RED = Color(0xffF06060);
const Color YELLOW = Color(0xffF2EBBF);
const Color ORANGE = Color(0xfff3B562);
const Color GREEN = Color(0xff8CBEB2);
const Color BROWN = Color(0xff5C4B51);

const Color LoginColor1 = Color(0xff043138);
const Color LoginColor2 = Color(0xff229ea0);
