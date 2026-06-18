import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/response_parser.dart';
import '../dtos/user_dto.dart';

class ProfileApiService {
  ProfileApiService(this._client);

  final DioClient _client;

  Future<UserInfoDto> getUserProfile(String userId) async {
    final response = await _client.get<dynamic>(
      '${ApiEndpoints.userGet}/$userId',
    );
    return ResponseParser.parseObject(
      response.data,
      UserInfoDto.fromJson,
      expectEnvelope: false,
    );
  }

  Future<bool> updateUserProfile(int userId, UserDto dto) async {
    final response = await _client.put<dynamic>(
      '${ApiEndpoints.userUpdate}/$userId',
      data: dto.toJson(),
    );
    final body = response.data;
    if (body is bool) {
      return body;
    }
    return true;
  }

  Future<bool> changePassword(int userId, ChangePasswordRequestDto dto) async {
    final response = await _client.post<dynamic>(
      '${ApiEndpoints.userChangePassword}/$userId',
      data: dto.toJson(),
    );
    final body = response.data;
    if (body is bool) {
      return body;
    }
    return true;
  }
}
