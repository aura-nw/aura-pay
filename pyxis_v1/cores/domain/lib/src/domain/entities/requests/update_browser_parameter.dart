final class UpdateBrowserParameter {
  final String logo;
  final String siteName;
  final String screenShotUri;
  final String url;
  final bool isActive;

  const UpdateBrowserParameter({
    required this.logo,
    required this.siteName,
    required this.screenShotUri,
    required this.url,
    required this.isActive,
  });

  Map<String, dynamic> toJson() {
    return {
      'logo': logo,
      'siteName': siteName,
      'url': url,
      'isActive': isActive,
      'screenShotUri': screenShotUri,
    };
  }
}
