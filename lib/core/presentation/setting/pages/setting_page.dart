import 'package:fic11_pos_apps/core/constants/colors.dart';
import 'package:fic11_pos_apps/core/extensions/build_context_ext.dart';
import 'package:fic11_pos_apps/core/presentation/auth/pages/login_page.dart';
import 'package:fic11_pos_apps/core/presentation/home/bloc/logout/logout_bloc.dart';
import 'package:fic11_pos_apps/core/presentation/home/bloc/product/product_bloc.dart';
import 'package:fic11_pos_apps/core/presentation/order/models/order_model.dart';
import 'package:fic11_pos_apps/core/presentation/setting/pages/manage_printer_page.dart';
import 'package:fic11_pos_apps/core/presentation/setting/pages/manage_product_page.dart';
import 'package:fic11_pos_apps/core/presentation/setting/pages/save_server_key_page.dart';
import 'package:fic11_pos_apps/core/presentation/setting/pages/sync_data_page.dart';
import 'package:fic11_pos_apps/data/datasources/auth_local_datasources.dart';
import 'package:fic11_pos_apps/data/datasources/product_local_datasources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../assets/assets.gen.dart';
import '../../../components/menu_button.dart';
import '../../../components/spaces.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Assets.images.backgroundApps.image(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fill,
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      MenuButton(
                        iconPath: Assets.images.manageProduct.path,
                        label: 'Kelola Produk',
                        onPressed: () =>
                            context.push(const ManageProductPage()),
                        isImage: true,
                      ),
                      const SpaceWidth(15.0),
                      MenuButton(
                        iconPath: Assets.images.managePrinter.path,
                        label: 'Kelola Printer',
                        onPressed: () {
                          context.push(const ManagePrinterPage());
                        }, //=> context.push(const ManagePrinterPage()),
                        isImage: true,
                      ),
                      const SpaceHeight(60.0),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      MenuButton(
                        iconPath: Assets.images.manageProduct.path,
                        label: 'QRIS Server Key',
                        onPressed: () => context.push(SaveServerKeyPage()),
                        isImage: true,
                      ),
                      const SpaceWidth(15.0),
                      MenuButton(
                        iconPath: Assets.images.managePrinter.path,
                        label: 'Sinkronisasi Data',
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SyncDataPage()));
                        }, //=> context.push(const ManagePrinterPage()),
                        isImage: true,
                      ),
                    ],
                  ),
                ),
                const SpaceHeight(30.0),
                const Divider(),
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
                    return ElevatedButton(
                      onPressed: () {
                        context
                            .read<LogoutBloc>()
                            .add(const LogoutEvent.logout());
                      },
                      child: const Text('Logout'),
                    );
                  },
                ),
                const Divider(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
