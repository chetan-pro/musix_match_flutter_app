import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:music_app_task/bloc/music_bloc.dart';
import 'package:music_app_task/music_model.dart';

// ignore: camel_case_types
String baseUrl = "https://api.musixmatch.com/ws/1.1/";
String apiKey = "10fcfd0f5cb27a71d5ae4f3e6c08f39b";
Future getTrackList() async {
  var client = http.Client();
  var trackModel;

  try {
    var response =
        await client.get("${baseUrl}chart.tracks.get?apikey=$apiKey");
    if (response.statusCode == 200) {
      var jsonString = response.body;
      var jsonMap = json.decode(jsonString);

      return MusixMatchModel.fromJson(jsonMap).message!.body!.trackList;
    }
  } catch (Exception) {
    return trackModel;
  }

  return trackModel;
}

Future getTrackById(id) async {
  var client = http.Client();
  var trackModel;

  try {
    var response =
        await client.get("${baseUrl}track.get?track_id=$id&apikey=$apiKey");
    if (response.statusCode == 200) {
      var jsonString = response.body;
      var jsonMap = json.decode(jsonString);
      return MusixMatchModel.fromJson(jsonMap).message!.body!.track;
    }
  } catch (Exception) {
    return trackModel;
  }

  return trackModel;
}

Future getTrackLyricsById(id) async {
  var client = http.Client();
  var trackModel;

  try {
    var response = await client.get(
        "${baseUrl}track.lyrics.get?track_id=$id&apikey=2d782bc7a52a41ba2fc1ef05b9cf40d7");
    if (response.statusCode == 200) {
      var jsonString = response.body;
      var jsonMap = json.decode(jsonString);
      Lyrics? ly = MusixMatchModel.fromJson(jsonMap).message!.body!.lyrics;
      return ly;
    }
  } catch (Exception) {
    return trackModel;
  }

  return trackModel;
}
