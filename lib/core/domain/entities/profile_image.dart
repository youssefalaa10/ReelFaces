class ProfileImage {
  const ProfileImage({
    required this.aspectRatio,
    required this.height,
    required this.filePath,
    required this.voteAverage,
    required this.voteCount,
    required this.width,
    this.iso6391,
  });
  final double aspectRatio;
  final int height;
  final String? iso6391;
  final String filePath;
  final double voteAverage;
  final int voteCount;
  final int width;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProfileImage &&
        other.aspectRatio == aspectRatio &&
        other.height == height &&
        other.iso6391 == iso6391 &&
        other.filePath == filePath &&
        other.voteAverage == voteAverage &&
        other.voteCount == voteCount &&
        other.width == width;
  }

  @override
  int get hashCode {
    return aspectRatio.hashCode ^
        height.hashCode ^
        iso6391.hashCode ^
        filePath.hashCode ^
        voteAverage.hashCode ^
        voteCount.hashCode ^
        width.hashCode;
  }

  @override
  String toString() {
    return 'ProfileImage(aspectRatio: $aspectRatio, height: $height, iso6391: $iso6391, filePath: $filePath, voteAverage: $voteAverage, voteCount: $voteCount, width: $width)';
  }
}
