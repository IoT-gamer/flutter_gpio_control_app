import '../../../../core/usecases/usecase.dart';
import '../entities/gpio_config.dart';
import '../repositories/gpio_repository.dart';

class SetupPin implements UseCase<bool, SetupPinParams> {
  final GPIORepository repository;

  SetupPin(this.repository);

  @override
  Future<bool> call(SetupPinParams params) async {
    return await repository.setupPin(
      params.pinNumber,
      params.isInput,
      config: params.config,
    );
  }
}

class SetupPinParams {
  final int pinNumber;
  final bool isInput;
  final GPIOConfig? config;

  SetupPinParams({
    required this.pinNumber,
    required this.isInput,
    this.config,
  });
}
