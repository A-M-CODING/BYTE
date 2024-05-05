class AltProduct {
  final int id;
  final String name;
  final String image;
  final String rating;
  final String reviewCount;
  final String url;
  bool isFavorite;

  AltProduct({
    required this.id,
    required this.name,
    required this.image,
    required this.rating,
    required this.reviewCount,
    required this.url,
    this.isFavorite = false,
  });

  // Add a factory constructor that creates an AltProduct from JSON data
  factory AltProduct.fromJson(Map<String, dynamic> json) {
    return AltProduct(
      id: json['id'] as int? ?? 0, // Handle the type casting appropriately.
      name: json['name'] as String? ?? '',
      image: json['image'] as String? ?? '',
      rating: json['rating'] as String? ?? '',
      reviewCount: json['reviewCount'] as String? ?? '',
      url: json['url'] as String? ?? '',
      isFavorite: json['isFavorite'] as bool? ??
          false, // Assuming this field exists and is a bool.
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
      'rating': rating,
      'reviewCount': reviewCount,
      'url': url,
    };
  }
}

class YtVideo {
  final String title;
  final String thumbnailUrl;
  final String videoLink;
  bool isFavorite;

  YtVideo({
    required this.title,
    required this.thumbnailUrl,
    required this.videoLink,
    this.isFavorite = false,
  });

  factory YtVideo.fromJson(Map<String, dynamic> json) {
    return YtVideo(
      title: json['title'] as String? ?? '',
      thumbnailUrl: json['thumbnailUrl'] as String? ?? '',
      videoLink: json['videoLink'] as String? ?? '',
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'thumbnailUrl': thumbnailUrl,
      'videoLink': videoLink,
    };
  }
}
