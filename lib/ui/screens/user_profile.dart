import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:mood_jar_app/domain/entities/user.dart';
import 'package:mood_jar_app/domain/service/database_helper.dart';
import 'package:image_picker/image_picker.dart';


class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  User? user;
  final ImagePicker imagePicker = ImagePicker();
  
  @override
  void initState(){
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async{
    final fetchedUser = await DatabaseHelper.getUser();
    setState(() {
      user = fetchedUser;
    });
  }

  Future<void> selectImage() async{
    try{
      final xFile = await imagePicker.pickImage(source: ImageSource.gallery);

      if(xFile != null){
        Uint8List newProfileImageFileBytes = await xFile.readAsBytes();
        setState(() {
          user = user?.copyWith(profile: newProfileImageFileBytes );
        });
      }
      await DatabaseHelper.updateUser(user!);
    }
    catch (e){
      print("Error picking image is $e");
    }

  }

  Widget getUserProfile() {
    if (user == null) {
      return const CircleAvatar(
        radius: 100,
        backgroundImage: AssetImage('assets/images/user-profile.jpg'),
      );
    }

    final profileImage = user!.profile != null
        ? MemoryImage(user!.profile!) as ImageProvider
        : const AssetImage('assets/images/user-profile.jpg');

    return Stack(
      children: [
        CircleAvatar(
          radius: 100,
          backgroundImage: profileImage,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: selectImage,
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white
              ),
              child: const Icon(
                Icons.edit, 
                size: 22,
                color: Colors.black,),
            ),
        ))
      ]
        
    );
  }


  Future<void> updateName() async {
    showModalBottomSheet(context: context, builder: (context) {
      TextEditingController nameController = TextEditingController();
      return Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Text("Name", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(
              controller: nameController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: "Enter new name"
              ),
            ),
            SizedBox(height: 15),
            ElevatedButton(onPressed: () async {
              if(nameController.text.isNotEmpty){
                setState(() {
                  user = user?.copyWith(name: nameController.text);
                });
                await DatabaseHelper.updateUser(user!);
              }
              Navigator.pop(context);
            }, child: Text("Save")),
          ],
        ),
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Column(
              children: [
                getUserProfile(),
                SizedBox(height: 15,),
                GestureDetector(
                  onTap: updateName,
                  child: Text("${user!.name}", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 25),)),
                SizedBox(height: 15,),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    children: [
                      Text("Joined Date: ", style: TextStyle(fontSize: 16)),
                      Spacer(),
                      Text("${DateFormat('dd / MMM / yyyy').format(user!.joinedDate)}", style: TextStyle(fontSize: 16),)
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