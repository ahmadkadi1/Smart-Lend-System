import 'dart:async';
import 'dart:ui';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:data_tables/data_tables.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutterapp/Network/API%20Page.dart';
import 'package:flutterapp/authantication/authentication.dart';
import 'package:flutterapp/model/SingleBank.dart';
import 'package:flutterapp/Profile/profile.dart';
import 'package:flutterapp/authantication/mainLoginScreen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Constants.dart';

class tableViwe extends StatefulWidget {
  @override
  _tableViweState createState() => _tableViweState();
}

class _tableViweState extends State<tableViwe> {
  int _rowsPerPage = 100;
  int _sortColumnIndex;
  bool _sortAscending = true;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Query _todoQuery;
  StreamSubscription<Event> _onTodoAddedSubscription;
  StreamSubscription<Event> _onTodoChangedSubscription;
  bool showMobileListView = false;
  List<DropdownMenuItem> dropDownItems = new List();
  bool dialVisible = true;

  @override
  void initState() {
    _items = new List();
    setItemsDroppDown();
    _todoQuery = _database.reference().child("Banks");
    _onTodoAddedSubscription = _todoQuery.onChildAdded.listen(onEntryAdded);
    _onTodoChangedSubscription =
        _todoQuery.onChildChanged.listen(onEntryChanged);
    super.initState();
  }

  void setItemsDroppDown() {
    dropDownItems.add(DropdownMenuItem(
      child: Text('Car Loan'),
      value: 'Car Loan',
    ));

    dropDownItems.add(DropdownMenuItem(
      child: Text('University Loan'),
      value: 'University Loan',
    ));

    dropDownItems.add(DropdownMenuItem(
      child: Text('House Loan'),
      value: 'House Loan',
    ));

    dropDownItems.add(DropdownMenuItem(
      child: Text('Travel Loan'),
      value: 'Travel Loan',
    ));

    dropDownItems.add(DropdownMenuItem(
      child: Text("Wedding Loan"),
      value: "Wedding Loan",
    ));

    dropDownItems.add(DropdownMenuItem(
      child: Text("Personal Loan"),
      value: "Personal Loan",
    ));

    dropDownItems.add(DropdownMenuItem(
      child: Text("Land Loan"),
      value: "Land Loan",
    ));

    dropDownItems.add(DropdownMenuItem(
      child: Text("Specialized Personal Loan"),
      value: "Specialized Personal Loan",
    ));

    dropDownItems.add(DropdownMenuItem(
      child: Text("Doctor Personal Loan"),
      value: "Doctor Personal Loan",
    ));

    dropDownItems.add(DropdownMenuItem(
      child: Text("Business Loan"),
      value: "Business Loan",
    ));
  }

  @override
  void dispose() {
    _onTodoAddedSubscription.cancel();
    _onTodoChangedSubscription.cancel();
    super.dispose();
  }

  onEntryChanged(Event event) {
    var oldEntry = _items.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    setState(() {
      _items[_items.indexOf(oldEntry)] =
          SingleBank.fromSnapshot(event.snapshot);
    });
  }

  onEntryAdded(Event event) {
    setState(() {
      _items.add(SingleBank.fromSnapshot(event.snapshot));
    });
  }

  void calculatePayment(SingleBank singleBank, int p, int r, int n) {
    singleBank.setAmount(((((r / 100) * p) * (n / 12) + p)));

  }

