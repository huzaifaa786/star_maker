class RoomModel {
  late int id;
  String? roomId;
  String? hostId;
  String? hostName;
  int? audienceCount;
  String? roomType;
  String? roomStatus;
  String? songId;

  RoomModel({
    required this.id,
    this.roomId,
    this.hostId,
    this.hostName,
    this.audienceCount,
    this.roomType,
    this.roomStatus,
    this.songId,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      id: json['id'],
      roomId: json['roomId'],
      hostId: json['hostId'],
      hostName: json['hostName'],
      audienceCount: json['audienceCount'],
      roomType: json['roomType'],
      roomStatus: json['roomStatus'],
      songId: json['songId'],
    );
  }
}
