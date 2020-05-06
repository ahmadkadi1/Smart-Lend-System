import 'package:firebase_database/firebase_database.dart';


class user {
  String key;
  String fname;
  String email;
  String phone;
  String state;
  String imgURL="https://firebasestorage.googleapis.com/v0/b/smart-lend-system.appspot.com/o/logo.png?alt=media&token=fb180f1c-372c-428b-ad40-78cb39e3c9c0";
  user(this.key,this.fname, this.email,this.phone,this.state, this.imgURL);
  user.fromSnapshot(DataSnapshot snapshot) :
        key = snapshot.key,
        fname = snapshot.value["fname"],
        email=snapshot.value["email"],
        phone=snapshot.value["phone"],
        state=snapshot.value["state"],
      imgURL=snapshot.value["imgURL"];

  String getFName(){
    return this.fname;
  }


  String getStatee(){
    return this.state;
  }
  String getIMG(){
    return this.imgURL;
  }

  void setIMG(String image){
    this.imgURL = image;
  }
  String getPhone(){
    return this.phone;
  }
  String getEmail(){
    return this.email;
  }

  toJson() {
    return {
      "fname": fname,
      "email": email,
      "phone": phone,
      "state": state,
      "imgURL": imgURL,
    };
  }



}