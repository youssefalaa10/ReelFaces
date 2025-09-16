class ImageModel {
  const ImageModel({
    required this.id,
    required this.url,
    this.title,
    this.description,
    this.width = 0,
    this.height = 0,
    this.aspectRatio,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: json['id'] ?? '',
      url: json['url'] ?? '',
      title: json['title'],
      description: json['description'],
      width: json['width'] ?? 0,
      height: json['height'] ?? 0,
      aspectRatio: json['aspect_ratio'],
    );
  }
  final String id;
  final String url;
  final String? title;
  final String? description;
  final int width;
  final int height;
  final String? aspectRatio;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'title': title,
      'description': description,
      'width': width,
      'height': height,
      'aspect_ratio': aspectRatio,
    };
  }

  ImageModel copyWith({
    String? id,
    String? url,
    String? title,
    String? description,
    int? width,
    int? height,
    String? aspectRatio,
  }) {
    return ImageModel(
      id: id ?? this.id,
      url: url ?? this.url,
      title: title ?? this.title,
      description: description ?? this.description,
      width: width ?? this.width,
      height: height ?? this.height,
      aspectRatio: aspectRatio ?? this.aspectRatio,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ImageModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'ImageModel(id: $id, url: $url, title: $title)';
  }
}
