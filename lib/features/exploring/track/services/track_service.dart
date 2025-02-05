import 'package:rvnow/shared/constants/http_route.dart';
import 'package:rvnow/shared/models/index.dart';
import 'package:rvnow/shared/services/api_service.dart';
import 'package:rvnow/shared/types/index.dart';

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
