class DAppModel {
  final String id;
  final String name;
  final String description;
  final String iconUrl;
  final String? logoAsset;
  final String url;
  final bool isFeatured;
  final List<String> categories;

  const DAppModel({
    required this.id,
    required this.name,
    required this.description,
    required this.iconUrl,
    this.logoAsset,
    required this.url,
    this.isFeatured = false,
    this.categories = const [],
  });
}

class FeaturedBannerModel {
  final String id;
  final String title;
  final String subtitle;
  final String? imageUrl;
  final String? assetPath;
  final String? actionUrl;

  const FeaturedBannerModel({
    required this.id,
    required this.title,
    required this.subtitle,
    this.imageUrl,
    this.assetPath,
    this.actionUrl,
  });
}

