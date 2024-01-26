import 'package:fic11_pos_apps/core/assets/assets.gen.dart';
import 'package:fic11_pos_apps/core/presentation/home/bloc/checkout/checkout_bloc.dart';
import 'package:fic11_pos_apps/core/presentation/home/models/order_item.dart';
import 'package:fic11_pos_apps/core/presentation/order/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../components/menu_button.dart';
import '../../../components/spaces.dart';
import '../../../constants/colors.dart';
import '../bloc/order/order_bloc.dart';
import '../widgets/order_card.dart';
import '../widgets/payment_cash_dialog.dart';
import '../widgets/payment_qris_dialog.dart';
import '../widgets/process_button.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final indexValue = ValueNotifier(0);

  // final List<OrderModel> orders = [
  //   OrderModel(
  //     image: Assets.images.f1.path,
  //     name: 'Nutty Oat Latte',
  //     price: 39000,
  //   ),
  //   OrderModel(
  //     image: Assets.images.f2.path,
  //     name: 'Iced Latte',
  //     price: 24000,
  //   ),
  // ];

  List<OrderItem> orders = [];

  int totalPrice = 0;

  int calculateTotalPrice(List<OrderItem> orders) {
    // int totalPrice = 0;
    // for (final order in orders) {
    //   totalPrice += order.price;
    // }
    return orders.fold(
        0,
        (previousValue, element) =>
            previousValue + element.product.price * element.quantity);
  }

  @override
  void initState() {
    // context.read<OrderBloc>().add(OrderEvent.started());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const paddingHorizontal = EdgeInsets.symmetric(horizontal: 16.0);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Assets.images.backgroundApps.image(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fill,
            ),
            BlocBuilder<CheckoutBloc, CheckoutState>(
              builder: (context, state) {
                return state.maybeWhen(
                  orElse: () {
                    return const Center(
                      child: Text('No Data'),
                    );
                  },
                  success: (data, qty, total) {
                    if (data.isEmpty) {
                      return const Center(
                        child: Text('No Data'),
                      );
                    }
                    orders = data;
                    totalPrice = total;
                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      itemCount: data.length,
                      separatorBuilder: (context, index) =>
                          const SpaceHeight(20.0),
                      itemBuilder: (context, index) => OrderCard(
                        padding: paddingHorizontal,
                        data: data[index],
                        onDeleteTap: () {
                          // data.removeAt(index);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BlocBuilder<CheckoutBloc, CheckoutState>(
              builder: (context, state) {
                return state.maybeWhen(
                  orElse: () {
                    return const SizedBox();
                  },
                  success: (data, qty, total) {
                    return ValueListenableBuilder(
                      valueListenable: indexValue,
                      builder: (context, value, _) => Row(
                        children: [
                          const SpaceWidth(10.0),
                          MenuButton(
                            iconPath: Assets.icons.cash.path,
                            label: 'Tunai',
                            isActive: value == 1,
                            onPressed: () {
                              indexValue.value = 1;
                              context.read<OrderBloc>().add(
                                  OrderEvent.addPaymentMethod('Tunai', data));
                            },
                          ),
                          const SpaceWidth(10.0),
                          MenuButton(
                              iconPath: Assets.icons.qrCode.path,
                              label: 'QRIS',
                              isActive: value == 2,
                              onPressed: () {
                                indexValue.value = 2;
                                context.read<OrderBloc>().add(
                                    OrderEvent.addPaymentMethod('Tunai', data));
                              }),
                          const SpaceWidth(10.0),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            const SpaceHeight(20.0),
            ProcessButton(
              price: 0,
              onPressed: () async {
                if (indexValue.value == 0) {
                } else if (indexValue.value == 1) {
                  showDialog(
                    context: context,
                    builder: (context) => PaymentCashDialog(
                      price: totalPrice,
                    ),
                  );
                } else if (indexValue.value == 2) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => PaymentQrisDialog(
                      price: totalPrice,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
