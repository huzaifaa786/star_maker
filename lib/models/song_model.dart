class Song {
  late int id;
  String? name;
  String? thumbnail_image_url;
  String? music_file_url;
  String? lyrics_file_url;

  Song({
    required this.id,
    this.name,
    this.thumbnail_image_url,
    this.music_file_url,
    this.lyrics_file_url,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'],
      name: json['name'],
      thumbnail_image_url: json['thumbnail_image_url'],
      music_file_url: json['music_file_url'],
      lyrics_file_url: json['lyrics_file_url'],
    );
  }
}
