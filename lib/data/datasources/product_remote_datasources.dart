import 'package:dartz/dartz.dart';
import 'package:fic11_pos_apps/data/datasources/auth_local_datasources.dart';
import 'package:http/http.dart' as http;
import 'package:fic11_pos_apps/data/models/response/product_response_model.dart';

import '../../core/constants/variabels.dart';

class ProductRemoteDataSource {
  Future<Either<String, ProductResponseModel>> getProducts() async {
    final authData = await AuthLocalDataSource().getAuthData();
    final response = await http.get(
      Uri.parse('${Variables.baseUrl}/api/products'),
      headers: {
        "Connection": "Keep-Alive",
        'Authorization': 'Bearer ${authData.token}',
      },
    );

    if (response.statusCode == 200) {
      print(response.body);
      return right(ProductResponseModel.fromJson(response.body));
    } else {
      return left(response.body);
    }
  }
}
