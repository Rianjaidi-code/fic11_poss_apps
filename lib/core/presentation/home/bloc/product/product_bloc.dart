import 'package:bloc/bloc.dart';
import 'package:fic11_pos_apps/data/datasources/product_local_datasources.dart';
import 'package:fic11_pos_apps/data/datasources/product_remote_datasources.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../data/models/response/product_response_model.dart';

part 'product_event.dart';
part 'product_state.dart';
part 'product_bloc.freezed.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRemoteDataSource _productRemoteDatasource;
  List<Product> products = [];
  ProductBloc(this._productRemoteDatasource) : super(const _Initial()) {
    on<_Fetch>((event, emit) async {
      emit(const ProductState.loading());
      final response = await _productRemoteDatasource.getProducts();
      response.fold(
        (l) => emit(ProductState.error(l)),
        (r) {
          products = r.data;
          emit(ProductState.success(r.data));
        },
      );
    });

    on<_FetchLocal>((event, emit) async {
      emit(const ProductState.loading());
      final localPproducts =
          await ProductLocalDataSources.instance.getAllProduct();
      products = localPproducts;

      emit(ProductState.success(products));
    });

    on<_FetchByCategory>((event, emit) async {
      emit(const ProductState.loading());

      final newProducts = event.category == 'all'
          ? products
          : products
              .where((element) => element.category == event.category)
              .toList();

      emit(ProductState.success(newProducts));
    });
  }
}
