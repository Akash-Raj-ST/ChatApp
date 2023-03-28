
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({super.key});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {

  TextEditingController _searchQuery = TextEditingController();


  void search(String query){
    print("Querying ${query}");
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
      child: TextField(
        controller: _searchQuery,
        onChanged: (value) {
          search(_searchQuery.text);
        },

        style: TextStyle(
          fontWeight: FontWeight.bold,
          decorationThickness: 0
        ),
        decoration: InputDecoration(
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