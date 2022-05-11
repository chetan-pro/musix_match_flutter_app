import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_app_task/bloc/music_bloc.dart';
import 'package:music_app_task/music_model.dart';
import 'package:music_app_task/pages/track_details.dart';
import 'dart:developer' as developer;

import 'package:connectivity_plus/connectivity_plus.dart';

class TrackListScreen extends StatefulWidget {
  TrackListScreen({Key? key}) : super(key: key);
  @override
  State<TrackListScreen> createState() => _TrackListScreenState();
}

class _TrackListScreenState extends State<TrackListScreen> {
  final musixMatchBloc = MusixMatchBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    musixMatchBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            "Trending",
            style: TextStyle(
              fontSize: 25,
              color: Colors.black,
            ),
          )),
      body: Center(
          child: StreamBuilder<List<TrackList>>(
        stream: musixMatchBloc.musixMatchStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text((snapshot.error ?? "No Data Found").toString()),
            );
          }
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data != null ? snapshot.data!.length : 0,
                itemBuilder: (context, index) =>
                    trackBox(snapshot.data![index]));
          } else {
            return CircularProgressIndicator();
          }
        },
      )),
    );
  }

  trackBox(TrackList track) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TrackDetailsScreen(
                      trackId: track.track!.trackId!,
                    )));
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
            border: Border(
                bottom:
                    BorderSide(color: Colors.grey.withOpacity(0.6), width: 1))),
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Icon(Icons.library_music, color: Colors.grey),
          Container(
            margin: EdgeInsets.only(left: 15),
            width: MediaQuery.of(context).size.width * 0.50,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(track.track!.trackName ?? '',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w500)),
              SizedBox(height: 5),
              Text(track.track!.albumName ?? '',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  )),
            ]),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.20,
            child: Text(track.track!.artistName ?? '',
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w500)),
          ),
        ]),
      ),
    );
  }
}
