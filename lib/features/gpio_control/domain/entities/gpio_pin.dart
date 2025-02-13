class GPIOPin {
  final int pinNumber;
  final bool isInput;
  final String label;
  final bool value;

  GPIOPin({
    required this.pinNumber,
    required this.isInput,
    required this.label,
    required this.value,
  });
}
