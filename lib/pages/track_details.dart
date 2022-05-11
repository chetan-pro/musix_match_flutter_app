import 'package:flutter/material.dart';
import 'package:music_app_task/bloc/music_bloc.dart';
import 'package:music_app_task/music_model.dart';

class TrackDetailsScreen extends StatefulWidget {
  int trackId;
  TrackDetailsScreen({Key? key, required this.trackId}) : super(key: key);

  @override
  State<TrackDetailsScreen> createState() => _TrackDetailsScreenState();
}

class _TrackDetailsScreenState extends State<TrackDetailsScreen> {
  final musixMatchBloc = MusixMatchBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    musixMatchBloc.eventTrackDetailSink.add(widget.trackId);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    musixMatchBloc.trackDetailController.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          title: Text(
            "Track Details",
            style: TextStyle(
              fontSize: 23,
              color: Colors.black,
            ),
          )),
      body: StreamBuilder<Track>(
          stream: musixMatchBloc.trackDetailStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text((snapshot.error ?? "No Data Found").toString()),
              );
            }
            if (snapshot.hasData) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25),
                child: ListView(children: [
                  keyValue(key: "Name", value: snapshot.data!.trackName),
                  keyValue(key: "Artist", value: snapshot.data!.artistName),
                  keyValue(key: "Album Name", value: snapshot.data!.albumName),
                  keyValue(
                      key: "Explicit",
                      value: snapshot.data!.explicit == 1 ? true : false),
                  keyValue(key: "Rating", value: snapshot.data!.trackRating),
                  keyValue(
                      key: "Lyrics", value: snapshot.data!.lyrics!.lyricsBody),
                ]),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  keyValue({key, value}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          (key ?? '').toString(),
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(
          (value ?? '').toString(),
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w500, fontSize: 18),
        )
      ]),
    );
  }
}
