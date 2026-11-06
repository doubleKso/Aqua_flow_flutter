class HydrationEntry {
  const HydrationEntry({
    required this.id,
    required this.amountMl,
    required this.consumedAt,
  });

  final int id;
  final int amountMl;
  final DateTime consumedAt;
}
