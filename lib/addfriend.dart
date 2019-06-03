import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:image_picker/image_picker.dart';
import 'auth.dart';
import 'dart:io';

class AddItem extends StatefulWidget{
  @override
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<AddItem>{
  File _image;
  TextEditingController _nameController;
  TextEditingController _priceController;
  TextEditingController _addressController;
  TextEditingController _categoryController;
  TextEditingController _phoneNumController;
  bool _isCamera = false;

  bool _isDefault = true;

  DateTime _createTime = DateTime.now();
  DateTime _modifiedTime = DateTime.now();
  DateFormat formatter = DateFormat('y.M.d H:m:s');

  @override
  void initState(){
    super.initState();
    _nameController = TextEditingController();
    _priceController = TextEditingController();
    _addressController = TextEditingController();
    _categoryController = TextEditingController();
    _phoneNumController = TextEditingController();
    AuthService.storage = FirebaseStorage.instance;
  }

  Future _getImage() async{
    var image = await ImagePicker.pickImage(source: _isCamera ? ImageSource.camera : ImageSource.gallery);
    setState((){
      if (image != null){
        _isDefault = false;
      }
      _image = image;
    });
  }

  @override
  void dispose(){
    _nameController.dispose();
    _priceController.dispose();
    _addressController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<String> _imgUploadUrl() async{
    StorageReference ref = AuthService.storage.ref().child(_nameController.text);
    StorageUploadTask upload;
    if (_image != null){
      upload = ref.putFile(_image);
    }
    StorageTaskSnapshot taskSnapshot = await upload.onComplete;
    return await taskSnapshot.ref.getDownloadURL();
  }

  Future<void> _uploadData() async{
    String imgurl = _isDefault ? AuthService.defaultImgUrl : await _imgUploadUrl();
    Firestore.instance.collection('group').document(_nameController.text).setData({
      'name': _nameController.text.split(" ")[0] + " " + _nameController.text.split(" ")[0][0] + ".",
      'imgurl': imgurl,
      'address' : _addressController.text,
      'favorite': false,
      'fullname' : _nameController.text,
      'phoneNum' : _phoneNumController.text,
      'editor': AuthService.user.displayName,
      'uid' : AuthService.user.uid,
    });
  }

  @override
  Widget build (BuildContext context){
    return Scaffold(
      backgroundColor: Color(0xFF2d3447),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: Icon(Icons.person_add, color: Color(0xFF2d3447)),
        onPressed: () async {
          await _uploadData();// Upload product information to firebase storage and database
          Navigator.pop(context); // Return to the list of items page (HomePage) after uploading
        },
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Add',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30.0,
            fontFamily: 'SF-Pro-Text-Bold'
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children:[
         Container(
          width: MediaQuery.of(context).size.width,
          child: _isDefault ? FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: AuthService.defaultImgUrl,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fitWidth,
            ) : Image.file(_image, fit: BoxFit.fitWidth),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.camera,
                    color: Colors.white,
                    size: 30.0,
                  ),
                  onPressed: (){
                    setState((){
                      _isCamera = true;
                    });
                    _getImage();
                    _modifiedTime = DateTime.now();
                  }
                ),
                IconButton(
                  icon: Icon(
                    Icons.add_a_photo,
                    color: Colors.white,
                    size: 30.0,
                  ),
                  onPressed: (){
                    setState((){
                      _isCamera = false;
                    });
                    _getImage();
                    _modifiedTime = DateTime.now();
                  }
                ),
              ],
            ),
          ),
          SizedBox(height:10.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              style: TextStyle(color: Colors.white, fontSize: 30.0),
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Name', 
                hintStyle: TextStyle(
                  fontSize: 30.0,
                  color: Colors.white,
                ),
                enabled: true,
              ),
              onTap: (){
                setState((){
                  _modifiedTime = DateTime.now();
                });
              }
            ),
          ),
          SizedBox(height:10.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              style: TextStyle(color: Colors.white, fontSize: 30.0),
              controller: _phoneNumController,
              decoration: InputDecoration(
                fillColor: Colors.white,
                hintText: 'Phone Num.', 
                hintStyle: TextStyle(
                  fontSize: 30.0,
                  color: Colors.white,
                ),
              ),
              onTap: (){
                setState((){
                  _modifiedTime = DateTime.now();
                });
              }
            ),
          ),
          SizedBox(height:10.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              style: TextStyle(color: Colors.white, fontSize: 30.0),
              controller: _addressController,
              decoration: InputDecoration(
                hintText: 'Address', 
                hintStyle: TextStyle(
                  fontSize: 30.0,
                  color: Colors.white,
                ),
              ),
              onTap: (){
                setState((){
                  _modifiedTime = DateTime.now();
                });
              }
            ),
          ),
          SizedBox(height:20.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children:[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children:[
                    Text('creator: ' + AuthService.user.uid),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children:[
                    Text(formatter.format(_createTime)),
                    Text(' Create',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children:[
                    Text(formatter.format(_modifiedTime)),
                    Text(' Modified',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}