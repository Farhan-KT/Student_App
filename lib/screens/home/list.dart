import 'dart:io';

import 'package:flutter/material.dart';
import 'package:student_app/db/functions/db_functions.dart';
import 'package:student_app/db/model/data_model.dart';
import 'package:student_app/screens/home/add.dart';
import 'package:student_app/screens/home/edit.dart';
import 'package:student_app/screens/home/profile.dart';

class MyWidget extends StatefulWidget {
  final Key? key;

  const MyWidget({this.key}) : super(key: key);

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  String search = '';
  List<StudentModel> searchedlist = [];
  List<StudentModel> studentList = [];

  loadstudents() async {
    final allstudents = await getAllStudents();
    // setState(() {
    //   searchedlist = allstudents;
    // });
    studentListNotifier.value = allstudents;
  }

  @override
  void initState() {
    super.initState();

    // searchlistupdate();

    loadstudents();
  }

  void searchlistupdate() {
    setState(() {
      searchedlist = studentListNotifier.value
          .where((StudentModel) =>
              StudentModel.name.toLowerCase().contains(search.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    getAllStudents();
    return Scaffold(
        appBar: AppBar(
          title: const Text("STUDENT LIST"),
          backgroundColor: Colors.green[400],
          centerTitle: true,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 15, right: 15, bottom: 10, top: 15),
              child: TextFormField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    hintText: "Search for students",
                    hintStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.green[400],
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none),
                    prefixIcon: Icon(Icons.search),
                    prefixIconColor: Colors.white),
                onChanged: (value) {
                  setState(() {
                    search = value;
                  });
                  searchlistupdate();
                },
              ),
            ),
            Expanded(
              flex: 2,
              child: ValueListenableBuilder(
                valueListenable: studentListNotifier,
                builder: (BuildContext ctx, List<StudentModel> studentList,
                    Widget? child) {
                  final displaystudent =
                      searchedlist.isNotEmpty ? searchedlist : studentList;
                  return ListView.builder(
                      // itemCount: searchedlist.length,
                      itemBuilder: (ctx, index) {
                        final data = displaystudent[index];

                        return Padding(
                          padding: EdgeInsets.all(10),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 15,
                            child: ListTile(
                              onTap: () {
                                userprofile(context, data);
                              },
                              leading: CircleAvatar(
                                  radius: 30,
                                  backgroundImage: data.image != null
                                      ? FileImage(File(data.image!))
                                      : const AssetImage('assets/profile.png')
                                          as ImageProvider),
                              title: Text(data.name),
                              subtitle: Text(data.age),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => EditScreen(
                                                    name: data.name,
                                                    age: data.age,
                                                    clas: data.clas,
                                                    address: data.address,
                                                    image: data.image,
                                                    index: index,
                                                  )));
                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  const SizedBox(
                                      width:
                                          16), // Add some space between icons
                                  IconButton(
                                    onPressed: () {
                                      deleteStudent(index);
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: displaystudent.length);
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                    padding: EdgeInsets.all(20),
                    child: FloatingActionButton.extended(
                        backgroundColor: Colors.green[400],
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => const ScreenList())));
                        },
                        label: Text("ADD STUDENT"),
                        icon: const Icon(Icons.person_add))),
              ],
            ),
          ],
        ));
  }

  userprofile(BuildContext context, StudentModel student) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreen(user: student),
        ));
  }
}
