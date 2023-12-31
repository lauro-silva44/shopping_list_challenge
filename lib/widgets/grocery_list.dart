import 'dart:convert';

import 'package:challenge_app/data/categories.dart';
import 'package:challenge_app/models/grocery_item.dart';
import 'package:challenge_app/widgets/new_item.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryList = [];
  var _isLoading = true;
  String? _error;

  void _loadItems() async {
    final url = Uri.https('shopping-list-d4262-default-rtdb.firebaseio.com',
        'shopping-list.json');

    try {
      final response = await http.get(url);
      if (response.statusCode >= 400) {
        setState(() {
          _error = "Failed to fetch data. Please try again later!";
        });
      }

      final Map<String, dynamic> listData = json.decode(response.body);
      final List<GroceryItem> loadedItems = [];
      for (final item in listData.entries) {
        final category = categories.entries
            .firstWhere((categoryItem) =>
                categoryItem.value.title == item.value['category'])
            .value;
        loadedItems.add(
          GroceryItem(
              id: item.key,
              name: item.value['name'],
              quantity: int.parse(item.value['quantity']),
              category: category),
        );
      }
      setState(() {
        _groceryList = loadedItems;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _error = 'Ups!... Something is wrong!';
      });
    }
  }

  void _addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
        MaterialPageRoute(builder: (ctx) => const NewItem()));
    if (newItem == null) {
      return;
    }
    setState(() {
      _groceryList.add(newItem);
    });
  }

  void _onRemoveGrocery(GroceryItem item) async {
    final index = _groceryList.indexOf(item);
    setState(() {
      _groceryList.remove(item);
    });

    try {
      final url = Uri.https('shopping-list-d4262-default-rtdb.firebaseio.com',
          'shopping-list/${item.id}.json');
      await http.delete(url);
    } catch (err) {
      setState(() {
        _groceryList.insert(index, item);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text("There's nothing on the list"),
    );

    if (_isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_groceryList.isNotEmpty) {
      content = ListView.builder(
        itemCount: _groceryList.length,
        itemBuilder: (ctx, index) => Dismissible(
          key: ValueKey(_groceryList[index].id),
          onDismissed: (direction) => _onRemoveGrocery(_groceryList[index]),
          background: ColoredBox(
            color: Theme.of(context).colorScheme.error,
          ),
          child: ListTile(
            title: Text(_groceryList[index].name),
            leading: Container(
              width: 24,
              height: 24,
              color: _groceryList[index].category.color,
            ),
            trailing: Text(
              _groceryList[index].quantity.toString(),
            ),
          ),
        ),
      );
    }

    if (_error != null) {
      content = Center(
        child: Text(_error!),
      );
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Groceries'),
          actions: [
            IconButton(
              onPressed: _addItem,
              icon: const Icon(Icons.add),
            )
          ],
        ),
        body: content);
  }
}
