import 'package:flutter/material.dart';
import 'item.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _productIdController = TextEditingController();
  String _productInfo = '';

  @override
  void dispose() {
    _productIdController.dispose();
    super.dispose();
  }

  void updateProductInfo(String text) {
    setState(() {
      _productInfo = text;
    });
  }

  void getProduct() {
    try {
      int productId = int.parse(_productIdController.text);
      searchProduct(updateProductInfo, productId);
    } catch (e) {
      showSnackBar('Invalid input. Please enter a valid product ID.');
    }
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Search'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              TextFormField(
                controller: _productIdController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Product ID',
                  hintText: 'Enter Product ID',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: getProduct,
                child: const Text('Find', style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  _productInfo,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
