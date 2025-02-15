import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/gpio_config.dart';
import '../../domain/entities/gpio_pin.dart';
import '../../domain/repositories/gpio_repository.dart';
import '../../domain/usecases/setup_pin.dart';
import 'gpio_state.dart';

class GPIOCubit extends Cubit<GPIOState> {
  final SetupPin setupPin;
  final GPIORepository repository;

  GPIOCubit({
    required this.setupPin,
    required this.repository,
  }) : super(const GPIOState());

  Future<void> setupNewPin({
    required int pinNumber,
    required bool isInput,
    required String label,
    GPIOConfig? config,
  }) async {
    emit(state.copyWith(isLoading: true, error: null));

    final effectiveConfig = config ??
        GPIOConfig(
          direction: isInput ? GPIODirection.input : GPIODirection.output,
          label: label,
          chip: 0, // Default to chip 0 if no config provided
        );

    final result = await setupPin(
      SetupPinParams(
        pinNumber: pinNumber,
        isInput: isInput,
        config: effectiveConfig,
      ),
    );

    if (result) {
      final newPin = GPIOPin(
        pinNumber: pinNumber,
        chipNumber: effectiveConfig.chip, // Include chip number in pin
        isInput: isInput,
        label: label,
        value: false,
      );

      emit(state.copyWith(
        isLoading: false,
        pins: [...state.pins, newPin],
      ));
    } else {
      emit(state.copyWith(
        isLoading: false,
        error: 'Failed to setup pin $pinNumber on chip ${effectiveConfig.chip}',
      ));
    }
  }

  Future<void> togglePin(int pinNumber, bool value) async {
    emit(state.copyWith(isLoading: true, error: null));

    final pin = state.pins.firstWhere(
      (p) => p.pinNumber == pinNumber,
      orElse: () => throw Exception('Pin not found'),
    );

    final result = await repository.writePin(pinNumber, value);
    if (result) {
      final updatedPins = state.pins.map((p) {
        if (p.pinNumber == pinNumber) {
          return GPIOPin(
            pinNumber: p.pinNumber,
            chipNumber: pin.chipNumber,
            isInput: p.isInput,
            label: p.label,
            value: value,
          );
        }
        return p;
      }).toList();

      emit(state.copyWith(
        isLoading: false,
        pins: updatedPins,
      ));
    } else {
      emit(state.copyWith(
        isLoading: false,
        error: 'Failed to write to pin $pinNumber on chip ${pin.chipNumber}',
      ));
    }
  }

  Future<void> readPin(int pinNumber) async {
    final pin = state.pins.firstWhere(
      (p) => p.pinNumber == pinNumber,
      orElse: () => throw Exception('Pin not found'),
    );

    final result = await repository.readPin(pinNumber);
    final updatedPins = state.pins.map((p) {
      if (p.pinNumber == pinNumber) {
        return GPIOPin(
          pinNumber: p.pinNumber,
          chipNumber: pin.chipNumber,
          isInput: p.isInput,
          label: p.label,
          value: result,
        );
      }
      return p;
    }).toList();

    emit(state.copyWith(pins: updatedPins));
  }

  void startPolling() {
    Future.doWhile(() async {
      for (final pin in state.pins) {
        if (pin.isInput) {
          await readPin(pin.pinNumber);
        }
      }
      await Future.delayed(const Duration(milliseconds: 100));
      return true;
    });
  }

  Future<void> closeAllPins() async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      for (final pin in state.pins) {
        final success = await repository.closePin(pin.pinNumber);
        if (!success) {
          emit(state.copyWith(
            isLoading: false,
            error:
                'Failed to close pin ${pin.pinNumber} on chip ${pin.chipNumber}',
          ));
          return;
        }
      }

      emit(state.copyWith(
        isLoading: false,
        pins: [],
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Error during cleanup: $e',
      ));
    }
  }
}
