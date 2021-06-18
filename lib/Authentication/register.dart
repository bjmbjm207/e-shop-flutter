import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:e_shop/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Store/storehome.dart';
import 'package:e_shop/Config/config.dart';



class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}



class _RegisterState extends State<Register> {
  final TextEditingController _nameTextEditingController = TextEditingController();
  final TextEditingController _emailTextEditingController = TextEditingController();
  final TextEditingController _passwordTextEditingController = TextEditingController();
  final TextEditingController _rePasswordEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String userImageUrl = "";
  File _imageFile;


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
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: 10.0,),
            InkWell(
              onTap: () {_selectAndPickImage();},
              child: CircleAvatar(
                radius: _screenWidth * 0.15,
                backgroundColor: Colors.white,
                backgroundImage: _imageFile == null ? null : FileImage(
                    _imageFile),
                child: _imageFile == null
                    ? Icon(Icons.add_photo_alternate, size: _screenWidth * 0.15,
                  color: Colors.grey,) : null,
              ),
            ),
            SizedBox(height: 10.0,),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _nameTextEditingController,
                    data: Icons.person,
                    hintText: "Name",
                    isObsecure: false,
                  ),
                  CustomTextField(
                    controller: _emailTextEditingController,
                    data: Icons.email,
                    hintText: "Email",
                    isObsecure: false,
                  ),
                  CustomTextField(
                    controller: _passwordTextEditingController,
                    data: Icons.vpn_key,
                    hintText: "Password",
                    isObsecure: true,
                  ),
                  CustomTextField(
                    controller: _rePasswordEditingController,
                    data: Icons.vpn_key,
                    hintText: "Confirm Password",
                    isObsecure: true,
                  )
                ],

              ),
            ),
            RaisedButton(
              onPressed: (){_uploadAndSaveImage();},
              color: Colors.pink,
              child: Text(
                "Sign up",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 30.0,),
            Container(
              height: 4.0,
              width: _screenWidth * 0.8,
              color: Colors.pink,

            ),
            SizedBox(
              height: 15.0,
            )
          ],

        ),
      ),
    );
  }

  Future<void> _selectAndPickImage() async {
    _imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

  }

  Future<void> _uploadAndSaveImage() {
    if (_imageFile == null) {
      showDialog(context: context,
          builder: (c) {
            return ErrorAlertDialog(message: "Please select a image",);
          });
    }
    else {
      _passwordTextEditingController.text == _rePasswordEditingController.text
          ? _emailTextEditingController.text.isNotEmpty &&
          _passwordTextEditingController.text.isNotEmpty &&
          _rePasswordEditingController.text.isNotEmpty &&
          _nameTextEditingController.text.isNotEmpty
          ? uploadToStorage()

          : displayDialog("Please fill up the register complete form")

          : displayDialog("Password do not match.");
    }
  }

  displayDialog(String msg) {
    showDialog(context: context, builder: (c) {
      return ErrorAlertDialog(message: msg,);
    });
  }

  uploadToStorage() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlertDialog(message: "Authenticating, Please wait...",);
        });
    String imageFileName = DateTime
        .now()
        .microsecondsSinceEpoch
        .toString();

    firebase_storage.Reference storageReference = firebase_storage.FirebaseStorage.instance.ref().child(
        imageFileName);
    firebase_storage.UploadTask storageUploadTask = storageReference.putFile(_imageFile);
    firebase_storage.TaskSnapshot taskSnapshot = await storageUploadTask;

    await taskSnapshot.ref.getDownloadURL().then((urlImage) {
      userImageUrl = urlImage;
      _registerUser();
    });
  }

  FirebaseAuth _auth = FirebaseAuth.instance;

  void _registerUser() async {
    User firebaseUser;
    await _auth.createUserWithEmailAndPassword(
        email: _emailTextEditingController.text.trim(),
        password: _passwordTextEditingController.text.trim()
    ).then((auth) {
      firebaseUser = auth.user;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(context: context, builder: (c) {
        return ErrorAlertDialog(message: error.message.toString(),);
      });
    });
    if (firebaseUser != null) {
      saveUserInfoFireStore(firebaseUser).then((value) {
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (c) => StoreHome());
        Navigator.pushReplacement(context, route);
      });
    }
  }

  Future saveUserInfoFireStore(User firebaseUser) async {
    FirebaseFirestore.instance.collection("users").doc(firebaseUser.uid).set({
      "uid": firebaseUser.uid,
      "email": firebaseUser.email,
      "name": _nameTextEditingController.text.trim(),
      "url": userImageUrl,
      EcommerceApp.userCartList: ["garbageValue"],
    });
    await EcommerceApp.sharedPreferences.setString(
        EcommerceApp.userUID, firebaseUser.uid);
    await EcommerceApp.sharedPreferences.setString(
        EcommerceApp.userEmail, firebaseUser.email);
    await EcommerceApp.sharedPreferences.setString(
        EcommerceApp.userName, _nameTextEditingController.text.trim());
    await EcommerceApp.sharedPreferences.setString(
        EcommerceApp.userAvatarUrl, userImageUrl);
    await EcommerceApp.sharedPreferences.setStringList(
        EcommerceApp.userCartList, ["garbageValue"]);
  }
}


