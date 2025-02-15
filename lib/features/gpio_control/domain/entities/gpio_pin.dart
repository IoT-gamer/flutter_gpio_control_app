class GPIOPin {
  final int pinNumber;
  final int chipNumber; // Added chip number
  final bool isInput;
  final String label;
  final bool value;

  GPIOPin({
    required this.pinNumber,
    required this.chipNumber, // Added chip number
    required this.isInput,
    required this.label,
    required this.value,
  });
}
