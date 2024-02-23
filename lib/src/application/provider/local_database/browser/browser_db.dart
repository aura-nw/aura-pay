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

  BrowserDb({
    required this.browserUrl,
    required this.browserLogo,
    required this.browserSiteTitle,
    this.browserId = Isar.autoIncrement,
  }) : super(
          url: browserUrl,
          logo: browserLogo,
          siteTitle: browserSiteTitle,
          id: browserId,
        );

  factory BrowserDb.fromJson(Map<String, dynamic> json) {
    return BrowserDb(
      browserSiteTitle: json['siteName'],
      browserLogo: json['logo'],
      browserUrl: json['url'],
    );
  }
}
