abstract interface class FeeGrantRepository{
  Future<void> grantFee({
    required Map<String, dynamic> body,
  });
}