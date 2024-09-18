import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_store_app_supplier/widgets/appbar_widgets.dart';
import 'package:multi_store_app_supplier/widgets/snackbar_widget.dart';
import 'package:multi_store_app_supplier/widgets/yellow_button.dart';

class EditStore extends StatefulWidget {
  const EditStore({super.key, required this.data});

  final dynamic data;

  @override
  State<EditStore> createState() => _EditStoreState();
}

class _EditStoreState extends State<EditStore> {
  final ImagePicker _picker = ImagePicker();

  XFile? _logoImageFile;
  XFile? _coverImageFile;
  dynamic _pickedImageError;
  late String storeName;
  late String phoneNumber;
  late String storeLogo;
  late String coverImage;
  bool processing = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> scaffoldKeyMessenger =
      GlobalKey<ScaffoldMessengerState>();

  pickStoreLogo() async {
    try {
      final pickedStroLogo = await _picker.pickImage(
          source: ImageSource.gallery,
          maxHeight: 300,
          maxWidth: 300,
          imageQuality: 95);
      setState(() {
        _logoImageFile = pickedStroLogo;
      });
    } catch (e) {
      setState(() {
        _pickedImageError = e;
      });
      print(_pickedImageError);
    }
  }

  pickCoverImage() async {
    try {
      final pickCoverImage = await _picker.pickImage(
          source: ImageSource.gallery,
          maxHeight: 300,
          maxWidth: 300,
          imageQuality: 95);
      setState(() {
        _coverImageFile = pickCoverImage;
      });
    } catch (e) {
      setState(() {
        _pickedImageError = e;
      });
      print(_pickedImageError);
    }
  }

  Future uploadStoreLogo() async {
    if (_logoImageFile != null) {
      try {
        firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref('supp-images/${widget.data['email']}_store_logo.jpg');
        await ref.putFile(File(_logoImageFile!.path));

        storeLogo = await ref.getDownloadURL();
      } catch (e) {
        print(e);
      }
    } else {
      storeLogo = widget.data['store_logo'];
    }
  }

  Future uploadCoverImage() async {
    print('Cover Image');
    if (_coverImageFile != null) {
      print("Anjing");
      try {
        firebase_storage.Reference ref2 = firebase_storage
            .FirebaseStorage.instance
            .ref('supp-images/${widget.data['email']}_cover_images.jpg');
        await ref2.putFile(File(_coverImageFile!.path));

        coverImage = await ref2.getDownloadURL();
      } catch (e) {
        print(e);
      }
    } else {
      coverImage = widget.data['cover_image'];
    }
  }

  editStoreData() async {
    print('Edit Strore data Called');
    print(storeName);
    print(phoneNumber);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      print("Try Update to Firebase Firestore");
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('supliers')
          .doc(FirebaseAuth.instance.currentUser!.uid);
      transaction.update(documentReference, {
        'store_name' : storeName,
        'phone' : phoneNumber,
        'store_logo' : storeLogo,
        'cover_image' : coverImage
      });
      print('Data to Firebase Has Been Updated');
    }).whenComplete(() => Navigator.pop(context));
  }

  savedChanges() async {
    print("Saved Changes Called");
    if (formKey.currentState!.validate()) {
      print("Form Key Validate");
      formKey.currentState!.save();
      setState(() {
        processing = true;
      });
      print("Processing = true");


      await uploadStoreLogo().whenComplete(() async {
        print("Store Logo Uploaded");
        uploadCoverImage().whenComplete(() async {
          editStoreData();
        });
        print("Cover Image Uploaded");
      });
      setState(() {
        processing = false;
      });
    } else {
      MyMessageHandler.showSnackBar(
          scaffoldKeyMessenger, 'Please Fill All Field First');
      setState(() {
        processing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldKeyMessenger,
      child: Scaffold(
        appBar: AppBar(
          leading: const AppBarBackButton(color: Colors.black),
          elevation: 0,
          backgroundColor: Colors.white,
          title: const AppBarTitle(title: 'Edit Store', color: Colors.black,),
        ),
        body: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  children: [
                    const Text(
                      'Store Logo',
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.w600),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CircleAvatar(
                            radius: 60,
                            backgroundImage:
                                NetworkImage(widget.data['store_logo'])),
                        Column(
                          children: [
                            YellowButton(
                                widthPercentage: 0.25,
                                label: 'Change',
                                onPressed: () {
                                  pickStoreLogo();
                                }),
                            const SizedBox(
                              height: 10,
                            ),
                            _logoImageFile == null
                                ? const SizedBox()
                                : YellowButton(
                                    widthPercentage: 0.25,
                                    label: 'Reset',
                                    onPressed: () {
                                      setState(() {
                                        _logoImageFile = null;
                                      });
                                    }),
                          ],
                        ),
                        _logoImageFile == null
                            ? const SizedBox()
                            : CircleAvatar(
                                radius: 60,
                                backgroundImage:
                                    FileImage(File(_logoImageFile!.path))),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8),
                      child: Divider(
                        color: Colors.yellow,
                        thickness: 2.5,
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    const Text(
                      'Cover Image',
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.w600),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CircleAvatar(
                            radius: 60,
                            backgroundImage:
                                NetworkImage(widget.data['cover_image'])),
                        Column(
                          children: [
                            YellowButton(
                                widthPercentage: 0.25,
                                label: 'Change',
                                onPressed: () {
                                  pickCoverImage();
                                }),
                            const SizedBox(
                              height: 10,
                            ),
                            _coverImageFile == null
                                ? const SizedBox()
                                : YellowButton(
                                    widthPercentage: 0.25,
                                    label: 'Reset',
                                    onPressed: () {
                                      setState(() {
                                        _coverImageFile = null;
                                      });
                                    }),
                          ],
                        ),
                        _coverImageFile == null
                            ? const SizedBox()
                            : CircleAvatar(
                                radius: 60,
                                backgroundImage:
                                    FileImage(File(_coverImageFile!.path))),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8),
                      child: Divider(
                        color: Colors.yellow,
                        thickness: 2.5,
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Your Store Name';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (newValue) {
                      storeName = newValue!;
                    },
                    initialValue: widget.data['store_name'],
                    decoration: textFormDecoration.copyWith(
                        labelText: 'Store Name', hintText: 'Enter Store Name'),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Your Phone Number';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (newValue) {
                      phoneNumber = newValue!;
                    },
                    initialValue: widget.data['phone'],
                    decoration: textFormDecoration.copyWith(
                        labelText: 'Phone Number',
                        hintText: 'Enter Phone Number'),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      YellowButton(
                          widthPercentage: 0.25,
                          label: 'Cancel',
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                      processing ? YellowButton(
                          widthPercentage: 0.5,
                          label: 'Please Wait',
                          onPressed: () {
                            null;
                          }) : YellowButton(
                          widthPercentage: 0.5,
                          label: 'Save Changes',
                          onPressed: () {
                            print("testtttttt");
                            savedChanges();
                          }),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

var textFormDecoration = InputDecoration(
  labelText: 'price',
  hintText: 'price .. \$',
  labelStyle: const TextStyle(color: Colors.teal),
  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
  enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.teal, width: 1),
      borderRadius: BorderRadius.circular(10)),
  focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blueAccent, width: 1),
      borderRadius: BorderRadius.circular(10)),
);
