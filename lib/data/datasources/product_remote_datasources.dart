import 'package:dartz/dartz.dart';
import 'package:fic11_pos_apps/data/datasources/auth_local_datasources.dart';
import 'package:fic11_pos_apps/data/models/request/product_request_model.dart';
import 'package:fic11_pos_apps/data/models/response/add_product_response_model.dart';
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

  Future<Either<String, AddProductResponseModel>> addProduct(
      ProductRequestModel productRequestModel) async {
    final authData = await AuthLocalDataSource().getAuthData();

    final Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${authData.token}',
    };

    var request = http.MultipartRequest(
        'POST', Uri.parse('${Variables.baseUrl}/api/products'));
    request.fields.addAll(productRequestModel.toMap());
    request.files.add(await http.MultipartFile.fromPath(
        'image', productRequestModel.image.path));
    // request.headers.addAll(headers);

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    final String body = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      print('ini nilai right: $body');
      return right(AddProductResponseModel.fromJson(body));
    } else {
      print('ini nilai left: $body');
      return left(body);
    }
  }
}
