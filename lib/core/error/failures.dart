abstract class Failure {
  final String message;
  const Failure(this.message);
}

class GPIOFailure extends Failure {
  const GPIOFailure(super.message);
}
