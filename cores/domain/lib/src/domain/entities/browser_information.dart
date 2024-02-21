final class BrowserInformation {
  final int id;
  final String logo;
  final String name;
  final String? description;
  final String url;

  const BrowserInformation({
    required this.id,
    required this.logo,
    required this.name,
    this.description,
    required this.url,
  });
}
