import 'package:cached_network_image/cached_network_image.dart';
import 'package:fic11_pos_apps/core/constants/variabels.dart';
import 'package:fic11_pos_apps/core/extensions/int_ext.dart';
import 'package:fic11_pos_apps/core/presentation/home/bloc/checkout/checkout_bloc.dart';
import 'package:fic11_pos_apps/data/models/response/product_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../components/spaces.dart';
import '../../../constants/colors.dart';

class ProductCard extends StatelessWidget {
  final Product data;
  final VoidCallback onCartButton;

  const ProductCard({
    super.key,
    required this.data,
    required this.onCartButton,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1, color: AppColors.card_2),
              borderRadius: BorderRadius.circular(19),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.disabled.withOpacity(0.4),
                  ),
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius.all(Radius.circular(100.0)),
                    child: CachedNetworkImage(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      imageUrl: "${Variables.imageBaseUrl}${data.image}",
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(
                        Icons.food_bank_outlined,
                        size: 80,
                      ),
                    ),
                  ),
                ),
              ),
              const SpaceHeight(8.0),
              Text(
                data.name,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SpaceHeight(3.0),
              Text(
                data.stock.toString(),
                style: const TextStyle(
                  color: AppColors.red,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
              const SpaceHeight(3.0),
              Text(
                data.category,
                style: const TextStyle(
                  color: AppColors.grey,
                  fontSize: 12,
                ),
              ),
              const SpaceHeight(3.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    data.price.currencyFormatRp,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      context
                          .read<CheckoutBloc>()
                          .add(CheckoutEvent.addCheckout(data));
                    },
                    child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(9.0)),
                          color: AppColors.red,
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ) //Assets.icons.orders.svg(),
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
        BlocBuilder<CheckoutBloc, CheckoutState>(
          builder: (context, state) {
            return state.maybeWhen(
              orElse: () => SizedBox(),
              success: (products, qty, price) {
                if (qty == 0) {
                  return SizedBox();
                }
                return products.any((element) => element.product == data)
                    ? products
                                .firstWhere(
                                    (element) => element.product == data)
                                .quantity >
                            0
                        ? Positioned(
                            top: 8,
                            right: 8,
                            child: CircleAvatar(
                              backgroundColor: AppColors.primary,
                              child: Text(
                                products
                                    .firstWhere(
                                        (element) => element.product == data)
                                    .quantity
                                    .toString(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 10),
                              ),
                            ),
                          )
                        : SizedBox()
                    : SizedBox();
              },
            );
          },
        )
      ],
    );
  }
}
