import 'package:star_maker/apis/api.dart';
import 'package:star_maker/models/song_model.dart';
import 'package:star_maker/utils/string.dart';

class SongApi {
  Future<List<Song>> getAllSongs() async {
    var url = BASE_URL + 'songs/all';
    var data = {};
    List<Song> allSongs = [];

    var response = await Api.execute(
      url: url,
      data: data,
    );

    if (!response['error']) {
      for (var song in response['songs']) {
        allSongs.add(Song.fromJson(song));
      }
    }
    return allSongs;
  }
}
