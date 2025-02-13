enum GPIODirection {
  input,
  output,
  outputLow,
  outputHigh,
}

enum GPIOEdge {
  none,
  rising,
  falling,
  both,
}

enum GPIOBias {
  default_,
  pullUp,
  pullDown,
  disable,
}

enum GPIODrive {
  default_,
  openDrain,
  openSource,
}

class GPIOConfig {
  final GPIODirection direction;
  final GPIOEdge edge;
  final GPIOBias bias;
  final GPIODrive drive;
  final bool inverted;
  final String label;

  GPIOConfig({
    required this.direction,
    this.edge = GPIOEdge.none,
    this.bias = GPIOBias.default_,
    this.drive = GPIODrive.default_,
    this.inverted = false,
    this.label = '',
  });
}
