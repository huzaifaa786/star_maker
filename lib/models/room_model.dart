import 'package:star_maker/models/song_model.dart';

class RoomModel {
  late int id;
  String? roomId;
  String? hostId;
  String? hostName;
  int? audienceCount;
  String? roomType;
  String? roomStatus;
  Song? song;

  RoomModel({
    required this.id,
    this.roomId,
    this.hostId,
    this.hostName,
    this.audienceCount,
    this.roomType,
    this.roomStatus,
    this.song,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      id: json['id'],
      roomId: json['room_id'],
      hostId: json['host_id'],
      hostName: json['host_name'],
      audienceCount: json['audience_count'],
      roomType: json['room_type'],
      roomStatus: json['room_status'],
      song: Song.fromJson(json['song']),
    );
  }
}
