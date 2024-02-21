final class SaveBrowserParameter{
  final String logo;
  final String name;
  final String? description;
  final String url;

  const SaveBrowserParameter({
    required this.logo,
    required this.name,
    this.description,
    required this.url,
  });
}