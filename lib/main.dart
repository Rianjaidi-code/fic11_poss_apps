import 'package:fic11_pos_apps/core/presentation/auth/bloc/bloc/login_bloc.dart';
import 'package:fic11_pos_apps/core/presentation/auth/pages/login_page.dart';
import 'package:fic11_pos_apps/core/presentation/history/bloc/history/history_bloc.dart';
import 'package:fic11_pos_apps/core/presentation/home/bloc/checkout/checkout_bloc.dart';
import 'package:fic11_pos_apps/core/presentation/home/bloc/logout/logout_bloc.dart';
import 'package:fic11_pos_apps/core/presentation/home/bloc/product/product_bloc.dart';
import 'package:fic11_pos_apps/core/presentation/home/pages/dashboard.dart';
import 'package:fic11_pos_apps/core/presentation/order/bloc/order/order_bloc.dart';
import 'package:fic11_pos_apps/core/presentation/order/bloc/qris/qris_bloc.dart';
import 'package:fic11_pos_apps/core/presentation/setting/bloc/sync_order/sync_order_bloc.dart';
import 'package:fic11_pos_apps/data/datasources/auth_local_datasources.dart';
import 'package:fic11_pos_apps/data/datasources/auth_remote_datasources.dart';
import 'package:fic11_pos_apps/data/datasources/midtrans_remote_datasources.dart';
import 'package:fic11_pos_apps/data/datasources/order_remote_datasources.dart';
import 'package:fic11_pos_apps/data/datasources/product_remote_datasources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/constants/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginBloc(AuthRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => LogoutBloc(AuthRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => ProductBloc(ProductRemoteDataSource())
            ..add(const ProductEvent.fetchLocal()),
        ),
        BlocProvider(create: (context) => CheckoutBloc()),
        BlocProvider(create: (context) => OrderBloc()),
        BlocProvider(
          create: (context) => QrisBloc(MidtransRemoteDatasource()),
        ),
        BlocProvider(create: (context) => HistoryBloc()),
        BlocProvider(
          create: (context) => SyncOrderBloc(OrderRemoteDataSource()),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          useMaterial3: true,
          textTheme: GoogleFonts.quicksandTextTheme(
            Theme.of(context).textTheme,
          ),
          appBarTheme: AppBarTheme(
            color: AppColors.white,
            elevation: 0,
            titleTextStyle: GoogleFonts.quicksand(
              color: AppColors.primary,
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
            iconTheme: const IconThemeData(
              color: AppColors.primary,
            ),
          ),
        ),
        home: FutureBuilder<bool>(
          future: AuthLocalDataSource().isAuth(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data == true) {
              return const DashboardPage();
            } else {
              return const LoginPage();
            }
          },
        ),
      ),
    );
  }
}
