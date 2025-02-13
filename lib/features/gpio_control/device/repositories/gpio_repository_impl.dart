import 'package:dart_periphery/dart_periphery.dart';

import '../../domain/entities/gpio_config.dart';
import '../../domain/repositories/gpio_repository.dart';
import '../mappers/gpio_config_mapper.dart';

class GPIORepositoryImpl implements GPIORepository {
  final Map<int, GPIO> _pins = {};

  @override
  Future<bool> setupPin(int pinNumber, bool isInput,
      {GPIOConfig? config}) async {
    try {
      GPIO gpio;

      if (config != null) {
        // Use advanced configuration
        final peripheryConfig = GPIOConfigMapper.toPeripheryConfig(config);
        gpio = GPIO.advanced(pinNumber, peripheryConfig);
      } else {
        // Use basic configuration
        final direction =
            isInput ? GPIOdirection.gpioDirIn : GPIOdirection.gpioDirOut;
        gpio = GPIO(pinNumber, direction);
      }

      _pins[pinNumber] = gpio;
      return true;
    } catch (e) {
      print('Error setting up GPIO pin: $e');
      return false;
    }
  }

  @override
  Future<bool> writePin(int pinNumber, bool value) async {
    try {
      final gpio = _pins[pinNumber];
      if (gpio == null) return false;
      gpio.write(value);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> readPin(int pinNumber) async {
    try {
      final gpio = _pins[pinNumber];
      if (gpio == null) return false;
      return gpio.read();
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> closePin(int pinNumber) async {
    try {
      final gpio = _pins[pinNumber];
      if (gpio == null) return false;
      gpio.dispose();
      _pins.remove(pinNumber);
      return true;
    } catch (e) {
      return false;
    }
  }
}
