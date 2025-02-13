import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/gpio_control/device/repositories/gpio_repository_impl.dart';
import 'features/gpio_control/domain/usecases/setup_pin.dart';
import 'features/gpio_control/presentation/cubit/gpio_cubit.dart';
import 'features/gpio_control/presentation/pages/gpio_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = GPIORepositoryImpl();

    return MaterialApp(
      title: 'GPIO Control',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context) => GPIOCubit(
          setupPin: SetupPin(repository),
          repository: repository,
        )..startPolling(),
        child: GPIOPage(),
      ),
    );
  }
}
