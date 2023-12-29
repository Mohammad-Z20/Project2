import 'package:flutter/material.dart';
import 'add_item.dart';
import 'item.dart';
import 'search.dart';
import 'add_category.dart'; // Import the necessary files for Add Category and Add Products

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _load = false;

  void update(bool success) {
    setState(() {
      _load = true;
      if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to load data')));
      }
    });
  }

  @override
  void initState() {
    updateProducts(update);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: !_load
                ? null
                : () {
              setState(() {
                _load = false;
                updateProducts(update);
              });
            },
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Search()),
                );
              });
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const AddCategory()),
                );
              });
            },
            icon: const Icon(Icons.add_circle), // Example icon for Add Category
          ),
          IconButton(
            onPressed: () {
              setState(() {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const AddItem()),
                );
              });
            },
            icon: const Icon(Icons.add), // Example icon for Add Products
          ),
        ],
        title: const Text('Available Products'),
        centerTitle: true,
      ),
      body: _load
          ? const ShowItems()
          : const Center(
        child: SizedBox(
          width: 100,
          height: 100,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
