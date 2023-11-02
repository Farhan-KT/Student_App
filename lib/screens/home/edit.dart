import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:student_app/db/functions/db_functions.dart';
import 'package:student_app/db/model/data_model.dart';
import 'package:student_app/screens/home/list.dart';

class EditScreen extends StatefulWidget {
  final String name;
  final String age;
  final String clas;
  final String address;
  final int index;
  final dynamic image;

  EditScreen({
    required this.name,
    required this.age,
    required this.clas,
    required this.address,
    required this.index,
    required this.image,
    Key? key,
  }) : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController classController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  File? _selectedimage;
  @override
  void initState() {
    nameController.text = widget.name;
    ageController.text = widget.age;
    classController.text = widget.clas;
    addressController.text = widget.address;

    _selectedimage = widget.image != null ? File(widget.image) : null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getAllStudents();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("EDIT DETAILS"),
          backgroundColor: Colors.green[400],
          centerTitle: true,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 35, 0, 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'STUDENT DETAILS',
                    style: TextStyle(
                      color: Colors.green[400],
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 80,
                        backgroundImage: _selectedimage != null
                            ? FileImage(_selectedimage!)
                            : null,
                        child: _selectedimage == null
                            ? Icon(Icons.person, size: 60, color: Colors.grey)
                            : null,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      Colors.green[400])),
                              onPressed: () {
                                fromgallery();
                              },
                              child: const Text('GALLERY')),
                          ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      Colors.green[400])),
                              onPressed: () {
                                fromcam();
                              },
                              child: const Text('CAMERA')),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(
                              Icons.person,
                              color: Colors.green,
                            ),
                            border: OutlineInputBorder(),
                            hintText: 'NAME',
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 10, left: 10, right: 10),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          controller: ageController,
                          decoration: const InputDecoration(
                            prefixIcon:
                                Icon(Icons.calendar_month, color: Colors.blue),
                            border: OutlineInputBorder(),
                            hintText: 'AGE',
                          ),
                          maxLength: 3,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, bottom: 10),
                        child: TextFormField(
                          controller: classController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(
                              Icons.school,
                              color: Colors.black,
                            ),
                            border: OutlineInputBorder(),
                            hintText: 'COURSE',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          controller: addressController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.location_on,
                                color: Color.fromARGB(255, 237, 21, 6)),
                            border: OutlineInputBorder(),
                            hintText: 'PLACE',
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    Colors.green[400])),
                            onPressed: () {
                              update();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const MyWidget()));
                            },
                            child: const Text('UPDATE'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  update() async {
    final edited_name = nameController.text.trim();
    final edited_age = ageController.text.trim();
    final edited_clas = classController.text.trim();
    final edited_address = addressController.text.trim();

    final edited_image = _selectedimage?.path;

    if (edited_name.isEmpty ||
        edited_age.isEmpty ||
        edited_clas.isEmpty ||
        edited_address.isEmpty) {
      return;
    }
    final updated = StudentModel(
        name: edited_name,
        age: edited_age,
        clas: edited_clas,
        address: edited_address,
        image: edited_image!);
    editstudent(widget.index, updated);

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Updated Successfully'),
      behavior: SnackBarBehavior.floating,
    ));
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const MyWidget(),
    ));
  }

  fromgallery() async {
    final returnedimage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      _selectedimage = File(returnedimage!.path);
    });
  }

  fromcam() async {
    final returnedimage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      _selectedimage = File(returnedimage!.path);
    });
  }
}
