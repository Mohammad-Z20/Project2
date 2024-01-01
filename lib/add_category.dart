import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

// Domain of your server
const String _baseURL = 'https://mohammadzahran.000webhostapp.com/';

// Used to retrieve the key later
EncryptedSharedPreferences _encryptedData = EncryptedSharedPreferences();

class AddCategory extends StatefulWidget {
  const AddCategory({Key? key}) : super(key: key);

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _controllerID = TextEditingController();
  TextEditingController _controllerName = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _controllerID.dispose();
    _controllerName.dispose();
    super.dispose();
  }

  void update(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              _encryptedData.remove('myKey').then(
                    (success) => Navigator.of(context).pop(),
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
        title: const Text('Add Category'),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.cyan, // Set the background color to cyan
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Image
                Image.memory(
                  base64.decode(
                    'iVBORw0KGgoAAAANSUhEUgAAAOEAAADhCAMAAAAJbSJIAAAAZlBMVEX///8yff/H2P8ddf/h6/8Xc//2+v8oev9Sj/8oef+ow/9mmf8Qcf+sxv/7/f/6/P9Jif9PjP9Chv9snf8Aaf+Ps/90ov+XuP+evf/A1f+wyf/b5/99p/+QtP9xoP+Vt/9dk//S3/8WkO8YAAADh0lEQVR4nO2ci2LSQBREiwiUCvYh1dZWrf//k4Ji2lAgzO7dZGeY8wElx5PNYB9cXBhjjDHGGGOMOTMeh76A0izvhr6CwnxfXA59CWVZLmbahsvJSNtwuRhpG64LahtuCkob/i2obPivoLDhf0FZw+0tqmvYFFQ1fC0oavimoKbh24KShq2CiobtgoKGOwX1DN8Jqhnu3qJyhu8LihnuKahluK+glOHegkqG+wsKGR4oqGN4qKCM4WFBEcODt6iK4ZGCGobHCkoYHi2IGU6fPhbnaYoKXh0tCDZ8Xk0Ks/qCCnYURO/S+3HHl8tk/IwKdhWEz+F95xfMEvyKCnYWxJ80JSviglfdgviztFzFhIKnXAu+FqUqlimYtIc/ilQsVDBt8Usojn/CgicVTHxP8ytcERfsnokcw3DFcgWT35d+C1UsWDD9nXek4jj+rVqAYaAiLnjaTOQahikmFIReef6SahikWLjgaHYH/3/slYcAxdIFswQjFMs+ZNa3aJ7gWhF6uQhBYCZG2QXzFasvmKtYuuD8JkAw5yzOP6GvhRa8jhBE/11zBLGZmN8ECa5fOOk7cAu8IHaLRhXckPadUfRVBivYF2BBQkH1guhM0Am6ILsgWvDz0BeMAs7ELV9B9VsULah+i8oXlH/I8BXUnwnsKUo4E/IF1WcCHXo6QfmC8jPhgjuCdAXBmSAsCA49naCHnr6gh568oAUtWDkeenZBD31b8JJO0EPfFuQ7gxZsC/KdQXlBD/25FRz6emH0z6D6e1G04NDXC+OhP7OChA8Z+Znw0LMXVD+D8t908ky4YOXoP2TkZ0J96PULyp9BD3274NDXC+Oht2Dl6At66NsFh75eGPmh98/od25RC9aGBdkF/TN6dkH/Mh59QQ89eUELnpug+p/XET5k/Hf07AXVHzIeevaC4Gf8qguObqfX0x4YTnAdsQfwTxE9DDYTfTGLM0z9qNbCxBnWWTDQED6DfRFliA19nwQZVlswyrBiwRjDmgVDDKsWjDCsdSa25BtWOvQN2YaVF8w3rPsMbsg0rHfoG/IM6y+YacggmGVIIZhjyCGYYVj9TGxJNqx96BtSDVkKJhuSnMENaYYEQ9+QZEhUMM2QSjDFkEswwZBMEDfkmYktqCHN0DeAhnQFUUO2M7gBMnxYjfmYvJwuOH38wMhv5C41xhhjjDHGGGOMMcYYY9j4A6HCZdAhbYSCAAAAAElFTkSuQmCC',
                  ),
                  height: 120,
                  width: 120,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _controllerID,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                        ],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter ID',
                          labelText: 'ID',
                          prefixIcon: const Icon(Icons.confirmation_number),
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter ID';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _controllerName,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter Name',
                          labelText: 'Name',
                          prefixIcon: const Icon(Icons.text_fields),
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _loading
                            ? null
                            : () {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _loading = true;
                            });
                            saveCategory(
                              update,
                              int.parse(_controllerID.text.toString()),
                              _controllerName.text.toString(),
                            );
                          }
                        },
                        child: _loading
                            ? const CircularProgressIndicator(
                          valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                            : const Text('Submit'),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Below function sends the cid, name, and key using http post to the REST service
void saveCategory(Function(String text) update, int cid, String name) async {
  try {
    // We need to first retrieve and decrypt the key
    String myKey = await _encryptedData.getString('myKey');
    // Send a JSON object using http post
    final response = await http.post(
      Uri.parse('$_baseURL/save.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'cid': '$cid',
        'name': name,
        'key': myKey,
      }),
    ).timeout(const Duration(seconds: 5));
    if (response.statusCode == 200) {
      // If successful, call the update function
      update(response.body);
    }
  } catch (e) {
    update("Connection error");
  }
}
