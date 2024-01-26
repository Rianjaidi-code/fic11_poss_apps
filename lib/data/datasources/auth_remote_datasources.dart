import 'package:dartz/dartz.dart';
import 'package:fic11_pos_apps/core/constants/variabels.dart';
import 'package:fic11_pos_apps/data/datasources/auth_local_datasources.dart';
import 'package:fic11_pos_apps/data/models/response/auth_response_model.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart%20';

class AuthRemoteDatasource {
  Future<Either<String, AuthResponseModel>> login(
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('${Variables.baseUrl}/api/login'),
      body: {
        'email': email,
        'password': password,
      },
    );
    if (response.statusCode == 200) {
      return right(AuthResponseModel.fromJson(response.body));
    } else {
      return left(response.body);
    }
  }

  Future<Either<String, String>> logout() async {
    final authData = await AuthLocalDataSource().getAuthData();
    final response = await http.post(
      Uri.parse('${Variables.baseUrl}/api/logout'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${authData.token}'
      },
    );
    if (response.statusCode == 200) {
      return right(response.body);
    } else {
      return left(response.body);
    }
  }
}
