import 'package:flutter/material.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'dart:convert'; // Import this for decoding base64 string
import 'dart:typed_data'; // Import this for Uint8List
import 'home.dart';
import 'add_category.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _keyController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final EncryptedSharedPreferences _encryptedData = EncryptedSharedPreferences();

  void _update(bool success) {
    if (success) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Home()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to set key')));
    }
  }

  Future<void> _checkLogin() async {
    if (_keyController.text.trim().isEmpty || _userNameController.text.trim().isEmpty) {
      _update(false);
    } else {
      try {
        final success = await _encryptedData.setString('myKey', _keyController.text);
        // You can save the user name as well if needed
        await _encryptedData.setString('userName', _userNameController.text);
        _update(success);
      } catch (e) {
        _update(false);
      }
    }
  }

  Future<void> _checkSavedData() async {
    final myKey = await _encryptedData.getString('myKey');
    final userName = await _encryptedData.getString('userName');
    if (myKey.isNotEmpty && userName.isNotEmpty) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AddCategory()));
    }
  }

  @override
  void initState() {
    super.initState();
    _checkSavedData();
  }

  @override
  Widget build(BuildContext context) {
    final Uint8List imageBytes = base64.decode(
        'iVBORw0KGgoAAAANSUhEUgAAAOEAAADhCAMAAAAJbSJIAAAAZlBMVEX///8yff/H2P8ddf/h6/8Xc//2+v8oev9Sj/8oef+ow/9mmf8Qcf+sxv/7/f/6/P9Jif9PjP9Chv9snf8Aaf+Ps/90ov+XuP+evf/A1f+wyf/b5/99p/+QtP9xoP+Vt/9dk//S3/8WkO8YAAADh0lEQVR4nO2ci2LSQBREiwiUCvYh1dZWrf//k4Ji2lAgzO7dZGeY8wElx5PNYB9cXBhjjDHGGGOMOTMeh76A0izvhr6CwnxfXA59CWVZLmbahsvJSNtwuRhpG64LahtuCkob/i2obPivoLDhf0FZw+0tqmvYFFQ1fC0oavimoKbh24KShq2CiobtgoKGOwX1DN8Jqhnu3qJyhu8LihnuKahluK+glOHegkqG+wsKGR4oqGN4qKCM4WFBEcODt6iK4ZGCGobHCkoYHi2IGU6fPhbnaYoKXh0tCDZ8Xk0Ks/qCCnYURO/S+3HHl8tk/IwKdhWEz+F95xfMEvyKCnYWxJ80JSviglfdgviztFzFhIKnXAu+FqUqlimYtIc/ilQsVDBt8Usojn/CgicVTHxP8ytcERfsnokcw3DFcgWT35d+C1UsWDD9nXek4jj+rVqAYaAiLnjaTOQahikmFIReef6SahikWLjgaHYH/3/slYcAxdIFswQjFMs+ZNa3aJ7gWhF6uQhBYCZG2QXzFasvmKtYuuD8JkAw5yzOP6GvhRa8jhBE/11zBLGZmN8ECa5fOOk7cAu8IHaLRhXckPadUfRVBivYF2BBQkH1guhM0Am6ILsgWvDz0BeMAs7ELV9B9VsULah+i8oXlH/I8BXUnwnsKUo4E/IF1WcCHXo6QfmC8jPhgjuCdAXBmSAsCA49naCHnr6gh568oAUtWDkeenZBD31b8JJO0EPfFuQ7gxZsC/KdQXlBD/25FRz6emH0z6D6e1G04NDXC+OhP7OChA8Z+Znw0LMXVD+D8t908ky4YOXoP2TkZ0J96PULyp9BD3274NDXC+Oht2Dl6At66NsFh75eGPmh98/od25RC9aGBdkF/TN6dkH/Mh59QQ89eUELnpug+p/XET5k/Hf07AXVHzIeevaC4Gf8qguObqfX0x4YTnAdsQfwTxE9DDYTfTGLM0z9qNbCxBnWWTDQED6DfRFliA19nwQZVlswyrBiwRjDmgVDDKsWjDCsdSa25BtWOvQN2YaVF8w3rPsMbsg0rHfoG/IM6y+YacggmGVIIZhjyCGYYVj9TGxJNqx96BtSDVkKJhuSnMENaYYEQ9+QZEhUMM2QSjDFkEswwZBMEDfkmYktqCHN0DeAhnQFUUO2M7gBMnxYjfmYvJwuOH38wMhv5C41xhhjjDHGGGOMMcYYY9j4A6HCZdAhbYSCAAAAAElFTkSuQmCC'
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login to Zizo Cell'),
        centerTitle: true,
      ),
      backgroundColor: Colors.cyan,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.memory(
              imageBytes,
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 10),
            Text(
              'User Name:',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 5),
            SizedBox(
              width: 200,
              child: TextField(
                controller: _userNameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                  hintText: 'Enter User Name',
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Enter your KEY:',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 5),
            SizedBox(
              width: 200,
              child: TextField(
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                controller: _keyController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                  hintText: 'Enter Key',
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _checkLogin,
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}