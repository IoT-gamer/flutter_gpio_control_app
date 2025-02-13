import 'package:dart_periphery/dart_periphery.dart';
import '../../domain/entities/gpio_config.dart';

class GPIOConfigMapper {
  static GPIOdirection mapDirection(GPIODirection direction) {
    switch (direction) {
      case GPIODirection.input:
        return GPIOdirection.gpioDirIn;
      case GPIODirection.output:
        return GPIOdirection.gpioDirOut;
      case GPIODirection.outputLow:
        return GPIOdirection.gpioDirOutLow;
      case GPIODirection.outputHigh:
        return GPIOdirection.gpioDirOutHigh;
    }
  }

  static GPIOedge mapEdge(GPIOEdge edge) {
    switch (edge) {
      case GPIOEdge.none:
        return GPIOedge.gpioEdgeNone;
      case GPIOEdge.rising:
        return GPIOedge.gpioEdgeRising;
      case GPIOEdge.falling:
        return GPIOedge.gpioEdgeFalling;
      case GPIOEdge.both:
        return GPIOedge.gpioEdgeBoth;
    }
  }

  static GPIObias mapBias(GPIOBias bias) {
    switch (bias) {
      case GPIOBias.default_:
        return GPIObias.gpioBiasDefault;
      case GPIOBias.pullUp:
        return GPIObias.gpioBiasPullUp;
      case GPIOBias.pullDown:
        return GPIObias.gpioBiasPullDown;
      case GPIOBias.disable:
        return GPIObias.gpioBiasDisable;
    }
  }

  static GPIOdrive mapDrive(GPIODrive drive) {
    switch (drive) {
      case GPIODrive.default_:
        return GPIOdrive.gpioDriveDefault;
      case GPIODrive.openDrain:
        return GPIOdrive.gpioDriveOpenDrain;
      case GPIODrive.openSource:
        return GPIOdrive.gpioDriveOpenSource;
    }
  }

  static GPIOconfig toPeripheryConfig(GPIOConfig config) {
    return GPIOconfig(
        mapDirection(config.direction),
        mapEdge(config.edge),
        mapBias(config.bias),
        mapDrive(config.drive),
        config.inverted,
        config.label);
  }
}
