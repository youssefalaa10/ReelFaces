class Paginated<T> {
  const Paginated({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });
  final int page;
  final List<T> results;
  final int totalPages;
  final int totalResults;

  bool get hasNextPage => page < totalPages;
  bool get hasPreviousPage => page > 1;
  bool get isEmpty => results.isEmpty;
  bool get isNotEmpty => results.isNotEmpty;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Paginated<T> &&
        other.page == page &&
        other.results == results &&
        other.totalPages == totalPages &&
        other.totalResults == totalResults;
  }

  @override
  int get hashCode {
    return page.hashCode ^
        results.hashCode ^
        totalPages.hashCode ^
        totalResults.hashCode;
  }

  @override
  String toString() {
    return 'Paginated(page: $page, results: $results, totalPages: $totalPages, totalResults: $totalResults)';
  }
}
