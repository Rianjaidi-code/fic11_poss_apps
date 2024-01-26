import 'package:fic11_pos_apps/core/extensions/int_ext.dart';
import 'package:fic11_pos_apps/core/presentation/home/bloc/checkout/checkout_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../components/spaces.dart';
import '../../../constants/colors.dart';

class ProcessButton extends StatelessWidget {
  final int price;
  final VoidCallback onPressed;

  const ProcessButton({
    super.key,
    required this.price,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(6.0)),
          color: AppColors.primary,
        ),
        child: Row(
          children: [
            BlocBuilder<CheckoutBloc, CheckoutState>(
              builder: (context, state) {
                return state.maybeWhen(
                  orElse: () => const Text(
                    'Rp. 0',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  success: (products, qty, total) => Text(
                    '${total.currencyFormatRp}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                );
              },
            ),
            const Spacer(),
            const Text(
              'Proses',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SpaceWidth(5.0),
            const Icon(
              Icons.chevron_right,
              color: AppColors.white,
            ),
          ],
        ),
      ),
    );
  }
}
