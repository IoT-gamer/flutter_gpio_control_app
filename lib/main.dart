import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/gpio_control/device/repositories/gpio_repository_impl.dart';
import 'features/gpio_control/domain/usecases/setup_pin.dart';
import 'features/gpio_control/presentation/cubit/gpio_cubit.dart';
import 'features/gpio_control/presentation/pages/gpio_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final GPIORepositoryImpl repository;
  late final GPIOCubit gpioCubit;
  late final AppLifecycleListener _lifecycleListener;

  @override
  void initState() {
    super.initState();
    repository = GPIORepositoryImpl();
    gpioCubit = GPIOCubit(
      setupPin: SetupPin(repository),
      repository: repository,
    )..startPolling();

    _lifecycleListener = AppLifecycleListener(
      onDetach: () {
        // Called when the application is detached (terminated)
        gpioCubit.closeAllPins();
      },
      onHide: () {
        // Called when the app is minimized or hidden
        gpioCubit.closeAllPins();
      },
      onExitRequested: () async {
        // Called when the user attempts to close the app
        await gpioCubit.closeAllPins();
        return AppExitResponse.exit;
      },
    );
  }

  @override
  void dispose() {
    _lifecycleListener.dispose();
    gpioCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GPIO Control',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: BlocProvider.value(
        value: gpioCubit,
        child: const GPIOPage(),
      ),
    );
  }
}
