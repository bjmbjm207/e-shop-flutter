import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/uploadItems.dart';
import 'package:e_shop/Authentication/authenication.dart';
import 'package:e_shop/Authentication/login.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:flutter/material.dart';




class AdminLoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: new BoxDecoration(
            gradient: new LinearGradient(
            colors: [Colors.pink,Colors.lightGreenAccent],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 0.0),
            stops: [0.0,1.0],
            tileMode: TileMode.clamp,
            )
            ),
          ),
          title: Text(
            "e-shop",
            style: TextStyle(
              fontSize: 55.0,
              color: Colors.white,
              fontFamily: "Signatra",
            ),
        ),
          centerTitle: true,
      ),
      body: AdminLoginScreen(),
    );
  }
}

class AdminLoginScreen extends StatefulWidget {
  @override
  _AdminLoginScreenState createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _adminIDTextEditingController = TextEditingController();
  final TextEditingController _passwordTextEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery
        .of(context)
        .size
        .width,
        _screenHeight = MediaQuery
            .of(context)
            .size
            .height;
    return SingleChildScrollView(
      child: Container(
        decoration: new BoxDecoration(
            gradient: new LinearGradient(
              colors: [Colors.pink,Colors.lightGreenAccent],
              begin: Alignment.topRight,
              end: Alignment.topLeft,
            )
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                "images/admin.png",
                height: 240.0,
                width: 240.0,

              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Admin",
                style: TextStyle(color: Colors.white),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [

                  CustomTextField(
                    controller: _adminIDTextEditingController,
                    data: Icons.person,
                    hintText: "Your id",
                    isObsecure: false,
                  ),
                  CustomTextField(
                    controller: _passwordTextEditingController,
                    data: Icons.person,
                    hintText: "Password",
                    isObsecure: true,
                  ),

                ],

              ),
            ),
            RaisedButton(
              onPressed: () {
                _adminIDTextEditingController.text.isNotEmpty &&
                    _passwordTextEditingController.text.isNotEmpty
                    ? loginAdmin()
                    : showDialog(context: context,
                    builder: (c) {
                      return ErrorAlertDialog(
                        message: "Please write email and password",);
                    });
              },
              color: Colors.pink,
              child: Text(
                "Login",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 50.0,),
            Container(
              height: 4.0,
              width: _screenWidth * 0.8,
              color: Colors.pink,

            ),
            SizedBox(
              height: 10.0,
            ),
            FlatButton.icon(
              onPressed: () =>
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => AuthenticScreen()
                  )),
              icon: Icon(Icons.nature_people, color: Colors.pink,),
              label: Text("I'm not Admin", style: TextStyle(
                  color: Colors.pink, fontWeight: FontWeight.bold),),
            )
          ],
        ),
      ),
    );
  }
  loginAdmin(){
    Firestore.instance.collection("FakerDP").getDocuments().then((snapShot){
      snapShot.documents.forEach((element) {
        if(element.data["id"] != _adminIDTextEditingController.text.trim()){
          Scaffold.of(context).showSnackBar(SnackBar(content: Text("your id is correct."),));
        }
        else if(element.data["password"] != _passwordTextEditingController.text.trim()){
          Scaffold.of(context).showSnackBar(SnackBar(content: Text("your password is correct."),));
        }
        else {
          Scaffold.of(context).showSnackBar(SnackBar(content: Text("Welcome Dear Admin,"+element.data["name"]),));
          setState(() {
            _adminIDTextEditingController.text = "";
            _passwordTextEditingController.text = "";
          });

          Route route = MaterialPageRoute(builder: (c) => UploadPage());
          Navigator.pushReplacement(context, route);
        }
      });
    });
  }
}
