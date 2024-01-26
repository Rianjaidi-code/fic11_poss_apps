import 'package:fic11_pos_apps/data/datasources/auth_local_datasources.dart';
import 'package:fic11_pos_apps/data/models/request/order_request_model.dart';
import 'package:http/http.dart' as http;

import '../../core/constants/variabels.dart';

class OrderRemoteDataSource {
  Future<bool> sendOrder(OrderRequestModel requestModel) async {
    final url = Uri.parse('${Variables.baseUrl}/api/orders');
    final authData = await AuthLocalDataSource().getAuthData();

    final Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${authData.token}',
    };
    print(requestModel.toJson());
    final response = await http.post(
      url,
      headers: headers,
      body: requestModel.toJson(),
    );

    print(response);

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }
}
