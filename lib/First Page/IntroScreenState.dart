import 'package:flutter/material.dart';
import 'package:flutterapp/authantication/mainLoginScreen.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';

class IntroScreen extends StatefulWidget {
  IntroScreen({Key key}) : super(key: key);

  @override
  IntroScreenState createState() => new IntroScreenState();
}

class IntroScreenState extends State<IntroScreen> {
  List<Slide> slides = new List();

  @override
  void initState() {
    super.initState();

    slides.add(
      new Slide(
        title: "Smart lend System",
        maxLineTitle: 2,
        styleTitle: TextStyle(
            color: Colors.white,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'RobotoMono'),
        description:
            "Banks’ loans are loans from the bank which are based on the future value of the business."
                " Banks are very specific when it comes to granting loans because they must be sure that the borrower will be able to repay.requesting a loan can be tedious, "
                " Existing solutions lack proper and efficient methodologies for finding a reliable loaning plan, either the loan is personal or business."
                "“Smart lend system” is the suggested mobile application aims to facilitate choosing loans by collecting information needed for loan.",
        styleDescription: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontStyle: FontStyle.italic,
            fontFamily: 'Raleway'),
        marginDescription:
            EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 70.0),
        centerWidget: Icon(
          Icons.attach_money,
          color: Colors.black,
          size: 50,
        ),
        colorBegin: Colors.green[800],
        colorEnd: Colors.green[400],
        backgroundImage: 'assets/images/logo.png',
        directionColorBegin: Alignment.topLeft,
        directionColorEnd: Alignment.bottomRight,
        onCenterItemPress: () {},
      ),
    );
    slides.add(
      new Slide(
        title: "Bank loan Search",
        styleTitle: TextStyle(
            color: Colors.white,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'RobotoMono'),
        description:
            "Search for loans in manyLebanese banks and get real time results and feedback.",
        styleDescription: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontStyle: FontStyle.italic,
            fontFamily: 'Raleway'),
        pathImage: "assets/images/bank.png",
        colorBegin: Colors.green[800],
        colorEnd: Colors.green[400],
        directionColorBegin: Alignment.topCenter,
        directionColorEnd: Alignment.bottomCenter,
        maxLineTextDescription: 3,
      ),
    );
    slides.add(
      new Slide(
        title: "Predict Loan Acceptance",
        styleTitle: TextStyle(
            color: Colors.white,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'RobotoMono'),
        description:
            "Using The Modren Machine Learinng you  can predict your loan and its status (Accepted or Not)",
        styleDescription: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontStyle: FontStyle.italic,
            fontFamily: 'Raleway'),
        pathImage: "assets/images/analytics.png",
        colorBegin: Colors.green[800],
        colorEnd: Colors.green[400],
        directionColorBegin: Alignment.topRight,
        directionColorEnd: Alignment.bottomLeft,
      ),
    );
    slides.add(
      new Slide(
        title: "Profile",
        styleTitle: TextStyle(
            color: Colors.white,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'RobotoMono'),
        description: "Create your own profile and mange it!",
        styleDescription: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontStyle: FontStyle.italic,
            fontFamily: 'Raleway'),
        pathImage: "assets/images/user.png",
        colorBegin: Colors.green[800],
        colorEnd: Colors.green[400],
        directionColorBegin: Alignment.topCenter,
        directionColorEnd: Alignment.bottomCenter,
        maxLineTextDescription: 3,
      ),
    );
    slides.add(
      new Slide(
        title: "Get Started",
        styleTitle: TextStyle(
            color: Colors.white,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'RobotoMono'),
        description: "Enjoy Our Smart Lend System!",
        styleDescription: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontStyle: FontStyle.italic,
            fontFamily: 'Raleway'),
        pathImage: "assets/images/smartphone.png",
        colorBegin: Colors.green[800],
        colorEnd: Colors.green[400],
        directionColorBegin: Alignment.topCenter,
        directionColorEnd: Alignment.bottomCenter,
        maxLineTextDescription: 3,
      ),
    );
  }

  void onDonePress() {
    Navigator.of(context).pushReplacement(new MaterialPageRoute(
        builder: (BuildContext context) => new LoginScreen3()));
  }

  Widget renderNextBtn() {
    return Icon(
      Icons.navigate_next,
      color: Colors.black,
      size: 35.0,
    );
  }

  Widget renderDoneBtn() {
    return Icon(
      Icons.done,
      color: Colors.black,
    );
  }

  Widget renderSkipBtn() {
    return Icon(
      Icons.skip_next,
      color: Colors.black,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new IntroSlider(
      // List slides
      slides: this.slides,

      // Skip button
      renderSkipBtn: this.renderSkipBtn(),
      colorSkipBtn: Color(0x33000000),
      highlightColorSkipBtn: Color(0xff000000),

      // Next button
      renderNextBtn: this.renderNextBtn(),

      // Done button
      renderDoneBtn: this.renderDoneBtn(),
      onDonePress: this.onDonePress,
      colorDoneBtn: Color(0x33000000),
      highlightColorDoneBtn: Color(0xff000000),

      // Dot indicator
      colorDot: Colors.black,
      colorActiveDot: Colors.green[600],
      sizeDot: 13.0,
      // onTabChangeCompleted: this.onTabChangeCompleted,

      // Show or hide status bar
      shouldHideStatusBar: false,
      backgroundColorAllSlides: Colors.green,
    );
  }
}
