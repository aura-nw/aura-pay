import 'package:domain/domain.dart';

extension BrowserInformationDtoMapper on BrowserInformationDto {
  BrowserInformation get toEntity => BrowserInformation(
        id: id,
        logo: logo,
        name: name,
        url: url,
        description: description,
      );
}

class BrowserInformationDto {
  final int id;
  final String logo;
  final String name;
  final String? description;
  final String url;
  final bool isBookMark;

  const BrowserInformationDto({
    required this.id,
    required this.logo,
    required this.name,
    this.description,
    required this.url,
    this.isBookMark = false,
  });
}
