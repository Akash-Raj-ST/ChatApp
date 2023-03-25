import 'package:flutter/material.dart';


Widget TabButton(title,currentTab,handler){
  return ElevatedButton(
          style: ButtonStyle(
            backgroundColor: title==currentTab?MaterialStateProperty.all(Colors.blue[400]):MaterialStateProperty.all(Colors.blue[200]),
          ),
          onPressed: (){
            if(currentTab!=title){
              handler(title);
            }
          }, 
          child: Padding(
            padding: const EdgeInsets.only(left:8,right:8,top:4,bottom:4),
            child: Text(title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: title==currentTab?Colors.white:Colors.black,
              ),
            ),
          ),
        );
}