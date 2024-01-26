// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:fic11_pos_apps/core/presentation/order/bloc/order/order_bloc.dart';
import 'package:fic11_pos_apps/core/presentation/order/bloc/qris/qris_bloc.dart';
import 'package:fic11_pos_apps/core/presentation/order/widgets/payment_success_dialog.dart';
import 'package:flutter/material.dart';

import 'package:fic11_pos_apps/core/extensions/build_context_ext.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../data/datasources/product_local_datasources.dart';
import '../../../components/spaces.dart';
import '../../../constants/colors.dart';
import '../models/order_model.dart';

class PaymentQrisDialog extends StatefulWidget {
  final int price;
  const PaymentQrisDialog({
    Key? key,
    required this.price,
  }) : super(key: key);

  @override
  State<PaymentQrisDialog> createState() => _PaymentQrisDialogState();
}

class _PaymentQrisDialogState extends State<PaymentQrisDialog> {
  String orderId = '';
  Timer? timer;
  @override
  void initState() {
    orderId = DateTime.now().microsecondsSinceEpoch.toString();
    context
        .read<QrisBloc>()
        .add(QrisEvent.generateQRCode(orderId, widget.price));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      contentPadding: const EdgeInsets.all(0),
      backgroundColor: AppColors.primary,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              'Pembayaran QRIS',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w700,
                height: 0,
              ),
            ),
          ),
          const SpaceHeight(6.0),
          BlocBuilder<OrderBloc, OrderState>(
            builder: (context, state) {
              return state.maybeWhen(
                orElse: () {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
                success: (data, qty, total, paymentMethod, nominal, idKasir,
                    namaKasir) {
                  return Container(
                    width: context.deviceWidth,
                    padding: const EdgeInsets.all(14.0),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      color: AppColors.white,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // SizedBox(
                        //   width: 256.0,
                        //   height: 256.0,
                        //   child: QrImageView(
                        //     data: 's.id/batch11',
                        //     version: QrVersions.auto,
                        //   ),Qris
                        // ),
                        BlocListener<QrisBloc, QrisState>(
                          listener: (context, state) {
                            state.maybeWhen(
                              orElse: () {
                                return;
                              },
                              qrisResponse: (data) {
                                const onSec = Duration(seconds: 5);
                                timer = Timer.periodic(onSec, (timer) {
                                  context.read<QrisBloc>().add(
                                      QrisEvent.checkPaymentStatus(orderId));
                                });
                              },
                              success: (message) {
                                timer?.cancel();
                                final orderModel = OrderModel(
                                    paymentMethod: paymentMethod,
                                    nominalBayar: total,
                                    orders: data,
                                    totalPrice: total,
                                    totalQuantity: qty,
                                    idKasir: idKasir,
                                    namaKasir: namaKasir,
                                    transactionTime:
                                        DateFormat('yyyy-MM-ddTHH:mm:ss')
                                            .format(DateTime.now()),
                                    isSync: false);
                                ProductLocalDataSources.instance
                                    .saveOrder(orderModel);
                                context.pop();
                                showDialog(
                                  context: context,
                                  builder: (context) =>
                                      const PaymentSuccessDialog(),
                                );
                              },
                            );
                          },
                          child: BlocBuilder<QrisBloc, QrisState>(
                            builder: (context, state) {
                              return state.maybeWhen(orElse: () {
                                return SizedBox();
                              }, loading: () {
                                return Container(
                                  width: 256.0,
                                  height: 256.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    color: Colors.white,
                                  ),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }, qrisResponse: (data) {
                                return Container(
                                  width: 256.0,
                                  height: 256.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    color: Colors.white,
                                  ),
                                  child: Center(
                                      child: Image.network(
                                    data.actions!.first.url!,
                                  )),
                                );
                              });
                            },
                          ),
                        ),
                        SpaceHeight(5.0),
                        Text(
                          'Scan QRIS untuk melakukan pembayaran',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
