import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'add_category.dart';
import 'home.dart';
import 'search.dart';

const String _baseURL = 'mohammadzahran.000webhostapp.com';

class Item {
  int _id;
  String _name;
  double _price;
  String _category;

  Item(this._id, this._name, this._price, this._category);

  @override
  String toString() {
    return 'Product ID: $_id\nName: $_name\nPrice: \$$_price\nCategory: $_category';
  }
}

List<Item> _items = [];

void updateProducts(Function(bool success) update) async {
  try {
    final url = Uri.https(_baseURL, 'getItems.php');
    final response = await http.get(url).timeout(const Duration(seconds: 5));

    _items.clear();
    if (response.statusCode == 200) {
      final jsonResponse = convert.jsonDecode(response.body);
      for (var row in jsonResponse) {
        Item i = Item(
          int.parse(row['id']),
          row['name'],
          double.parse(row['price']),
          row['category'],
        );
        _items.add(i);
      }
      update(true);
    }
  } catch (e) {
    update(false);
  }
}

void searchProduct(Function(String text) update, int pid) async {
  try {
    final url = Uri.https(_baseURL, 'searchItem.php', {'pid': '$pid'});
    final response = await http.get(url).timeout(const Duration(seconds: 5));

    _items.clear();
    if (response.statusCode == 200) {
      final jsonResponse = convert.jsonDecode(response.body);
      var row = jsonResponse[0];
      Item i = Item(
        int.parse(row['id']),
        row['name'],
        double.parse(row['price']),
        row['category'],
      );
      _items.add(i);
      update(i.toString());
    }
  } catch (e) {
    update("Can't load data");
  }
}

class ShowItems extends StatelessWidget {
  const ShowItems({Key? key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      color: Colors.cyan,
      child: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(15),
                title: Text(
                  _items[index]._name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Price: \$${_items[index]._price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Category: ${_items[index]._category}',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
            ),
          );
        },
      ),
    );
  }
}
