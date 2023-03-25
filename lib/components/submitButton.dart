import 'package:flutter/material.dart';


Widget SubmitButton(String label,Function() onPressed){

  return Padding(
    padding: const EdgeInsets.all(14.0),
    child: ElevatedButton.icon(
                  onPressed: onPressed,

                  icon: const Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.add),
                  ),
                  
                  label: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(label),
                  ),
                ),
  );
}