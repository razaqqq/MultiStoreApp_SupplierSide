import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_store_app_supplier/profiders/authentication_repository.dart';

import '../widgets/auth_widget.dart';
import '../widgets/snackbar_widget.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storeage;

class SuplierSignUp extends StatefulWidget {
  const SuplierSignUp({super.key});

  @override
  State<SuplierSignUp> createState() => _SuplierSignUpState();
}

class _SuplierSignUpState extends State<SuplierSignUp> {
  late String storeName;
  late String email;
  late String password;
  late String storeLogo;
  late String _uid;
  bool processing = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
  GlobalKey<ScaffoldMessengerState>();

  bool passwordVisible = false;

  final ImagePicker _picker = ImagePicker();

  XFile? _imageFile;
  dynamic _pickedImageError;

  CollectionReference suppliers = FirebaseFirestore.instance.collection("supliers");


  void signUp() async {

    setState(() {
      processing = true;
    });

    if (_formKey.currentState!.validate()) {
      if (_imageFile != null) {
        try {
          print("Image Picked");
          print("valid");
          print(storeName);
          print(email);
          print(password);

          await AuthenticationRepository.signUpWithEmailAndPassword(email, password);


          AuthenticationRepository.sendingEmailVerification();


          firebase_storeage.Reference ref = firebase_storeage
              .FirebaseStorage.instance
              .ref('supplier-images/${email}_supplier_image.jpg');

          await ref.putFile(File(_imageFile!.path));
          _uid = AuthenticationRepository.uid;

          storeLogo = await ref.getDownloadURL();

          AuthenticationRepository.updateUsername(storeName);
          AuthenticationRepository.updateProfileImage(storeLogo);



          await suppliers.doc(_uid).set({
            'store_name' : storeName,
            'email' : email,
            'store_logo' : storeLogo,
            'phone' : '',
            'sid' : _uid,
            'cover_image' : ''
          });

          _formKey.currentState!.reset();
          setState(() {
            _imageFile = null;
          });

          Navigator.pushReplacementNamed(context, "/supplier_login");
        } on FirebaseAuthException catch (e) {
          setState(() {
            processing = false;
          });
          MyMessageHandler.showSnackBar(_scaffoldKey, e.message.toString());
          // setState(() {
          //   processing = false;
          // });
          // if (e.code == "weak-password") {
          //   setState(() {
          //     processing = false;
          //   });
          //   MyMessageHandler.showSnackBar(
          //       _scaffoldKey, "The Password Provided to Weak");
          // } else if (e.code == "email-already-in-use") {
          //   setState(() {
          //     processing = false;
          //   });
          //   MyMessageHandler.showSnackBar(
          //       _scaffoldKey, "The Account Already Exis For Email");
          // }
        }
      } else {
        setState(() {
          processing = false;
        });
        MyMessageHandler.showSnackBar(_scaffoldKey, "Please Pick Image First");
      }
    } else {
      setState(() {
        processing = false;
      });
      MyMessageHandler.showSnackBar(_scaffoldKey, "Please fill all the field");
    }
  }


  void _pickImageFromCamera() async {
    try {
      final pickedImage = await _picker.pickImage(
          source: ImageSource.camera,
          maxHeight: 300,
          maxWidth: 300,
          imageQuality: 95);
      setState(() {
        _imageFile = pickedImage;
      });
    } catch (e) {
      setState(() {
        _pickedImageError = e;
      });
      print(_pickedImageError);
    }
  }

  void _pickImageFromgallery() async {
    try {
      final pickedImage = await _picker.pickImage(
          source: ImageSource.gallery,
          maxHeight: 300,
          maxWidth: 300,
          imageQuality: 95);
      setState(() {
        _imageFile = pickedImage;
      });
    } catch (e) {
      setState(() {
        _pickedImageError = e;
      });
      print(_pickedImageError);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              reverse: true,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const AuthHeaderLabel(headerLabel: "Sup Sign Up"),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 40),
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.tealAccent,
                              backgroundImage: _imageFile == null
                                  ? null
                                  : FileImage(File(_imageFile!.path)),
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                    color: Colors.teal,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15))),
                                child: IconButton(
                                    onPressed: () {
                                      print("Prick Image From Camera");
                                      _pickImageFromCamera();
                                    },
                                    icon: const Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                    )),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                    color: Colors.teal,
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(15),
                                        bottomRight: Radius.circular(15))),
                                child: IconButton(
                                    onPressed: () {
                                      print("Prick Image From Gallery");
                                      _pickImageFromgallery();
                                    },
                                    icon: const Icon(
                                      Icons.photo,
                                      color: Colors.white,
                                    )),
                              ),
                            ],
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please Enter Your Fullname";
                              }
                              return null;
                            },
                            onChanged: (value) {
                              storeName = value;
                            },
                            decoration: textFormDecoration.copyWith(
                              labelText: "Store Name",
                              hintText: "Enter Your Store Name",
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please Enter Your Email Address";
                              } else if (value.isValidEmail() == false) {
                                return "Invalid Email";
                              } else if (value.isValidEmail() == true) {
                                return null;
                              }
                              return null;
                            },
                            onChanged: (value) {
                              email = value;
                            },
                            keyboardType: TextInputType.emailAddress,
                            decoration: textFormDecoration.copyWith(
                                hintText: "Input Your Email Address",
                                labelText: "Email Address")),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please Enter Your Password";
                              }
                              return null;
                            },
                            onChanged: (value) {
                              password = value;
                            },
                            obscureText: !passwordVisible,
                            decoration: textFormDecoration.copyWith(
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        passwordVisible = !passwordVisible;
                                      });
                                    },
                                    icon: passwordVisible
                                        ? const Icon(
                                      Icons.visibility,
                                      color: Colors.teal,
                                    )
                                        : const Icon(
                                      Icons.visibility_off,
                                      color: Colors.teal,
                                    )),
                                labelText: "Password",
                                hintText: "Input Your Password")),
                      ),
                      HaveAccount(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/supplier_login');
                          },
                          actionLabel: "Log In",
                          haveAccount: "Already Have Account? "),
                      processing == true ? const CircularProgressIndicator() : AuthMainButton(
                        onPressed: () {
                          signUp();
                        },
                        mainButtonLabel: "Sign Up",
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
