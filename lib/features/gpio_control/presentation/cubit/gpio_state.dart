import 'package:equatable/equatable.dart';
import '../../domain/entities/gpio_pin.dart';

class GPIOState extends Equatable {
  final List<GPIOPin> pins;
  final bool isLoading;
  final String? error;

  const GPIOState({
    this.pins = const [],
    this.isLoading = false,
    this.error = '',
  });

  GPIOState copyWith({
    List<GPIOPin>? pins,
    bool? isLoading,
    String? error,
  }) {
    return GPIOState(
      pins: pins ?? this.pins,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [pins, isLoading, error];
}
