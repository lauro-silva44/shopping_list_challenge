import 'package:challenge_app/models/category.dart';
import 'package:challenge_app/widgets/category.dart';

import 'package:flutter/material.dart';

class GroceryItem extends StatelessWidget {
  const GroceryItem(
      {super.key,
      required this.id,
      required this.name,
      required this.quantity,
      required this.category});

  final String id;
  final String name;
  final int quantity;
  final Category category;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all( 16),
      child: Row(
        children: [
          ColoredBox(
            color: category.color,
            child: const SizedBox.square(
              dimension: 24,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Text(
            name,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const Spacer(),
          Text(
            "$quantity",
            style: Theme.of(context).textTheme.bodyMedium,
          )
        ],
      ),
    );
  }
}