  void _sort<T>(
      Comparable<T> getField(SingleBank d), int columnIndex, bool ascending) {
    _items.sort((SingleBank a, SingleBank b) {
      if (!ascending) {
        final SingleBank c = a;
        a = b;
        b = c;
      }
      final Comparable<T> aValue = getField(a);
      final Comparable<T> bValue = getField(b);
      return Comparable.compare(aValue, bValue);
    });
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  List<SingleBank> _items;
  TextEditingController amoountController = new TextEditingController();
  TextEditingController periodController = new TextEditingController();

  @override
  void didUpdateWidget(tableViwe oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  int _rowsOffset = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.green[800],
        accentColor: Colors.green[600],
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: new Text("Smart Lend System"),
          actions: <Widget>[
            PopupMenuButton<String>(
                onSelected: choiceAction,
                icon: Icon(Icons.account_circle),
                itemBuilder: (BuildContext context) {
                  return Constants.choices.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(
                        choice,
                        style: TextStyle(color: Colors.green),
                      ),
                    );
                  }).toList();
                }),
          ],
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          textTheme: TextTheme(
              title: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          )),
        ),
        body: NativeDataTable.builder(
          rowsPerPage: _rowsPerPage,
          itemCount: _items?.length ?? 0,
          firstRowIndex: _rowsOffset,
          handleNext: () async {
            setState(() {
              _rowsOffset += _rowsPerPage;
            });
          },
          handlePrevious: () {
            setState(() {
              _rowsOffset -= _rowsPerPage;
            });
          },
          noItems: Text("No Items Found"),
          itemBuilder: (int index) {
            final SingleBank dessert = _items[index];
            return DataRow.byIndex(index: index, cells: <DataCell>[
              DataCell(Text('${dessert.name}',
                  style: TextStyle(color: Colors.green))),
              DataCell(Text('${dessert.loan}')),
              DataCell(Text('${dessert.intr}')),
              DataCell(Text('${dessert.fees}')),
              DataCell(Text('${dessert.amount.roundToDouble()}',
                  style: TextStyle(color: Colors.blue))),
            ]);
          },
          header: const Text(
            'Available Banks',
            style: TextStyle(fontSize: 25, color: Colors.green),
          ),
          sortColumnIndex: _sortColumnIndex,
          sortAscending: _sortAscending,
          alwaysShowDataTable: true,
          onRefresh: () async {
            _items.clear();
            _todoQuery = _database.reference().child("Banks");
            _onTodoAddedSubscription =
                _todoQuery.onChildAdded.listen(onEntryAdded);
            _onTodoChangedSubscription =
                _todoQuery.onChildChanged.listen(onEntryChanged);
            setState(() {
              _items = _items;
            });
            return null;
          },
          actions: <Widget>[],
          columns: <DataColumn>[
            DataColumn(
                label: const Text('Bank Name',
                    style: TextStyle(color: Colors.green)),
                onSort: (int columnIndex, bool ascending) => _sort<String>(
                    (SingleBank d) => d.name, columnIndex, ascending)),
            DataColumn(
                label: const Text('Loan Type'),
                numeric: true,
                onSort: (int columnIndex, bool ascending) => _sort<String>(
                    (SingleBank d) => d.loan, columnIndex, ascending)),
            DataColumn(
                label: const Text('Interest Rate'),
                numeric: true,
                onSort: (int columnIndex, bool ascending) => _sort<num>(
                    (SingleBank d) => int.parse(d.intr),
                    columnIndex,
                    ascending)),
            DataColumn(
                label: const Text('File Fees'),
                numeric: true,
                onSort: (int columnIndex, bool ascending) => _sort<num>(
                    (SingleBank d) => int.parse(d.fees),
                    columnIndex,
                    ascending)),
            DataColumn(
                label: const Text('Final Loan Payment',
                    style: TextStyle(color: Colors.blue)),
                numeric: true,
                onSort: (int columnIndex, bool ascending) => _sort<num>(
                    (SingleBank d) => d.amount, columnIndex, ascending)),
          ],
        ),
        floatingActionButton: buildSpeedDial(),
      ),
    );
  }

  String dropdownValue = "Car Loan";

  _displayDialog(BuildContext context) async {
    AwesomeDialog(
      headerAnimationLoop: true,
      aligment: Alignment.topCenter,
      context: context,
      animType: AnimType.RIGHSLIDE,
      customHeader: Icon(
        Icons.attach_money,
        size: 50,
        color: Colors.green,
      ),
      body: Column(
        verticalDirection: VerticalDirection.down,
        children: <Widget>[
          Text(
            'Loan Search',
            style: TextStyle(color: Colors.black),
          ),
          new Container(
            alignment: Alignment.centerLeft,
            width: double.infinity,
            child: SearchableDropdown.single(
              items: dropDownItems,
              value: dropdownValue,
              underline: Container(
                height: 2,
                color: Colors.green,
              ),
              hint: "Select one",
              searchHint: "Select Loan",
              onChanged: (value) {
                setState(() {
                  dropdownValue = value;
                });
              },
              isExpanded: true,
            ),
          ),
          new TextField(
            controller: amoountController,
            maxLength: 12,
            keyboardType:
                TextInputType.numberWithOptions(signed: true, decimal: false),
            decoration: new InputDecoration(
                labelText: 'Amout', hintText: "eg. 15000 USD"),
          ),
          new TextField(
            maxLength: 12,
            controller: periodController,
            keyboardType:
                TextInputType.numberWithOptions(signed: true, decimal: false),
            decoration:
                new InputDecoration(labelText: 'Period', hintText: 'eg. 14Mo'),
          ),
        ],
      ),
      btnCancel: FlatButton(
        child: Text('Cancle'),
        color: Colors.red,
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      btnOk: FlatButton(
        child: Text('Search'),
        color: Colors.green,
        onPressed: () {
          if (amoountController.text.toString().length > 0 &&
              periodController.text.toString().length > 0 &&
              !amoountController.text.toString().contains("-") &&
              !periodController.text.toString().contains("-")) {
            _items.clear();
            _todoQuery = _database
                .reference()
                .child("Banks")
                .orderByChild("Loan")
                .equalTo(dropdownValue);

            _onTodoAddedSubscription =
                _todoQuery.onChildAdded.listen(onEntryAdded);
            _onTodoChangedSubscription =
                _todoQuery.onChildChanged.listen(onEntryChanged);

            Future.delayed(const Duration(milliseconds: 2000), () {
              int amount = 0;
              int period = 0;
              if (amoountController.text.toString() != null &&
                  periodController.text.toString() != null) {
                amount = int.parse(amoountController.text.toString());

                period = int.parse(periodController.text.toString());
                for (var row in _items) {
                  calculatePayment(
                      row, amount, int.parse(row.getIntr().toString()), period);
                }
              }
              _sort<num>((SingleBank d) => d.amount, 0, true);
            });
            Navigator.of(context).pop();
          } else {
            showToast("Missing/Wrong Data!", Colors.red);
          }
        },
      ),
    ).show();
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

  SpeedDial buildSpeedDial() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      backgroundColor: Colors.green[800],
      animatedIconTheme: IconThemeData(size: 22.0),
      // child: Icon(Icons.add),
      onOpen: () => print('OPENING DIAL'),
      onClose: () => print('DIAL CLOSED'),
      visible: dialVisible,
      curve: Curves.bounceIn,
      children: [
        SpeedDialChild(
          child: Icon(Icons.search, color: Colors.white),
          backgroundColor: Colors.green,
          onTap: () => {
            _displayDialog(context),
          },
          label: 'Search Loan',
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.green,
        ),
        SpeedDialChild(
          child: Icon(Icons.account_balance, color: Colors.white),
          backgroundColor: Colors.lightGreen,
          onTap: () => {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => APIPage())),
          },
          label: 'Predict Loan',
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.lightGreen,
        ),
      ],
    );
  }

  Future<void> choiceAction(String choice) async {
    if (choice == Constants.FirstItem) {
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new ProfilePage()));
    } else if (choice == Constants.SecondItem) {
      Auth().signOut();
      SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setString("key", "");
      prefs.setString("name", "");
      prefs.setString("email", "");
      prefs.setString("phone", "");
      prefs.setString("state", "");
      prefs.setString("imageUrl",
          "https://firebasestorage.googleapis.com/v0/b/smart-lend-system.appspot.com/o/logo.png?alt=media&token=fb180f1c-372c-428b-ad40-78cb39e3c9c0");
      prefs.setString("login", "false");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen3()));
    }
  }
}
