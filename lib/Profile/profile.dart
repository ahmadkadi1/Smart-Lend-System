import 'dart:async';
import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/authantication/authentication.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/user.dart';

class ProfilePage extends StatefulWidget {
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  List<String> _items = ['Student', 'Employee', 'Self Employed'];
  String dropdownValue = 'Student';
  bool _status = true;
  user currentUser;
  FirebaseDatabase database;
  String profilePic =
      "https://firebasestorage.googleapis.com/v0/b/smart-lend-system.appspot.com/o/logo.png?alt=media&token=fb180f1c-372c-428b-ad40-78cb39e3c9c0";
  final FocusNode myFocusNode = FocusNode();
  TextEditingController name = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController mobile = new TextEditingController();

  @override
  void initState() {
    database = FirebaseDatabase.instance;
    databaseReference = database.reference().child("users");
    readUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: new CupertinoNavigationBar(
              backgroundColor: Colors.green[800],
              middle: new Text('Manage your Profile'),
            ),
            body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.white,
              child: new ListView(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      new Container(
                        height: 250.0,
                        color: Colors.white,
                        child: new Column(
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.only(left: 10.0, top: 20.0),
                                child: new Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(left: 25.0),
                                      child: new Text('PROFILE',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20.0,
                                              fontFamily: 'sans-serif-light',
                                              color: Colors.black)),
                                    )
                                  ],
                                )),
                            Padding(
                              padding: EdgeInsets.only(top: 20.0),
                              child: new Stack(
                                  fit: StackFit.loose,
                                  children: <Widget>[
                                    new Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        new CircleAvatar(
                                            radius: 65,
//                                width: 140.0,
//                                height: 140.0,
//                                decoration: new (
                                            backgroundColor: Colors.green,
                                            backgroundImage: new NetworkImage(
                                              profilePic,
                                            )
//                                  shape: BoxShape.circle,
//                                  image: new DecorationImage(
//                                    image: new ExactAssetImage(
//                                        currentUser.imgURL),
//                                    fit: BoxFit.cover,
                                            ),
                                      ],
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(
                                            top: 90.0, right: 100.0),
                                        child: new Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            new CircleAvatar(
                                              backgroundColor: Colors.red,
                                              radius: 25.0,
                                              child: new IconButton(
                                                icon: new Icon(
                                                  Icons.camera_alt,
                                                  color: Colors.white,
                                                ),
                                                onPressed: () {
                                                  getImage();
                                                },
                                              ),
                                            )
                                          ],
                                        )),
                                  ]),
                            )
                          ],
                        ),
                      ),
                      new Container(
                        color: Color(0xffFFFFFF),
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 25.0),
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 25.0),
                                  child: new Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          new Text(
                                            'Personal Information',
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      new Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          _status
                                              ? _getEditIcon()
                                              : new Container(),
                                        ],
                                      )
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 25.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          new Text(
                                            'Name',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 2.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Flexible(
                                        child: new TextField(
                                          controller: name,
                                          maxLength: 15,
                                          decoration: InputDecoration(
                                            //
                                            hintText: "Enter Your Name",
                                          ),
                                          enabled: !_status,
                                          autofocus: !_status,
                                        ),
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 25.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          new Text(
                                            'Email ID',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 2.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Flexible(
                                        child: new TextField(
                                          controller: email,
                                          maxLength: 30,
                                          decoration: InputDecoration(
                                              hintText: "Enter Email ID"),
                                          enabled: !_status,
                                        ),
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 25.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          new Text(
                                            'Mobile',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 2.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Flexible(
                                        child: new TextField(
                                          keyboardType:
                                              TextInputType.numberWithOptions(
                                                  signed: true, decimal: false),
                                          controller: mobile,
                                          maxLength: 12,
                                          decoration: InputDecoration(
                                              hintText: "Enter Mobile Number"),
                                          enabled: !_status,
                                        ),
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 25.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          child: new Text(
                                            'State',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        flex: 2,
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 2.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Flexible(
                                        child: DropdownButton<String>(
                                          hint: Text('Select a status'),
                                          isExpanded: true,
                                          value: dropdownValue,
                                          icon: Icon(
                                            Icons.arrow_downward,
                                            color: Color(0xffFD6D84),
                                          ),
                                          iconSize: 20,
                                          elevation: 16,
                                          style: TextStyle(color: Colors.white),
                                          onChanged: (String value) {
                                            setState(() {
                                              dropdownValue = value;
                                            });
                                          },
                                          items: _items
                                              .map<DropdownMenuItem<String>>(
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
                                        flex: 2,
                                      ),
                                    ],
                                  )),
                              !_status ? _getActionButtons() : new Container(),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )));
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  getProfileimage() async {
    return (currentUser.imgURL != null ? " currentUser.imgURL" : profilePic);
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text("Save"),
                textColor: Colors.white,
                color: Colors.green,
                onPressed: () {
                  setState(() {
                    _status = true;
                    updateData();
                  });
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text("Reset PWD"),
                textColor: Colors.white,
                color: Colors.blueGrey,
                onPressed: () {
                  setState(() {
                    if (email.text.toString().length > 0) {
                      if (EmailValidator.validate(
                          email.text.trim().toString())) {
                        Auth auth = new Auth();
                        auth.sendPasswordResetMail(
                            email.text.trim().toString());
                        showToast("Reset Email Sent!", Colors.green);
                        _status = true;
                        FocusScope.of(context).requestFocus(new FocusNode());
                      }
                      {
                        showToast("Email is not valid!", Colors.red);
                      }
                    } else {
                      showToast("Enter an Email!", Colors.red);
                    }
                  });
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text("Cancel"),
                textColor: Colors.white,
                color: Colors.red,
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Colors.red,
        radius: 14.0,
        child: new Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }

  File image;

  Future getImage() async {
    File picture = (await ImagePicker.pickImage(
        source: ImageSource.gallery, maxWidth: 300.0, maxHeight: 500.0));
    setState(() {
      image = picture;
      uploadimage();
    });
  }

  Future<void> uploadimage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (image != null) {
      showToast("Please Wait!", Colors.black12);
      final StorageReference firebaseStorageRef =
          FirebaseStorage.instance.ref().child(randomAlpha(5) + '.jpg');

      final StorageUploadTask uploadTask = firebaseStorageRef.putFile(image);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      currentUser.setIMG(await taskSnapshot.ref.getDownloadURL());
      setState(() {
        profilePic = currentUser.imgURL;
        currentUser.imgURL = profilePic;
        prefs.setString("imageUrl", profilePic);
      });
      databaseReference.child(currentUser.key).set(currentUser.toJson());
    }
  }

  static final FirebaseDatabase firebaseDatabase = new FirebaseDatabase();

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = await Auth().getCurrentUserID();

    prefs.setString("key", id);
    prefs.setString("name", currentUser.fname);
    prefs.setString("email", currentUser.email);
    prefs.setString("phone", currentUser.phone);
    prefs.setString("state", currentUser.state);
    setState(() {
      name.text = prefs.get("name");
      mobile.text = prefs.get("phone");
      dropdownValue = prefs.get("state");
      email.text = prefs.get("email");
      if (prefs.get("imageUrl") != null) {
        currentUser.imgURL = prefs.get("imageUrl");
        profilePic = prefs.get("imageUrl");
      }
    });
  }

  DatabaseReference databaseReference;

  updateData() async {
    if (name.text.toString().length > 0 &&
        email.text.toString().length > 0 &&
        mobile.text.toString().length == 12 &&
        dropdownValue.length > 0 &&
        !mobile.text.toString().contains("-")) {
      if (EmailValidator.validate(email.text.trim().toString())) {
        databaseReference.child(currentUser.key).set(user(
                currentUser.key,
                name.text.toString(),
                email.text.toString(),
                mobile.text.toString(),
                dropdownValue,
                currentUser.imgURL)
            .toJson());
        showToast("Data updated!", Colors.green);
        readUserData();
        FocusScope.of(context).requestFocus(new FocusNode());
      } else {
        showToast("Email is not valid!", Colors.red);
      }
    } else {
      showToast("Missing/Wrong Data!", Colors.red);
    }
  }

  readUserData() async {
    String id = await Auth().getCurrentUserID();

    await FirebaseDatabase.instance
        .reference()
        .child('users/$id')
        .once()
        .then((snapshot) {
      currentUser = user.fromSnapshot(snapshot);
      print(snapshot.value);
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("key", id);
    prefs.setString("name", currentUser.fname);
    prefs.setString("email", currentUser.email);
    prefs.setString("phone", currentUser.phone);
    prefs.setString("state", currentUser.state);
    getData();
  }

  void showToast(var message, Color color) {
    assert(message != null);
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
