enum GasPriceStep implements Comparable<GasPriceStep> {
  low(0.01),
  average(0.025),
  high(0.04);

  final double value;

  const GasPriceStep(this.value);

  @override
  int compareTo(GasPriceStep other) => (value - other.value).round();
}
