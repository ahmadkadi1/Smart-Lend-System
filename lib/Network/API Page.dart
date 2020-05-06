import 'dart:async';
import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import 'API.dart';

class APIPage extends StatefulWidget {
  @override
  _APIPageState createState() => _APIPageState();
}

class _APIPageState extends State<APIPage> {
  String url;
  var data;
  String queryText = '';
  int currStep = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.green[800],
        accentColor: Colors.green[600],
      ),
      home: Scaffold(
        appBar: new CupertinoNavigationBar(
          backgroundColor: Colors.green[800],
          middle: new Text('Loan Prediction'),
        ),
        resizeToAvoidBottomInset: true,
        resizeToAvoidBottomPadding: false,
        body: Scrollbar(
            child: ListView(
          children: <Widget>[
//            Padding(
//              padding: const EdgeInsets.all(10.0),
//              child: TextField(
//                onChanged: (value) {
//                  url = 'http://localhost:5000/api?Q=' + value.toString();
//                },
//                  maxLength: 10,
            //           decoration: InputDecoration(
//                    hintText: 'Search Anything Here',
//                    suffixIcon: GestureDetector(
//                        onTap: () async {
//                          data = await Getdata(url);
//                          var decodeddata = jsonDecode(data);
//                          setState(() {
//                            queryText = decodeddata['Query'];
//                          });
//                        },
//                        child: Icon(Icons.search))),
//              ),
//            ),

            Padding(
              padding: const EdgeInsets.only(right: 30.0),
              child: Scrollbar(
                  child: Stepper(
                physics: ClampingScrollPhysics(),
                type: StepperType.vertical,
                currentStep: this.currStep,
                onStepContinue: () {
                  setState(() {
                    if (currStep < 10) {
                      currStep = currStep + 1;
                    } else {
                      currStep = 0;
                    }
                    // else {
                    // Scaffold
                    //     .of(context)
                    //     .showSnackBar(new SnackBar(content: new Text('$currStep')));

                    // if (currStep == 1) {
                    //   print('First Step');
                    //   print('object' + FocusScope.of(context).toStringDeep());
                    // }

                    // }
                  });
                },
                onStepCancel: () {
                  setState(() {
                    if (currStep > 0) {
                      currStep = currStep - 1;
                    } else {
                      currStep = 0;
                    }
                  });
                },
                onStepTapped: (step) {
                  setState(() {
                    currStep = step;
                  });
                },
                steps: [
                  new Step(
                      title: const Text(
                        'Gender',
                        style: TextStyle(color: Colors.green),
                      ),
                      //subtitle: const Text('Enter your name'),
                      isActive: false,
                      //state: StepState.error,
                      state: StepState.indexed,
                      content: Column(
                        children: <Widget>[
                          _myRadioButton(
                            title: "Male",
                            group: _Gender,
                            value: 0,
                            onChanged: (newValue) =>
                                setState(() => _Gender = newValue),
                          ),
                          _myRadioButton(
                            title: "Female",
                            value: 1,
                            group: _Gender,
                            onChanged: (newValue) =>
                                setState(() => _Gender = newValue),
                          ),
                        ],
                      )),
                  new Step(
                      title: const Text(
                        'Married',
                        style: TextStyle(color: Colors.green),
                      ),
                      //subtitle: const Text('Enter your name'),
                      isActive: false,
                      //state: StepState.error,
                      state: StepState.indexed,
                      content: Column(
                        children: <Widget>[
                          _myRadioButton(
                            title: "Yes",
                            group: _Married,
                            value: 0,
                            onChanged: (newValue) =>
                                setState(() => _Married = newValue),
                          ),
                          _myRadioButton(
                            title: "No",
                            value: 1,
                            group: _Married,
                            onChanged: (newValue) =>
                                setState(() => _Married = newValue),
                          ),
                        ],
                      )),
                  new Step(
                      title: const Text('Number of children',
                          style: TextStyle(color: Colors.green)),
                      // subtitle: const Text('Subtitle'),
                      isActive: false,
                      state: StepState.indexed,
                      // state: StepState.disabled,
                      content: Column(
                        children: <Widget>[
                          _myRadioButton(
                            title: "0",
                            group: _Children,
                            value: 0,
                            onChanged: (newValue) =>
                                setState(() => _Children = newValue),
                          ),
                          _myRadioButton(
                            title: "1",
                            group: _Children,
                            value: 1,
                            onChanged: (newValue) =>
                                setState(() => _Children = newValue),
                          ),
                          _myRadioButton(
                            title: "2",
                            value: 2,
                            group: _Children,
                            onChanged: (newValue) =>
                                setState(() => _Children = newValue),
                          ),
                          _myRadioButton(
                            title: "3+",
                            value: 3,
                            group: _Children,
                            onChanged: (newValue) =>
                                setState(() => _Children = newValue),
                          ),
                        ],
                      )),
                  new Step(
                      title: const Text(
                        'Applicant Education',
                        style: TextStyle(color: Colors.green),
                      ),
                      //subtitle: const Text('Enter your name'),
                      isActive: false,
                      //state: StepState.error,
                      state: StepState.indexed,
                      content: Column(
                        children: <Widget>[
                          _myRadioButton(
                            title: "Graduate",
                            group: _Education,
                            value: 0,
                            onChanged: (newValue) =>
                                setState(() => _Education = newValue),
                          ),
                          _myRadioButton(
                            title: "Under Graduate",
                            value: 1,
                            group: _Education,
                            onChanged: (newValue) =>
                                setState(() => _Education = newValue),
                          ),
                        ],
                      )),
                  new Step(
                      title: const Text(
                        'Self employed',
                        style: TextStyle(color: Colors.green),
                      ),
                      //subtitle: const Text('Enter your name'),
                      isActive: false,
                      //state: StepState.error,
                      state: StepState.indexed,
                      content: Column(
                        children: <Widget>[
                          _myRadioButton(
                            title: "Yes",
                            group: _SelfEmployed,
                            value: 0,
                            onChanged: (newValue) =>
                                setState(() => _SelfEmployed = newValue),
                          ),
                          _myRadioButton(
                            title: "No",
                            value: 1,
                            group: _SelfEmployed,
                            onChanged: (newValue) =>
                                setState(() => _SelfEmployed = newValue),
                          ),
                        ],
                      )),
                  new Step(
                      title: const Text('Applicant Income(USD)',
                          style: TextStyle(color: Colors.green)),
                      // subtitle: const Text('Subtitle'),
                      isActive: false,
                      state: StepState.indexed,
                      content: new TextFormField(
                        keyboardType: TextInputType.numberWithOptions(
                            signed: true, decimal: false),
                        autocorrect: false,
                        controller: salary,
                        maxLines: 1,
                        maxLength: 10,
                        decoration: InputDecoration(
                            labelText: 'Enter your Applicant Income(USD)',
                            hintText: 'Enter Applicant Income(USD)',
                            icon: const Icon(
                              Icons.explicit,
                              color: Colors.green,
                            ),
                            fillColor: Colors.green,
                            focusColor: Colors.green,
                            hoverColor: Colors.green,
                            labelStyle: new TextStyle(
                                color: Colors.green,
                                decorationColor: Colors.green,
                                decorationStyle: TextDecorationStyle.solid)),
                      )),
                  new Step(
                      title: const Text('Coapplicant Income(USD)',
                          style: TextStyle(color: Colors.green)),
                      // subtitle: const Text('Subtitle'),
                      isActive: false,
                      state: StepState.indexed,
                      content: new TextFormField(
                        keyboardType: TextInputType.numberWithOptions(
                            signed: true, decimal: false),
                        autocorrect: false,
                        controller: income,
                        maxLines: 1,
                        onSaved: (String value) {},
                        maxLength: 10,
                        decoration: InputDecoration(
                            labelText: 'Enter your Coapplicant Income(USD)',
                            hintText: 'Enter Coapplicant Income(USD)',
                            icon: const Icon(
                              Icons.explicit,
                              color: Colors.green,
                            ),
                            fillColor: Colors.green,
                            focusColor: Colors.green,
                            hoverColor: Colors.green,
                            labelStyle: new TextStyle(
                                color: Colors.green,
                                decorationColor: Colors.green,
                                decorationStyle: TextDecorationStyle.solid)),
                      )),
                  new Step(
                      title: const Text('Loan Amount(USD)',
                          style: TextStyle(color: Colors.green)),
                      // subtitle: const Text('Subtitle'),
                      isActive: false,
                      state: StepState.indexed,
                      content: new TextFormField(
                        keyboardType: TextInputType.numberWithOptions(
                            signed: true, decimal: false),
                        cursorColor: Colors.green,
                        autocorrect: false,
                        controller: amount,
                        maxLines: 1,
                        onSaved: (String value) {},
                        maxLength: 10,
                        decoration: InputDecoration(
                            labelText: 'Enter your Loan Amount(USD)',
                            hintText: 'Enter Loan Amount(USD)',
                            icon: const Icon(
                              Icons.attach_money,
                              color: Colors.green,
                            ),
                            fillColor: Colors.green,
                            focusColor: Colors.green,
                            hoverColor: Colors.green,
                            labelStyle: new TextStyle(
                                color: Colors.green,
                                decorationColor: Colors.green,
                                decorationStyle: TextDecorationStyle.solid)),
                      )),
                  new Step(
                      title: const Text('Loan Amount Term in months',
                          style: TextStyle(color: Colors.green)),
                      // subtitle: const Text('Subtitle'),
                      isActive: false,
                      state: StepState.indexed,
                      content: new TextFormField(
                        keyboardType: TextInputType.numberWithOptions(
                            signed: true, decimal: false),
                        controller: months,
                        autocorrect: false,
                        maxLines: 1,
                        onSaved: (String value) {},
                        decoration: new InputDecoration(
                            labelText: 'Enter Loan Amount Term in months',
                            hintText: 'Enter Loan Amount Term in months',
                            icon: const Icon(
                              Icons.explicit,
                              color: Colors.green,
                            ),
                            fillColor: Colors.green,
                            focusColor: Colors.green,
                            hoverColor: Colors.green,
                            labelStyle: new TextStyle(
                                color: Colors.green,
                                decorationColor: Colors.green,
                                decorationStyle: TextDecorationStyle.solid)),
                      )),
                  new Step(
                      title: const Text('Credit History ',
                          style: TextStyle(color: Colors.green)),
                      // subtitle: const Text('Subtitle'),
                      isActive: false,
                      state: StepState.indexed,
                      content: Column(
                        children: <Widget>[
                          _myRadioButton(
                            title: "Paid Pre-Loan",
                            group: _CreditHistory,
                            value: 0,
                            onChanged: (newValue) =>
                                setState(() => _CreditHistory = newValue),
                          ),
                          _myRadioButton(
                            title: "Did not Pay Pre-loan",
                            value: 1,
                            group: _CreditHistory,
                            onChanged: (newValue) =>
                                setState(() => _CreditHistory = newValue),
                          ),
                        ],
                      )),
                  new Step(
                      title: const Text('Property Area ',
                          style: TextStyle(color: Colors.green)),
                      // subtitle: const Text('Subtitle'),
                      isActive: false,
                      state: StepState.indexed,
                      content: Column(
                        children: <Widget>[
                          _myRadioButton(
                            title: "Urban",
                            group: _PropertyArea,
                            value: 1,
                            onChanged: (newValue) =>
                                setState(() => _PropertyArea = newValue),
                          ),
                          _myRadioButton(
                            title: "Semi Urban",
                            group: _PropertyArea,
                            value: 2,
                            onChanged: (newValue) =>
                                setState(() => _PropertyArea = newValue),
                          ),
                          _myRadioButton(
                            title: "Rural",
                            group: _PropertyArea,
                            value: 3,
                            onChanged: (newValue) =>
                                setState(() => _PropertyArea = newValue),
                          ),
                        ],
                      )),
                  // new Step(
                  //     title: const Text('Fifth Step'),
                  //     subtitle: const Text('Subtitle'),
                  //     isActive: false,
                  //     state: StepState.complete,
                  //     content: const Text('Enjoy Step Fifth'))
                ],
              )),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: RoundedLoadingButton(
                color: Colors.green,
                child:
                    Text('Check Loan!', style: TextStyle(color: Colors.white)),
                controller: _btnController,
                onPressed: _doSomething,
              ),
            ),
          ],
        )),
      ),
    );
  }

  void _doSomething() async {
    url = 'http://localhost:5000/api?';
    print("yooo " +
        _Gender.toString() +
        " " +
        _Married.toString() +
        " " +
        _Children.toString() +
        " " +
        _Education.toString() +
        " " +
        _SelfEmployed.toString() +
        " " +
        _PropertyArea.toString() +
        " " +
        _CreditHistory.toString() +
        " " +
        amount.text.toString().length.toString() +
        " " +
        income.text.toString().length.toString() +
        " " +
        salary.text.toString().length.toString() +
        " " +
        months.text.toString().length.toString());
    if (_Gender >= 0 &&
        _Married >= 0 &&
        _Children >= 0 &&
        _Education >= 0 &&
        _SelfEmployed >= 0 &&
        _PropertyArea >= 0 &&
        _CreditHistory >= 0 &&
        amount.text.toString().length > 0 &&
        income.text.toString().length > 0 &&
        salary.text.toString().length > 0 &&
        months.text.toString().length > 0 &&
        !amount.text.toString().contains("-") &&
        !income.text.toString().contains("-") &&
        !salary.text.toString().contains("-") &&
        !months.text.toString().contains("-")) {
      if (_CreditHistory == 0) {
        showToast("Connecting To The Server!", Colors.black26);

        if (_Married == 0) {
          url += 'Married=yes&';
        } else {
          url += 'Married=no&';
        }

        url += 'loanAmount=' +
            amount.text.toString() +
            '&months=' +
            months.text.toString() +
            '&income=' +
            (int.parse(salary.text.toString()) * 0.30).toString();
        data = await getdata(url);
        {
          Timer(Duration(seconds: 10), () {
            var decodeddata = jsonDecode(data);
            setState(() {
              queryText = decodeddata['Query'];
              if (queryText == 'Yes') {
                AwesomeDialog(
                    context: context,
                    animType: AnimType.LEFTSLIDE,
                    headerAnimationLoop: false,
                    dialogType: DialogType.SUCCES,
                    tittle: 'Loan Status',
                    desc: 'Loan Accepted',
                    btnOkOnPress: () {
                      debugPrint('OnClcik');
                    },
                    btnOkIcon: Icons.check_circle,
                    onDissmissCallback: () {
                      debugPrint('Dialog Dissmiss from callback');
                    }).show();
                _btnController.success();
              } else {
                AwesomeDialog(
                        context: context,
                        dialogType: DialogType.ERROR,
                        animType: AnimType.RIGHSLIDE,
                        headerAnimationLoop: false,
                        tittle: 'Loan Status',
                        desc: 'Loan Rejected',
                        btnOkOnPress: () {},
                        btnOkColor: Colors.red)
                    .show();
                _btnController.error();
              }
            });
          });
        }
      } else {
        _btnController.stop();
        showToast("Pay Your Old Loan First!", Colors.red);
      }
    } else {
      _btnController.stop();
      showToast("Missing/Wrong data!", Colors.red);
    }
  }

  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();

  int _Gender = -1;
  int _Married = -1;
  int _Children = -1;
  int _Education = -1;
  int _SelfEmployed = -1;
  int _PropertyArea = -1;
  int _CreditHistory = -1;

  TextEditingController amount = new TextEditingController();
  TextEditingController income = new TextEditingController();
  TextEditingController salary = new TextEditingController();
  TextEditingController months = new TextEditingController();

  Widget _myRadioButton(
      {String title, int value, int group, Function onChanged}) {
    return RadioListTile(
      value: value,
      groupValue: group,
      onChanged: onChanged,
      title: Text(title),
    );
  }

  void showToast(var message, Color color) {
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
