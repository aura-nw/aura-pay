import 'package:data/data.dart';
import 'package:isar/isar.dart';

part 'browser_db.g.dart';

@Collection(
  inheritance: false,
)
class BrowserDb extends BrowserDto {
  final Id browserId;
  final String browserUrl;
  final String browserLogo;
  final String browserSiteTitle;
  final bool browserIsActive;

  BrowserDb({
    required this.browserUrl,
    required this.browserLogo,
    required this.browserSiteTitle,
    this.browserId = Isar.autoIncrement,
    required this.browserIsActive,
  }) : super(
          url: browserUrl,
          logo: browserLogo,
          siteTitle: browserSiteTitle,
          id: browserId,
          isActive: browserIsActive,
        );

  factory BrowserDb.fromJson(Map<String, dynamic> json) {
    return BrowserDb(
      browserSiteTitle: json['siteName'],
      browserLogo: json['logo'],
      browserUrl: json['url'],
      browserIsActive: json['isActive'],
    );
  }

  BrowserDb copyWithId(int id) {
    return BrowserDb(
      browserUrl: browserUrl,
      browserLogo: browserLogo,
      browserSiteTitle: browserSiteTitle,
      browserIsActive: browserIsActive,
      browserId: id,
    );
  }
}
