//import 'package:firebase_database/firebase_database.dart';


import 'package:firebase_database/firebase_database.dart';

class SingleBank {
  SingleBank(this.name, this.loan, this.fees, this.intr, this.amount);
  String key="";
  String name="";
  String loan="";
  String fees="";
  String intr="";
  double amount=0.0;

  String getIntr(){
    return this.intr;
  }



void setAmount(double amout){
  this.amount=amout;
}

  SingleBank.fromSnapshot(DataSnapshot snapshot) {
    key = snapshot.key;
    name = snapshot.value['Name'];
    loan = snapshot.value['Loan'].toString()  ;
    fees =snapshot.value['fees'];
    intr = snapshot.value['intr'];
    amount =0;
  }
  toJson() {
    return {
      "Name": name,
      "Loan": loan,
      "fees": fees,
      "intr": intr,
    };
  }
}
