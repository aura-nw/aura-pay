import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:isar/isar.dart';

part 'browser_information_db.g.dart';

@Collection(
  inheritance: false,
)
class BrowserInformationDb extends BrowserInformationDto {
  final Id browserId;
  final String browserName;
  final String browserLogo;
  final String? browserDescription;
  final String browserUrl;
  final bool isBrowserBookMark;

  BrowserInformationDb({
    this.browserId = Isar.autoIncrement,
    required this.browserName,
    required this.browserLogo,
    required this.browserUrl,
    this.browserDescription,
    this.isBrowserBookMark = false,
  }) : super(
          id: browserId,
          name: browserName,
          logo: browserLogo,
          url: browserUrl,
          description: browserDescription,
          isBookMark: isBrowserBookMark,
        );
}
