import 'package:fic11_pos_apps/core/extensions/build_context_ext.dart';
import 'package:fic11_pos_apps/core/extensions/int_ext.dart';
import 'package:fic11_pos_apps/core/extensions/string_ext.dart';
import 'package:fic11_pos_apps/core/presentation/order/bloc/order/order_bloc.dart';
import 'package:fic11_pos_apps/core/presentation/order/models/order_model.dart';
import 'package:fic11_pos_apps/core/presentation/order/widgets/payment_success_dialog.dart';
import 'package:fic11_pos_apps/data/datasources/product_local_datasources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../components/buttons.dart';
import '../../../components/custom_text_field.dart';
import '../../../components/spaces.dart';
import '../../../constants/colors.dart';

class PaymentCashDialog extends StatefulWidget {
  final int price;
  const PaymentCashDialog({super.key, required this.price});

  @override
  State<PaymentCashDialog> createState() => _PaymentCashDialogState();
}

class _PaymentCashDialogState extends State<PaymentCashDialog> {
  TextEditingController?
      priceController; //TextEditingController(text: widget.price.currencyFormatRp);

  @override
  void initState() {
    priceController = TextEditingController(text: widget.price.currencyFormatRp);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Stack(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.highlight_off),
            color: AppColors.primary,
          ),
          const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 12.0),
              child: Text(
                'Pembayaran - Tunai',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SpaceHeight(16.0),
          CustomTextField(
            controller: priceController!,
            label: '',
            showLabel: false,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              final int priceValue = value.toIntegerFromText;
              priceController!.text = priceValue.currencyFormatRp;
              priceController!.selection = TextSelection.fromPosition(
                  TextPosition(offset: priceController!.text.length));
            },
          ),
          const SpaceHeight(16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Button.filled(
                onPressed: () {
                  // Ganti nilai priceController menjadi 'Uang Pas' (disesuaikan dengan logika Anda)
                  // Misalnya, Anda dapat mengatur nilai ke total harga atau nilai lainnya yang sesuai
                  // priceController = TextEditingController(text: widget.price.currencyFormatRp);
                },
                label: 'Uang Pas',
                disabled: true,
                textColor: AppColors.primary,
                fontSize: 13.0,
                width: 109.0,
                height: 50.0,
              ),
              const SpaceWidth(4.0),
              Expanded(
                child: Button.filled(
                  onPressed: () {
                    // Saat tombol "100000" ditekan, ganti nilai priceController menjadi '100000'
                    // priceController!.text = '100000';
                  },
                  label: '100000',
                  disabled: true,
                  textColor: AppColors.primary,
                  fontSize: 13.0,
                  height: 50.0,
                ),
              ),
            ],
          ),
          const SpaceHeight(30.0),
          BlocConsumer<OrderBloc, OrderState>(
            listener: (context, state) {
              state.maybeWhen(
                  orElse: () {},
                  success:
                      (data, qty, total, payment, nominal, idKasir, namaKasir) {
                    final orderModel = OrderModel(
                        paymentMethod: payment,
                        nominalBayar: nominal,
                        orders: data,
                        totalPrice: total * qty,
                        totalQuantity: qty,
                        idKasir: idKasir,
                        namaKasir: namaKasir,
                        transactionTime: DateFormat('yyyy-MM-ddTHH:mm:ss')
                            .format(DateTime.now()),
                        isSync: false);
                    ProductLocalDataSources.instance.saveOrder(orderModel);
                    context.pop();
                    showDialog(
                      context: context,
                      builder: (context) => const PaymentSuccessDialog(),
                    );
                  });
            },
            builder: (context, state) {
              return state.maybeWhen(orElse: () {
                return const SizedBox();
              }, success: (data, qty, total, payment, _, idKasir, namaKasir) {
                return Button.filled(
                  onPressed: () {
                    context.read<OrderBloc>().add(OrderEvent.addNominalBayar(
                        priceController!.text.toIntegerFromText));
                    // context.pop();
                    // showDialog(
                    //   context: context,
                    //   builder: (context) => const PaymentSuccessDialog(),
                    // );
                  },
                  label: 'Proses',
                );
              }, error: (message) {
                return const SizedBox();
              });
            },
          ),
        ],
      ),
    );
  }
}
