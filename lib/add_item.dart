import 'package:flutter/material.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

// Import the necessary files for ShowItems widget


const String _baseURL = 'https://mohammadzahran.000webhostapp.com/';
EncryptedSharedPreferences _encryptedData = EncryptedSharedPreferences();

class AddItem extends StatefulWidget {
  const AddItem({Key? key}) : super(key: key);

  @override
  State<AddItem> createState() => _AddItem();
}

class _AddItem extends State<AddItem> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _controllerID = TextEditingController();
  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerPrice = TextEditingController(); // Added a controller for price
  TextEditingController _controllerCategoryId = TextEditingController(); // Added a controller for category ID
  bool _loading = false;

  @override
  void dispose() {
    _controllerID.dispose();
    _controllerName.dispose();
    _controllerPrice.dispose();
    _controllerCategoryId.dispose();
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
              _encryptedData.remove('myKey').then((success) => Navigator.of(context).pop());
            },
            icon: const Icon(Icons.logout),
          )
        ],
        title: const Text('Add Item'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 10),
              SizedBox(
                width: 200,
                child: TextFormField(
                  controller: _controllerID,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter ID',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter id';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 10),
              const SizedBox(height: 10),
              SizedBox(
                width: 200,
                child: TextFormField(
                  controller: _controllerName,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Name',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter name';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 200,
                child: TextFormField(
                  controller: _controllerPrice,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter price',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter price';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 200,
                child: TextFormField(
                  controller: _controllerCategoryId,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter category id',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter category id';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 10),
              const SizedBox(height: 10),

              ElevatedButton(
                onPressed: _loading
                    ? null
                    : () {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      _loading = true;
                    });
                    saveItem(
                      update,
                      int.parse(_controllerID.text),
                      _controllerName.text,
                      double.parse(_controllerPrice.text),
                      int.parse(_controllerCategoryId.text),
                    );
                  }
                },
                child: const Text('Submit'),
              ),
              const SizedBox(height: 10),
              Visibility(
                visible: _loading,
                child: const CircularProgressIndicator(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void saveItem(Function(String text) update, int id, String name, double price, int cid) async {
  try {
    String myKey = await _encryptedData.getString('myKey');
    final response = await http.post(
      Uri.parse('$_baseURL/addItems.php'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'id': id.toString(),
        'cid': cid.toString(),
        'name': name,
        'price': price.toString(),
        'key': myKey,
      },
    ).timeout(const Duration(seconds: 5));

    if (response.statusCode == 200) {
      update(response.body);
    }
  } catch (e) {
    update("Connection error");
  }
}
