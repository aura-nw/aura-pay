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
  final String browserScreenShotUri;
  final bool browserIsActive;

  BrowserDb({
    required this.browserUrl,
    required this.browserLogo,
    required this.browserSiteTitle,
    required this.browserScreenShotUri,
    this.browserId = Isar.autoIncrement,
    required this.browserIsActive,
  }) : super(
          url: browserUrl,
          logo: browserLogo,
          siteTitle: browserSiteTitle,
          id: browserId,
          isActive: browserIsActive,
          screenShotUri: browserScreenShotUri,
        );

  factory BrowserDb.fromAddJson(Map<String, dynamic> json) {
    return BrowserDb(
      browserSiteTitle: json['siteName'],
      browserLogo: json['logo'],
      browserUrl: json['url'],
      browserIsActive: true,
      browserScreenShotUri: json['screenShotUri'],
    );
  }

  factory BrowserDb.fromJson(Map<String, dynamic> json) {
    return BrowserDb(
      browserSiteTitle: json['siteName'],
      browserLogo: json['logo'],
      browserUrl: json['url'],
      browserIsActive: json['isActive'],
      browserScreenShotUri: json['screenShotUri'],
    );
  }

  BrowserDb copyWithId(int id) {
    return BrowserDb(
      browserUrl: browserUrl,
      browserLogo: browserLogo,
      browserSiteTitle: browserSiteTitle,
      browserIsActive: browserIsActive,
      browserId: id,
      browserScreenShotUri: browserScreenShotUri,
    );
  }

  BrowserDb copyWithActive(bool isActive) {
    return BrowserDb(
      browserUrl: browserUrl,
      browserLogo: browserLogo,
      browserSiteTitle: browserSiteTitle,
      browserIsActive: isActive,
      browserId: id,
      browserScreenShotUri: browserScreenShotUri,
    );
  }
}
