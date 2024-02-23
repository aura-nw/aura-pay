import 'package:domain/domain.dart';

extension BrowserDtoMapper on BrowserDto {
  Browser get toEntity => Browser(
        id: id,
        logo: logo,
        siteTitle: siteTitle,
        url: url,
      );
}

class BrowserDto {
  final int id;
  final String siteTitle;
  final String logo;
  final String url;

  const BrowserDto({
    required this.id,
    required this.logo,
    required this.siteTitle,
    required this.url,
  });
}
