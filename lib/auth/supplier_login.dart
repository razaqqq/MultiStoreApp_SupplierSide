import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app_supplier/profiders/authentication_repository.dart';
import 'package:multi_store_app_supplier/widgets/yellow_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/auth_widget.dart';
import '../widgets/snackbar_widget.dart';

class SupplierLogin extends StatefulWidget {
  const SupplierLogin({super.key});

  @override
  State<SupplierLogin> createState() => _SupplierLoginState();
}

class _SupplierLoginState extends State<SupplierLogin> {

  final Future<SharedPreferences> _sharedPreferences = SharedPreferences.getInstance();

  late String email;
  late String password;



  bool processing = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  bool passwordVisible = false;
  bool sendEmailVerivication = false;

  void logIn() async {
    setState(() {
      processing = true;
    });

    if (_formKey.currentState!.validate()) {
      try {

        await AuthenticationRepository.signInWithEmailAndPassword(email, password);

        AuthenticationRepository.reloadUserData();

        if (await AuthenticationRepository.checkVerificationEmail()) {
          _formKey.currentState!.reset();

          User user = FirebaseAuth.instance.currentUser!;

          final SharedPreferences preferences = await _sharedPreferences;
          preferences.setString('supplier_id', user.uid);


          await Future.delayed(const Duration(milliseconds: 100)).whenComplete(() {
            Navigator.of(context).pushReplacementNamed('/supplier_home');
          });

          Navigator.pushReplacementNamed(context, "/supplier_home");
        } else {
          MyMessageHandler.showSnackBar(
              _scaffoldKey, 'Please Verivy Yur Email First');

          setState(() {
            processing = false;
            sendEmailVerivication = true;
          });
        }
      } on FirebaseAuthException catch (e) {

        setState(() {
          processing = false;
        });

        MyMessageHandler.showSnackBar(_scaffoldKey, e.message.toString());

      }
    } else {
      setState(() {
        processing = false;
      });
      MyMessageHandler.showSnackBar(_scaffoldKey, "Please fill all the field");
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AuthHeaderLabel(headerLabel: "Sup Log In"),
                      SizedBox(
                        height: 50,
                        child: sendEmailVerivication == true
                            ? Center(
                                child: YellowButton(
                                    widthPercentage: 0.6,
                                    label: 'Resend Email Verivication',
                                    onPressed: () async {
                                      try{
                                        await FirebaseAuth.instance.currentUser!
                                            .sendEmailVerification();

                                      }
                                      catch (e) {
                                        print(e);
                                      }
                                      
                                      Future.delayed(Duration(seconds: 3)).whenComplete(() {
                                        setState(() {
                                          sendEmailVerivication = false;
                                        });
                                      });


                                    }),
                              )
                            : const SizedBox(),
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
                      TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Forget Password ?",
                            style: TextStyle(
                                fontSize: 18, fontStyle: FontStyle.italic),
                          )),
                      HaveAccount(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, '/supplier_signup');
                          },
                          actionLabel: "Sign Up",
                          haveAccount: "Dont\'t Have Account? "),
                      processing == true
                          ? const Center(child: CircularProgressIndicator())
                          : AuthMainButton(
                              onPressed: () {
                                logIn();
                              },
                              mainButtonLabel: "Log In",
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
