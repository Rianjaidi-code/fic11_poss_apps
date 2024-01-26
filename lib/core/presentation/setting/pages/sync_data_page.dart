import 'package:fic11_pos_apps/core/components/spaces.dart';
import 'package:fic11_pos_apps/core/presentation/home/bloc/product/product_bloc.dart';
import 'package:fic11_pos_apps/core/presentation/order/bloc/order/order_bloc.dart';
import 'package:fic11_pos_apps/core/presentation/setting/bloc/sync_order/sync_order_bloc.dart';
import 'package:fic11_pos_apps/data/datasources/auth_local_datasources.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/datasources/product_local_datasources.dart';
import '../../../constants/colors.dart';

class SyncDataPage extends StatefulWidget {
  const SyncDataPage({super.key});

  @override
  State<SyncDataPage> createState() => _SyncDataPageState();
}

class _SyncDataPageState extends State<SyncDataPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sync Data'),
        centerTitle: true,
      ),
      //textfield untuk input server key
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          //button sync data product
          BlocConsumer<ProductBloc, ProductState>(
            listener: (context, state) {
              state.maybeMap(
                orElse: () {},
                success: (_) async {
                  await ProductLocalDataSources.instance.removeAllProduct();
                  await ProductLocalDataSources.instance.insertAllProduct(
                    _.products.toList(),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: AppColors.primary,
                      content: Text('Sync Data Product Success'),
                    ),
                  );
                },
              );
            },
            builder: (context, state) {
              return state.maybeWhen(
                  orElse: () {
                    return ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(AppColors.card_2)),
                      onPressed: () {
                        context
                            .read<ProductBloc>()
                            .add(const ProductEvent.fetch());
                      },
                      child: const Text(
                        'Sync Data Product',
                        style: TextStyle(color: AppColors.black),
                      ),
                    );
                  },
                  loading: () => Center(
                        child: const CircularProgressIndicator(),
                      ));
            },
          ),
          SpaceHeight(20),
          //button sync data order
          BlocConsumer<SyncOrderBloc, SyncOrderState>(
            listener: (context, state) {
              state.maybeMap(
                orElse: () {},
                success: (_) async {
                  // await ProductLocalDataSources.instance.removeAllProduct();
                  // await ProductLocalDataSources.instance.insertAllProduct(
                  //   _.products.toList(),
                  // );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: AppColors.primary,
                      content: Text('Sync Data Order Success'),
                    ),
                  );
                },
              );
            },
            builder: (context, state) {
              return state.maybeWhen(
                  orElse: () {
                    return ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(AppColors.card_2)),
                      onPressed: () {
                        context
                            .read<SyncOrderBloc>()
                            .add(const SyncOrderEvent.sendOrder());
                      },
                      child: const Text(
                        'Sync Data Orders',
                        style: TextStyle(color: AppColors.black),
                      ),
                    );
                  },
                  loading: () => Center(
                        child: const CircularProgressIndicator(),
                      ));
            },
          ),
        ],
      ),
    );
  }
}
