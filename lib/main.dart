// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:music_app_task/bloc/music_bloc.dart';
import 'package:music_app_task/music_model.dart';
import 'package:music_app_task/pages/track_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TrackListScreen(),
    );
  }
}
