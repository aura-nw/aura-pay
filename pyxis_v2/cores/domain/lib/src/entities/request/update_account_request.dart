final class UpdateAccountRequest {
  final String? name;
  final String? evmAddress;
  final String? cosmosAddress;
  final int? keyStoreId;
  final int id;
  final int? index;

  const UpdateAccountRequest({
    this.index,
    this.name,
    this.keyStoreId,
    this.evmAddress,
    this.cosmosAddress,
    required this.id,
  });
}
