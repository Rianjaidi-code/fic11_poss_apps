import 'package:bloc/bloc.dart';
import 'package:fic11_pos_apps/core/presentation/order/models/order_model.dart';
import 'package:fic11_pos_apps/data/datasources/product_local_datasources.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'history_event.dart';
part 'history_state.dart';
part 'history_bloc.freezed.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  HistoryBloc() : super(const _Initial()) {
    on<_Fetch>((event, emit) async {
      emit(const HistoryState.loading());
      final data = await ProductLocalDataSources.instance.getAllOrder();
      emit(HistoryState.success(data));
    });
  }
}
