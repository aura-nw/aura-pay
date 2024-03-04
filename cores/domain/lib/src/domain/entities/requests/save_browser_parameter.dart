final class SaveBrowserParameter {
  final String logo;
  final String siteName;
  final String screenShotUri;
  final String url;

  const SaveBrowserParameter({
    required this.logo,
    required this.siteName,
    required this.screenShotUri,
    required this.url,
  });

  Map<String, dynamic> toJson() {
    return {
      'logo': logo,
      'siteName': siteName,
      'url': url,
      'screenShotUri' : screenShotUri,
    };
  }
}
