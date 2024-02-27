final class Browser {
  final int id;
  final String siteTitle;
  final String logo;
  final String url;
  final bool isActive;

  const Browser({
    required this.id,
    required this.logo,
    required this.siteTitle,
    required this.url,
    required this.isActive,
  });
}
