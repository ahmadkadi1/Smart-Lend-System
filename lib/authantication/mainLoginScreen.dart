import 'package:auto_size_text/auto_size_text.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/navigation%20home/tableview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Animation/DelayedAnimation.dart';
import 'authentication.dart';
import '../model/user.dart';

class LoginScreen3 extends StatefulWidget {
  @override
  _LoginScreen3State createState() => new _LoginScreen3State();
}

class _LoginScreen3State extends State<LoginScreen3>
    with TickerProviderStateMixin {
  final int delayedAmount = 500;
  double _scale;
  AnimationController _controllerAnimation;
  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();
  final RoundedLoadingButtonController _loginController =
      new RoundedLoadingButtonController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  String dropdownValue;
  List<String> _items = ['Student', 'Employee', 'Self Employed'];
  bool SignupPageCheckBox = false;
  TextEditingController newPasswordController = new TextEditingController();
  TextEditingController newPhoneController = new TextEditingController();
  TextEditingController newEmailController = new TextEditingController();
  TextEditingController newUserNameController = new TextEditingController();

  FirebaseAuth auth;

  @override
  void initState() {
    _controllerAnimation = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 200,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
    auth = FirebaseAuth.instance;
    database = FirebaseDatabase.instance;
    databaseReference = database.reference().child("users");
    super.initState();
  }

  Widget HomePage() {
    return new Scaffold(
        resizeToAvoidBottomPadding: true,
        body: new SingleChildScrollView(
            child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Color(0xff31893d), Color(0xff96ed98)])),
          child: new ListView(
            children: <Widget>[
              Container(
                  margin: const EdgeInsets.only(top: 25.0),
                  child: AvatarGlow(
                    endRadius: 90,
                    duration: Duration(seconds: 2),
                    glowColor: Colors.white24,
                    repeat: true,
                    repeatPauseDuration: Duration(
                      milliseconds: 500,
                    ),
                    startDelay: Duration(
                      milliseconds: 500,
                    ),
                    child: Material(
                        elevation: 8.0,
                        shape: CircleBorder(),
                        child: CircleAvatar(
                          backgroundColor: Colors.grey[100],
                          child: Icon(
                            Icons.attach_money,
                            color: Colors.green,
                            size: 50.0,
                          ),
                          radius: 50.0,
                        )),
                  )),
              Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  child: DelayedAnimation(
                    child: Text(
                      "Welcome To Smart lend System",
                      style: TextStyle(
                          fontFamily: "VT323",
                          fontWeight: FontWeight.bold,
                          fontSize: 22.0,
                          color: Colors.white),
                    ),
                    delay: delayedAmount + 500,
                  )),
              new Container(
                width: MediaQuery.of(context).size.width,
                margin:
                    const EdgeInsets.only(left: 30.0, right: 30.0, top: 75.0),
                alignment: Alignment.center,
                child: new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new OutlineButton(
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        color: Colors.green,
                        highlightedBorderColor: Colors.white,
                        onPressed: () => gotoSignup(),
                        child: new Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20.0,
                            horizontal: 20.0,
                          ),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Expanded(
                                child: Text(
                                  "LOGIN",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              new Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(
                    left: 30.0, right: 30.0, top: 30.0, bottom: 10),
                alignment: Alignment.center,
                child: new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new FlatButton(
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        color: Colors.white,
                        onPressed: () => gotoLogin(),
                        child: new Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20.0,
                            horizontal: 20.0,
                          ),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Expanded(
                                child: Text(
                                  "SIGN UP",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )));
  }

  Widget LoginPage() {
    return new Scaffold(
        resizeToAvoidBottomPadding: true,
        body: new SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xff31893d), Color(0xff96ed98)])),
                child: ListView(
                  children: <Widget>[
                    new ClipPath(
                      child: Container(
                        margin: const EdgeInsets.only(top: 5.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                              image:
                                  new ExactAssetImage("assets/images/logo.png"),
                              fit: BoxFit.contain),
                        ),
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(top: 180.0, bottom: 50.0),
                      ),
                    ),
                    new Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white.withOpacity(0.5),
                          width: 1.0,
                        ),
                      ),
                      margin: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      child: Row(
                        children: <Widget>[
                          new Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 15.0),
                            child: Icon(
                              Icons.star,
                              color: Colors.white,
                            ),
                          ),
                          new Expanded(
                            child: DropdownButton<String>(
                              hint: Text(
                                'Select a status',
                                style: TextStyle(color: Colors.white),
                              ),
                              isExpanded: true,
                              value: dropdownValue,
                              icon: Icon(
                                Icons.arrow_downward,
                                color: Color(0xffFD6D84),
                              ),
                              iconSize: 20,
                              elevation: 16,
                              style: TextStyle(color: Colors.white),
                              onChanged: (String Value) {
                                setState(() {
                                  dropdownValue = Value;
                                });
                              },
                              items: _items.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Roboto'),
                                  ),
                                );
                              }).toList(),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white.withOpacity(0.5),
                          width: 1.0,
                        ),
                      ),
                      margin: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      child: Row(
                        children: <Widget>[
                          new Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 15.0),
                            child: Icon(
                              Icons.person_outline,
                              color: Colors.white,
                            ),
                          ),
                          new Expanded(
                            child: TextField(
                              maxLength: 15,
                              controller: newUserNameController,
                              decoration: InputDecoration(
                                counterText: '',
                                border: InputBorder.none,
                                hintText: 'Username',
                                hintStyle: TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white.withOpacity(0.5),
                          width: 1.0,
                        ),
                      ),
                      margin: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      child: Row(
                        children: <Widget>[
                          new Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 15.0),
                            child: Icon(
                              Icons.email,
                              color: Colors.white,
                            ),
                          ),
                          new Expanded(
                            child: TextField(
                              controller: newEmailController,
                              maxLength: 50,
                              maxLines: 1,
                              decoration: InputDecoration(
                                counterText: '',
                                border: InputBorder.none,
                                hintText: 'Email',
                                hintStyle: TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white.withOpacity(0.5),
                          width: 1.0,
                        ),
                      ),
                      margin: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      child: Row(
                        children: <Widget>[
                          new Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 15.0),
                            child: Icon(
                              Icons.phone,
                              color: Colors.white,
                            ),
                          ),
                          CountryCodePicker(
                            onChanged: _onCountryChange,
                            // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                            initialSelection: 'LB',
                            textStyle: TextStyle(color: Colors.white),
                            favorite: ['+961', 'LB'],
                            // optional. Shows only country name and flag
                            showCountryOnly: true,
                            // optional. Shows only country name and flag when popup is closed.
                            showOnlyCountryWhenClosed: false,
                            // optional. aligns the flag and the Text left
                            alignLeft: false,
                          ),
                          new Expanded(
                            child: TextField(
                              controller: newPhoneController,
                              keyboardType: TextInputType.numberWithOptions(
                                  signed: true, decimal: false),
                              maxLength: 8,
                              decoration: InputDecoration(
                                counterText: '',
                                border: InputBorder.none,
                                hintText: ' Phone Number',
                                hintStyle: TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white.withOpacity(0.5),
                          width: 1.0,
                        ),
                      ),
                      margin: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      child: Row(
                        children: <Widget>[
                          new Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 15.0),
                            child: Icon(
                              Icons.lock,
                              color: Colors.white,
                            ),
                          ),
                          new Expanded(
                            child: TextField(
                              controller: newPasswordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                counterText: '',
                                border: InputBorder.none,
                                hintText: 'Password',
                                hintStyle: TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 20.0),
                        padding: const EdgeInsets.only(left: 10.0, right: 00.0),
                        child: Row(children: <Widget>[
                          Column(
                            children: <Widget>[
                              Checkbox(
                                value: SignupPageCheckBox,
                                onChanged: (newValue) {
                                  setState(() {
                                    SignupPageCheckBox = newValue;
                                  });
                                },
                              ),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Container(
                                  child: InkWell(
                                onTap: () => _launchURL(),
                                // handle your onTap here
                                child: new RichText(
                                  softWrap: true,
                                  text: new TextSpan(
                                    children: [
                                      new TextSpan(
                                        text: 'I agree to the ',
                                        style: new TextStyle(
                                            color: Colors.white, fontSize: 10),
                                      ),
                                      new TextSpan(
                                        text: 'Terms & Conditions',
                                        style: new TextStyle(
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      new TextSpan(
                                        text: ' and ',
                                        style: new TextStyle(
                                            color: Colors.white, fontSize: 10),
                                      ),
                                      new TextSpan(
                                        text: 'Privacy Policy',
                                        style: new TextStyle(
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                            ],
                          ),
                        ])),
                    Container(
                      margin: const EdgeInsets.only(top: 20.0),
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: new Row(
                        children: <Widget>[
                          new Expanded(
                              child: new AutoSizeText(
                            "IMPORTANT:\nWe’re Doing our Best To Keep You Safe.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff388e3c)),
                          )),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20.0),
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: new Row(
                        children: <Widget>[
                          new Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: RoundedLoadingButton(
                                color: Colors.green,
                                child: Text('REGISTER!',
                                    style: TextStyle(color: Colors.white)),
                                controller: _btnController,
                                onPressed: _doSomething,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ))));
  }

  Widget SignupPage() {
    return Scaffold(
        resizeToAvoidBottomPadding: true,
        body: new SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
//              width: queryData.size.width, //MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xff31893d), Color(0xff96ed98)])),
              child: ListView(
                children: <Widget>[
                  new ClipPath(
                    child: Container(
                      margin: const EdgeInsets.only(top: 5.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                            image:
                                new ExactAssetImage("assets/images/logo.png"),
                            fit: BoxFit.contain),
                      ),
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(top: 180.0, bottom: 50.0),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white.withOpacity(0.5),
                        width: 1.0,
                      ),
                    ),
                    margin: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    child: Row(
                      children: <Widget>[
                        new Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 15.0),
                          child: Icon(
                            Icons.person_outline,
                            color: Colors.white,
                          ),
                        ),
                        new Expanded(
                          child: TextField(
                            maxLength: 50,
                            controller: emailController,
                            decoration: InputDecoration(
                              counterText: '',
                              border: InputBorder.none,
                              hintText: 'Email',
                              hintStyle: TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white.withOpacity(0.5),
                        width: 1.0,
                      ),
                    ),
                    margin: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    child: Row(
                      children: <Widget>[
                        new Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 15.0),
                          child: Icon(
                            Icons.lock,
                            color: Colors.white,
                          ),
                        ),
                        new Expanded(
                          child: TextField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Password',
                              hintStyle: TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20.0),
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: new Row(
                      children: <Widget>[
                        new Expanded(
                          child: FlatButton(
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(10.5)),
                            splashColor: Colors.white,
                            color: Color(0xff388e3c),
                            textColor: Colors.white,
                            child: Align(
                                alignment: Alignment.center,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      new Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: RoundedLoadingButton(
                                            color: Colors.green,
                                            child: Text('Login!',
                                                style: TextStyle(
                                                    color: Colors.white)),
                                            controller: _loginController,
                                            onPressed: logIn,
                                          ),
                                        ),
                                      ),
//                                      Container(
//                                          padding: const EdgeInsets.only(
//                                              right: 10.0)),
//                                      Text(
//                                        "LOGIN",
//                                        style: TextStyle(
//                                            fontSize: 20.0,
//                                            fontWeight: FontWeight.normal),
//                                      ),
                                    ])),
//                            onPressed: () => {
//                              logIn()
//                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: new Row(
                      children: <Widget>[
                        new Expanded(
                          child: FlatButton(
                            color: Colors.transparent,
                            child: Container(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(color: Color(0xff042c5c)),
                              ),
                            ),
                            onPressed: () => {forgotpass()},
                          ),
                        ),
                        new Expanded(
                          child: FlatButton(
                            color: Colors.transparent,
                            child: Container(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                "Privacy Policy",
                                style: TextStyle(
                                    color: Color(0xffff4e6a),
                                    fontFamily: 'Roboto'),
                              ),
                            ),
                            onPressed: () => {_launchURL()},
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )));
  }

  gotoLogin() {
    //controller_0To1.forward(from: 0.0);
    _controller.animateToPage(
      0,
      duration: Duration(milliseconds: 800),
      curve: Curves.bounceOut,
    );
  }

  gotoSignup() {
    //controller_minus1To0.reverse(from: 0.0);
    _controller.animateToPage(
      2,
      duration: Duration(milliseconds: 800),
      curve: Curves.bounceOut,
    );
  }

  PageController _controller =
      new PageController(initialPage: 1, viewportFraction: 1.0);

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controllerAnimation.value;
    return Container(
        height: MediaQuery.of(context).size.height,
        child: PageView(
          controller: _controller,
          physics: new AlwaysScrollableScrollPhysics(),
          children: <Widget>[LoginPage(), HomePage(), SignupPage()],
          scrollDirection: Axis.horizontal,
        ));
  }

  void signIn() async {
    if (newPasswordController.text.toString().length > 0 &&
        newUserNameController.text.toString().length > 0 &&
        newEmailController.text.toString().length > 0) {
      try {
        FirebaseUser user = (await FirebaseAuth.instance
                .createUserWithEmailAndPassword(
                    email: newEmailController.text.toString(),
                    password: newPasswordController.text.toString()))
            .user;

        saveValues(user);
      } catch (e) {
        if (e != null) {
          Fluttertoast.showToast(
              msg: e.message,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          print(e.message);
        } else {
          Fluttertoast.showToast(
              msg: 'Error',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      }
    } else {
      Fluttertoast.showToast(
          msg: 'Missing/Wrong Data',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  FirebaseDatabase database;

  DatabaseReference databaseReference;

  void saveValues(FirebaseUser CurrentUser) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    CurrentUser = await FirebaseAuth.instance.currentUser();

    databaseReference.child(User.key).set(User.toJson());

    prefs.setString("key", CurrentUser.uid);
    prefs.setString("name", newUserNameController.text.toString());
    prefs.setString("email", CurrentUser.email);
    prefs.setString("phone", code + newPhoneController.text.toString());
    prefs.setString("state", dropdownValue);
    prefs.setString("imageUrl",
        "https://firebasestorage.googleapis.com/v0/b/smart-lend-system.appspot.com/o/logo.png?alt=media&token=fb180f1c-372c-428b-ad40-78cb39e3c9c0");
    gotoSignup();
    _btnController.stop();
  }

  void logIn() async {
    if (emailController.text.toString().length > 0 &&
        passwordController.text.toString().length > 0 &&
        EmailValidator.validate(emailController.text.toString().trim())) {
      try {
        FirebaseUser user = (await FirebaseAuth.instance
                .signInWithEmailAndPassword(
                    email: emailController.text.trim().toString(),
                    password: passwordController.text.toString()))
            .user;

        if (user.isEmailVerified) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("login", "true");
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => tableViwe()));
        } else {
          showToast("Kindly verify your Email first!", Colors.black26);
        }
      } catch (e) {
        if (e != null) {
          Fluttertoast.showToast(
              msg: e.message,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          print(e.message);
        } else {
          Fluttertoast.showToast(
              msg: 'Error',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      }
    } else {
      Fluttertoast.showToast(
          msg: 'Missing Data',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    _loginController.stop();
  }

  user User;

  void _doSomething() async {
    message = "";

    if (SignupPageCheckBox) {
      if (newEmailController.text.trim().toString().length > 0 &&
          newPasswordController.text.toString().length > 0 &&
          newPhoneController.text.toString().length > 0 &&
          newUserNameController.text.toString().length > 0 &&
          dropdownValue.length > 0 &&
          !newPhoneController.text.toString().contains("-")) {
        validateEmail(newEmailController.text.trim().toString());
        print(validateStructure(newPasswordController.text.toString()));
        _phoneNumberValidator(newPhoneController.text.toString());
        if (message != "") {
          showToast(message, Colors.redAccent);
          _btnController.stop();
        } else {
          await auth
              .createUserWithEmailAndPassword(
                  email: newEmailController.text.trim().toString(),
                  password: newPasswordController.text.toString())
              .then((currentUser) => {
                    User = user(
                        currentUser.user.uid,
                        newUserNameController.text.toString(),
                        newEmailController.text.trim().toString(),
                        code + newPhoneController.text.toString(),
                        dropdownValue,
                        ""),
                    databaseReference.child(User.key).set(User.toJson()),
                    currentUser.user.sendEmailVerification(),
                    saveValues(currentUser.user),
                    _btnController.stop(),
                  })
              .catchError((err) => {
                    _btnController.stop(),
                    Fluttertoast.showToast(
                        msg: err.toString().split(",")[1].toString(),
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.CENTER,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0)
                  })
              .catchError((onError) => {
                    print(onError),
                    _btnController.stop(),
                  });
        }
      } else {
        showToast("Missing/Wrong Data!", Colors.red);
        _btnController.stop();
      }
    } else {
      showToast("Accept terms and Conditios!", Colors.red);
      _btnController.stop();
    }
  }

  void showToast(var Message, Color color) {
    Fluttertoast.showToast(
        msg: Message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  _launchURL() async {
    const url = 'https://smart-lend-system.web.app/terms.html';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  forgotpass() async {
    if (emailController.text.toString().length > 0) {
      if (EmailValidator.validate(emailController.text.trim().toString())) {
        Auth().sendPasswordResetMail(emailController.text.trim().toString());
        showToast("Reset Email Sent!", Colors.green);
      } else {
        showToast("Invalid Email!", Colors.red);
      }
    } else {
      showToast("Enter an Email!", Colors.red);
    }
  }

  var code = "+963";
  var message = "";

  void _onCountryChange(CountryCode countryCode) {
    code = countryCode.toString();
  }

  bool _phoneNumberValidator(String value) {
    if (value.length < 8) {
      message += "Number is Not Valid\n";
      return false;
    } else
      return true;
  }

  bool validateEmail(String value) {
    if (EmailValidator.validate(value)) {
      return true;
    } else {
      message = "Invalid Email\n";
      return false;
    }
  }

  bool validateStructure(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      message +=
          "Password is Not Valid\nShould Contain:1 Upper case\n1 lowercase\n1 Numeric Number\n1 Special Character";
      return false;
    } else
      return true;
  }
}
