import 'package:udetxen/shared/constants/http_route.dart';
import 'package:udetxen/shared/models/index.dart';
import 'package:udetxen/shared/services/api_service.dart';
import 'package:udetxen/shared/types/index.dart';

class TrackService extends ApiService {
  ApiResponse<List<Track>> getDetailedTracks() {
    return getList<Track>(
        HttpRoute.getDetailedTracks, (item) => Track.fromJson(item));
  }

  ApiResponse<Track> getTrackById(String id) {
    return get<Track>(
        HttpRoute.getTrackById(id), (item) => Track.fromJson(item));
  }
}
