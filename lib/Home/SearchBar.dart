
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class SearchBar extends StatelessWidget {
  final handler;
  final TextEditingController searchQuery;

  SearchBar({required this.handler,required this.searchQuery,super.key});

  @override
  initState(){
    print("Search bar...");
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
      child: TextField(
        controller: searchQuery,
        onChanged: (value) {
          handler();
        },

        style: TextStyle(
          fontWeight: FontWeight.bold,
          decorationThickness: 0
        ),
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 2,
                    )
                  ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          hintText: "Search...",
          contentPadding: EdgeInsets.fromLTRB(8, 1, 3, 1),
        ),
      ),
    );
  }
}