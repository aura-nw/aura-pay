enum GasPriceStep implements Comparable<GasPriceStep> {
  low(0.001),
  average(0.0025),
  high(0.004);

  final double value;

  const GasPriceStep(this.value);

  @override
  int compareTo(GasPriceStep other) => (value -  other.value).round();
}