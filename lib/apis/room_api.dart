import 'package:star_maker/apis/api.dart';

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
}
