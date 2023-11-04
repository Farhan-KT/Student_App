import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:student_app/db/functions/db_functions.dart';
import 'package:student_app/db/model/data_model.dart';
import 'package:student_app/screens/home/list.dart';

class ScreenList extends StatefulWidget {
  const ScreenList({super.key});

  @override
  State<ScreenList> createState() => _ScreenState();
}

class _ScreenState extends State<ScreenList> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _classController = TextEditingController();
  final _addressController = TextEditingController();

  // final ImagePicker imagePicker = ImagePicker();
  File? selectedimage;

  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    getAllStudents();
    return Scaffold(
        appBar: AppBar(
          title: Text("ADD DETAILS"),
          backgroundColor: Colors.green[400],
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 40, left: 10, right: 10),
          child: Form(
            key: _formkey,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                      radius: 80,
                      backgroundImage: selectedimage != null
                          ? FileImage(selectedimage!)
                          : AssetImage('assets/profile.png') as ImageProvider),
                  SizedBox(
                    height: 30,
                  ),
                  Wrap(
                    spacing: 30,
                    children: [
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.green[400])),
                          onPressed: () {
                            fromgallery();
                          },
                          child: Text('G A L L E R Y')),
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.green[400])),
                          onPressed: () {
                            fromcam();
                          },
                          child: Text('C A M E R A')),
                    ],
                  ),
                  Column(children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.green[900],
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          hintText: 'NAME',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "value is empty";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      controller: _ageController,
                      decoration: InputDecoration(
                          prefixIcon:
                              Icon(Icons.calendar_month, color: Colors.blue),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          hintText: 'AGE'),
                      maxLength: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "value is empty";
                        } else {
                          return null;
                        }
                      },
                    ),
                    TextFormField(
                      controller: _classController,
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.school,
                            color: Colors.black,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          hintText: 'COURSE'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "value is empty";
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(
                          prefixIcon:
                              Icon(Icons.location_on, color: Colors.red[900]),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          hintText: 'PLACE'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "value is empty";
                        } else {
                          return null;
                        }
                      },
                    ),
                  ]),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton.icon(
                      onPressed: () {
                        if (_formkey.currentState!.validate()) {
                          onAddStudentBtn();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyWidget()));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                      label: Text("ADD"),
                      icon: Icon(Icons.add))
                ],
              ),
            ),
          ),
        ));
  }

  Future<void> onAddStudentBtn() async {
    final _name = _nameController.text.trim();
    final _age = _ageController.text.trim();
    final _class = _classController.text.trim();
    final _address = _addressController.text.trim();

    if (_name.isEmpty || _age.isEmpty || _class.isEmpty || _address.isEmpty) {
      return;
    }
    print('$_name $_age $_class $_address');

    final _student = StudentModel(
      name: _name,
      age: _age,
      clas: _class,
      address: _address,
      image: selectedimage!.path,
    );
    addStudent(_student);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        'Student Added Successfully',
      ),
      behavior: SnackBarBehavior.floating,
    ));
  }

  fromgallery() async {
    final returnedimage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      selectedimage = File(returnedimage!.path);
    });
  }

  fromcam() async {
    final returnedimage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      selectedimage = File(returnedimage!.path);
    });
  }
}
