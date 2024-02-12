import 'package:star_maker/apis/api.dart';
import 'package:star_maker/models/room_model.dart';

import 'package:star_maker/utils/string.dart';

class RoomApi {
  createRoom(Map<String, Object> data) async {
    var url = BASE_URL + 'room/create';

    var response = await Api.execute(
      url: url,
      data: data,
    );

    if (!response['error']) {
      print(response);
    }
  }

  endRoom(String roomID) async {
    var url = BASE_URL + 'room/update/status';
    var data = {
      'room_id': roomID,
      'room_status': 'ended',
    };
    var response = await Api.execute(
      url: url,
      data: data,
    );
    if (!response['error']) {
      print(response);
    }
  }

  updateRoomCount(String roomID, int count) async {
    var url = BASE_URL + 'room/update/count';
    var data = {
      'room_id': roomID,
      'audience_count': count,
    };
    var response = await Api.execute(
      url: url,
      data: data,
    );
    if (!response['error']) {
      print(response);
    }
  }

  Future<List<RoomModel>> getMultiRooms() async {
    var url = BASE_URL + 'rooms/multi/all';
    var data = {};
    List<RoomModel> allRooms = [];

    var response = await Api.execute(
      url: url,
      data: data,
    );

    if (!response['error']) {
      for (var room in response['rooms']) {
        allRooms.add(RoomModel.fromJson(room));
      }
    }
    return allRooms;
  }
  Future<List<RoomModel>> getSoloRooms() async {
    var url = BASE_URL + 'rooms/solo/all';
    var data = {};
    List<RoomModel> allRooms = [];

    var response = await Api.execute(
      url: url,
      data: data,
    );

    if (!response['error']) {
      for (var room in response['rooms']) {
        allRooms.add(RoomModel.fromJson(room));
      }
    }
    return allRooms;
  }
}
