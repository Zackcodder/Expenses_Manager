// ignore_for_file: prefer_const_constructors, unnecessary_null_comparison, deprecated_member_use, unused_field, prefer_typing_uninitialized_variables, non_constant_identifier_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String image = "";

  late PickedFile _imageFile;

  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: ListView(children: [
        imageProfile(),
        SizedBox(
          height: 20,
        ),
        nameTextField(),
        SizedBox(height: 20),
        jobTextField(),
        SizedBox(
          height: 20,
        ),
        locationTextField(),
        SizedBox(
          height: 20,
        ),
        departmentTextField(),
        SizedBox(
          height: 20,
        ),
      ]),
    ));
  }

// for uploading of profile picture
  Widget imageProfile() {
    return Center(
      heightFactor: 2,
      child: Stack(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 80.0,
            child: Container(
                child: ClipRRect(
              borderRadius: BorderRadius.circular(50.0),
              child: image == null || image.isEmpty
                  ? Image.asset(
                      "asset/Avatar_2.jpg",
                      fit: BoxFit.contain,
                    )
                  : Image.file(
                      File(image),
                    width: 170,
                    height: 170,
                      alignment: Alignment.center,
                      fit: BoxFit.cover,
                    ),
            )),
          ),
          Positioned(
            bottom: 20.0,
            right: 20.0,
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: ((builder) => bottomSheet()),
                );
              },
              child: Icon(
                Icons.camera_alt,
                color: Colors.black,
                size: 20.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

// Bottom pop up menu to upload picture form camera or gallary
  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: [
          Text(
            'Choose Profile Picture',
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                onPressed: () {
                  takePhoto(ImageSource.gallery);
                },
                icon: Icon(Icons.image),
                label: Text('Gallary',
                style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
            ),
             ),
              ),

              TextButton.icon(
                onPressed: () {
                  takePhoto(ImageSource.camera);
                },
                icon: Icon(Icons.camera),
                label: Text('Camera',
                style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
            ),
            ),
              ),

            ],
          ),
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(source: source);
    _imageFile = pickedFile!;
    if (_imageFile.path != null) {
      setState(() {
        image = _imageFile.path;
      });
    }
  }

// profile details

  Widget nameTextField() {
    return Center(
      child: Text(
        'Name : John Peter',
        style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic),
      ),
    );
  }

  Widget jobTextField() {
    return Center(
      child: Text(
        'Job Describtion:  General Manager',
        style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.normal,
            fontStyle: FontStyle.italic),
      ),
    );
  }

  Widget locationTextField() {
    return Center(
      child: Text(
        'Location:  Lagos State',
        style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.normal,
            fontStyle: FontStyle.italic),
      ),
    );
  }

  Widget departmentTextField() {
    return Center(
      child: Text(
        'Department :  Accounting',
        style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.normal,
            fontStyle: FontStyle.italic),
      ),
    );
  }
}
