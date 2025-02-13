import '../entities/gpio_config.dart';

abstract class GPIORepository {
  Future<bool> setupPin(int pinNumber, bool isInput, {GPIOConfig? config});
  Future<bool> writePin(int pinNumber, bool value);
  Future<bool> readPin(int pinNumber);
  Future<bool> closePin(int pinNumber);
}
