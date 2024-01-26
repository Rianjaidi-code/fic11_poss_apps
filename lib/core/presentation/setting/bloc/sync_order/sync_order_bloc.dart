// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:fic11_pos_apps/data/datasources/product_local_datasources.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:fic11_pos_apps/data/datasources/order_remote_datasources.dart';
import 'package:fic11_pos_apps/data/models/request/order_request_model.dart';

part 'sync_order_bloc.freezed.dart';
part 'sync_order_event.dart';
part 'sync_order_state.dart';

class SyncOrderBloc extends Bloc<SyncOrderEvent, SyncOrderState> {
  final OrderRemoteDataSource orderRemoteDataSource;
  SyncOrderBloc(
    this.orderRemoteDataSource,
  ) : super(const _Initial()) {
    on<_SendOrder>((event, emit) async {
      emit(const SyncOrderState.loading());
      //get order from local is sync is 0
      final orderIsSyncZero =
          await ProductLocalDataSources.instance.getOrderByIsSync();
      for (final order in orderIsSyncZero) {
        final orderItems = await ProductLocalDataSources.instance
            .getOrderItemByOrderIdLocal(order.id!);

        final orderRequest = OrderRequestModel(
          transactionTime: order.transactionTime,
          kasirId: order.idKasir,
          totalPrice: order.totalPrice,
          totalItem: order.totalQuantity,
          paymentMethod: order.paymentMethod,
          orderItems: orderItems
              // .map((e) => OrderItemModel(
              //     productId: e.product.id!,
              //     quantity: e.quantity,
              //     totalPrice: e.quantity * e.product.price))
              // .toList(),
        );
        final response = await orderRemoteDataSource.sendOrder(orderRequest);

        if (response) {
          await ProductLocalDataSources.instance
              .updateIsSyncOrderById(order.id!);
        }
      }

      emit(const SyncOrderState.success());

      // if (response) {
      //   emit(const SyncOrderState.success());
      // } else {
      //   emit(const SyncOrderState.error('Failed to send order'));
      // }
    });
  }
}
