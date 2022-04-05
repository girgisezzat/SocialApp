import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:social_app/modules/social_app/login/login_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';


class BoardingModel {
  final String image;
  final String title;
  final String body;

  BoardingModel({
    required this.title,
    required this.image,
    required this.body,
  });
}

class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {

  var boardController = PageController();

  List<BoardingModel> boarding =
  [
    BoardingModel(
      image: 'assets/images/socail_onboard.png',
      title: 'You can share your status with your friends now',
      body: 'Update your status',
    ),
    BoardingModel(
      image: 'assets/images/socail_onboard2.png',
      title: 'React with positive and negative posts and say your opinion',
      body: 'React with friends posts',
    ),
    BoardingModel(
      image: 'assets/images/socail_onboard3.png',
      title: 'Share your skills to make it trending',
      body: 'Be_Trend',
    ),
    BoardingModel(
      image: 'assets/images/socail_onboard4.png',
      title: 'You will enjoy chatting with your friends',
      body: 'Connect your friends',
    ),
  ];

  bool isLast = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        actions:
        [
          TextButton(
            onPressed: ()
            {
              navigateAndFinish(context, SocialLoginScreen(),);
            },
            child: Text(
              'Skip',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children:
          [
            Expanded(
              child: PageView.builder(
                itemBuilder: (context, index) =>
                    buildBoardingItem(boarding[index]),
                itemCount: boarding.length,
                physics: BouncingScrollPhysics(),
                controller: boardController,
                onPageChanged: (int index) {
                  if (index == boarding.length - 1) {
                    setState(() {
                      isLast = true;
                    });
                  }
                  else {
                    setState(() {
                      isLast = false;
                    });
                  }
                },
              ),
            ),
            SizedBox(
              height: 40.0,
            ),
            Row(
              children:
              [
                SmoothPageIndicator(
                  controller: boardController,
                  effect: ExpandingDotsEffect(
                    dotColor: Colors.grey,
                    activeDotColor: Colors.indigo,
                    dotHeight: 10,
                    expansionFactor: 4,
                    dotWidth: 20,
                    spacing: 5.0,
                  ),
                  count: boarding.length,
                ),
                Spacer(),
                FloatingActionButton(
                  onPressed: () {
                    if (isLast)
                    {
                      navigateAndFinish(context, SocialLoginScreen(),);
                    }
                    else {
                      boardController.nextPage(
                        duration: Duration(
                          milliseconds: 750,
                        ),
                        curve: Curves.fastLinearToSlowEaseIn,
                      );
                    }
                  },
                  child: Icon(
                    Icons.arrow_forward_ios,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBoardingItem(BoardingModel model) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded  (
        child: Image(
          image: AssetImage('${model.image}'),
        ),
      ),
      SizedBox(
        height: 30.0,
      ),
      Text(
        '${model.title}',
        style: TextStyle(
            fontSize: 20.0,
        ),
      ),
      SizedBox(
        height: 15.0,
      ),
      Text(
        '${model.body}',
        style: TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.bold
        ),
      ),
      SizedBox(
        height: 30.0,
      ),
    ],
  );
}