class GoogleAccount {
  final String id;

  final String? displayName;

  final String email;

  final String? photoUrl;

  final String? serverAuthCode;

  const GoogleAccount({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.serverAuthCode,
  });
}
