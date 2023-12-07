import 'package:domain/domain.dart';

extension GoogleAccountDtoMapper on GoogleAccountDto {
  GoogleAccount get toEntities => GoogleAccount(
        id: id,
        email: email,
        displayName: displayName,
        photoUrl: photoUrl,
        serverAuthCode: serverAuthCode,
      );
}

class GoogleAccountDto {
  final String id;

  final String? displayName;

  final String email;

  final String? photoUrl;

  final String? serverAuthCode;

  const GoogleAccountDto({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.serverAuthCode,
  });
}
