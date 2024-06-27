final class SaveBookMarkParameter{
  final String logo;
  final String name;
  final String? description;
  final String url;

  const SaveBookMarkParameter({
    required this.logo,
    required this.name,
    this.description,
    required this.url,
  });

  Map<String,dynamic> toJson(){
    return {
      'logo': logo,
      'name' : name,
      'description' : description,
      'url' : url,
    };
  }
}