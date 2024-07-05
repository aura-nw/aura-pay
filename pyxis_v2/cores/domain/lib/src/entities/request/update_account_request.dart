final class UpdateAccountRequest {
  final String? name;
  final String? evmAddress;
  final String? cosmosAddress;
  final int? keyStoreId;
  final int id;

  const UpdateAccountRequest({
    this.name,
    this.keyStoreId,
    this.evmAddress,
    this.cosmosAddress,
    required this.id,
  });
}
