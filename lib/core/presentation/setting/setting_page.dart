import 'package:fic11_pos_apps/core/constants/colors.dart';
import 'package:fic11_pos_apps/core/presentation/auth/pages/login_page.dart';
import 'package:fic11_pos_apps/core/presentation/home/bloc/logout/logout_bloc.dart';
import 'package:fic11_pos_apps/core/presentation/home/bloc/product/product_bloc.dart';
import 'package:fic11_pos_apps/data/datasources/auth_local_datasources.dart';
import 'package:fic11_pos_apps/data/datasources/product_local_datasources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
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
                      content: Text('Sync Data Success'),
                    ),
                  );
                },
              );
            },
            builder: (context, state) {
              return state.maybeWhen(
                  orElse: () {
                    return ElevatedButton(
                      onPressed: () {
                        context
                            .read<ProductBloc>()
                            .add(const ProductEvent.fetch());
                      },
                      child: const Text('Sync Data'),
                    );
                  },
                  loading: () => Center(
                        child: const CircularProgressIndicator(),
                      ));
            },
          ),
          const Divider(),
          ElevatedButton(
              onPressed: () {
                BlocConsumer<LogoutBloc, LogoutState>(
                  listener: (context, state) {
                    state.maybeMap(
                      orElse: () {},
                      success: (_) {
                        AuthLocalDataSource().removeAuthData();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()));
                      },
                    );
                  },
                  builder: (context, state) {
                    return IconButton(
                      onPressed: () {
                        context
                            .read<LogoutBloc>()
                            .add(const LogoutEvent.logout());
                      },
                      icon: const Icon(Icons.logout),
                    );
                  },
                );
              },
              child: Text('Logout')),
          const Divider(),
        ],
      ),
    );
  }
}
