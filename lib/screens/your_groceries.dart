import 'package:challenge_app/data/categories.dart';
import 'package:flutter/material.dart';

import '../data/dummy_items.dart';
import '../models/category.dart';
import '../widgets/grocery_item.dart';

class YourGroceriesScreen extends StatefulWidget {
  const YourGroceriesScreen({super.key});

  @override
  State<YourGroceriesScreen> createState() => _YourGroceriesScreenState();
}

class _YourGroceriesScreenState extends State<YourGroceriesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Your Groceries",
        ),
      ),
      body: Column(children: groceryItems),
    );
  }
}
