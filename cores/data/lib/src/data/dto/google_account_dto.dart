import 'package:domain/domain.dart';
import 'package:google_sign_in/google_sign_in.dart';

extension GoogleAccountDtoMapper on GoogleAccountDto {
  GoogleAccount get toEntities => GoogleAccount(
        id: id,
        email: email,
        displayName: displayName,
        photoUrl: photoUrl,
        serverAuthCode: serverAuthCode,
      );
}

extension GoogleSignInAccountMapper on GoogleSignInAccount {
  GoogleAccountDto get toDto => GoogleAccountDto(
        id: id,
        email: email,
        serverAuthCode: serverAuthCode,
        photoUrl: photoUrl,
        displayName: displayName,
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
