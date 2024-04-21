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
      id: json['id'] ??
          0, // Add a proper default value or ensure the id is provided
      name: json['Title'] ?? '',
      image: json['Image URL'] ?? '',
      rating: json['Rating'] ?? '',
      reviewCount: json['Review Count'] ?? '',
      url: json['URL'] ?? '',
      isFavorite: json['isFavorite'] ?? false,
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
      title: json['title'] ?? '',
      thumbnailUrl: json['thumbnail_url'] ?? '',
      videoLink: json['video_link'] ?? '',
      isFavorite: json['isFavorite'] ?? false,
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
