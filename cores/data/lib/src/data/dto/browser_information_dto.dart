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

  const BrowserInformationDto({
    required this.id,
    required this.logo,
    required this.name,
    this.description,
    required this.url,
  });
}
