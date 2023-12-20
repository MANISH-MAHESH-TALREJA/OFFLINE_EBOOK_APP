class Books {
  int? id;
  String? englishTitle;
  String? hindiTitle;
  String? bookImage;
  String? englishAuthor;
  String? hindiAuthor;
  int? chapter;

  Books({
    this.id,
    this.englishTitle,
    this.hindiTitle,
    this.englishAuthor,
    this.hindiAuthor,
    this.chapter,
    this.bookImage,
  });

  factory Books.fromJson(Map<String, dynamic> json) => Books(
        id: json["Id"],
        englishTitle: json["Book Title"],
        hindiTitle: json["Hindi Book Title"],
        englishAuthor: json["Author Name"],
        chapter: json["Total Chapters"],
        hindiAuthor: json["Hindi Author Name"],
        bookImage: json["Book Image"],
      );
}
