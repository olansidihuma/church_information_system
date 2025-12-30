/// News model for church information and announcements
class NewsModel {
  final String id;
  final String title;
  final String content;
  final String? imageUrl;
  final DateTime date;
  final String category;

  NewsModel({
    required this.id,
    required this.title,
    required this.content,
    this.imageUrl,
    required this.date,
    required this.category,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      imageUrl: json['image_url'],
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      category: json['category'] ?? 'general',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'image_url': imageUrl,
      'date': date.toIso8601String(),
      'category': category,
    };
  }
}

/// Banner model for homepage carousel
class BannerModel {
  final String id;
  final String title;
  final String? description;
  final String imageUrl;
  final String? actionUrl;
  final bool isActive;

  BannerModel({
    required this.id,
    required this.title,
    this.description,
    required this.imageUrl,
    this.actionUrl,
    this.isActive = true,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      description: json['description'],
      imageUrl: json['image_url'] ?? '',
      actionUrl: json['action_url'],
      isActive: json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'action_url': actionUrl,
      'is_active': isActive,
    };
  }
}

/// Video model for video gallery
class VideoModel {
  final String id;
  final String title;
  final String? description;
  final String videoUrl;
  final String? thumbnailUrl;
  final String category;
  final DateTime uploadDate;
  final int duration; // in seconds

  VideoModel({
    required this.id,
    required this.title,
    this.description,
    required this.videoUrl,
    this.thumbnailUrl,
    required this.category,
    required this.uploadDate,
    this.duration = 0,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      description: json['description'],
      videoUrl: json['video_url'] ?? '',
      thumbnailUrl: json['thumbnail_url'],
      category: json['category'] ?? 'general',
      uploadDate: json['upload_date'] != null 
          ? DateTime.parse(json['upload_date']) 
          : DateTime.now(),
      duration: json['duration'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'video_url': videoUrl,
      'thumbnail_url': thumbnailUrl,
      'category': category,
      'upload_date': uploadDate.toIso8601String(),
      'duration': duration,
    };
  }

  /// Format duration as MM:SS or HH:MM:SS
  String get formattedDuration {
    final hours = duration ~/ 3600;
    final minutes = (duration % 3600) ~/ 60;
    final seconds = duration % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }
}
