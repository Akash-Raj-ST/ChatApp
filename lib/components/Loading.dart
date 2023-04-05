import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

Widget Loading(String loadingMsg){

  return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset('assets/animations/loading.json'),

                Text(
                  loadingMsg,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                )
              ],
            ),
          );
}

Widget Success(String loadingMsg){

  return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset('assets/animations/success.json'),

                Text(
                  loadingMsg,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                )
              ],
            ),
          );
}