import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:music_app_task/music_model.dart';
import 'package:music_app_task/services_manager.dart';

enum TrackListAction { Fetch, FetchOne }

class MusixMatchBloc {
  final Connectivity _connectivity = Connectivity();
  int? trackId;

  final musixMatchStreamController =
      StreamController<List<TrackList>>.broadcast();
  StreamSink<List<TrackList>> get musixMatchSink =>
      musixMatchStreamController.sink;
  Stream<List<TrackList>> get musixMatchStream =>
      musixMatchStreamController.stream;
  final eventMatchStreamController =
      StreamController<TrackListAction>.broadcast();
  StreamSink<TrackListAction> get eventMatchSink =>
      eventMatchStreamController.sink;
  Stream<TrackListAction> get eventMatchStream =>
      eventMatchStreamController.stream;

  final trackDetailController = StreamController<Track>.broadcast();
  StreamSink<Track> get trackDetailSink => trackDetailController.sink;
  Stream<Track> get trackDetailStream => trackDetailController.stream;

  final trackDetailEventStreamController = StreamController<int>.broadcast();
  StreamSink<int> get eventTrackDetailSink =>
      trackDetailEventStreamController.sink;
  Stream<int> get eventTrackDetailStream =>
      trackDetailEventStreamController.stream;

  MusixMatchBloc() {
    _connectivity.onConnectivityChanged.listen((status) {
      if (status == ConnectivityResult.none) {
        musixMatchSink.addError("No Network Connection");
        trackDetailSink.addError("No Network Connection");
      } else {
        eventMatchSink.add(TrackListAction.Fetch);
        if (trackId != null) {
          eventTrackDetailSink.add(trackId!);
        }
      }
    });
    eventMatchStream.listen((event) async {
      var trackList = await getTrackList();
      if (trackList != null) {
        musixMatchSink.add(trackList);
      } else {
        musixMatchSink.addError("Something went wrong");
      }
    });
    eventTrackDetailStream.listen((id) async {
      trackId = id;
      Lyrics lyrics = await getTrackLyricsById(id);
      Track track = await getTrackById(id);
      if (track.trackId != null) {
        track.lyrics = lyrics;
        trackDetailSink.add(track);
      } else {
        trackDetailSink.addError("Something went wrong");
      }
    });
  }
  void dispose() {
    musixMatchStreamController.close();
    eventMatchStreamController.close();
  }
}
