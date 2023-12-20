class BookDetail {
  int? id;
  int? bookID;
  String? chapterName;
  String? hindiChapterName;
  String? description;
  String? hindiDescription;
  String? shortDescription;
  String? hindiShortDescription;
  String? bookTitle;
  String? hindiBookTitle;
  int? totalChapters;

  BookDetail({
    this.id,
    this.bookID,
    this.chapterName,
    this.hindiChapterName,
    this.description,
    this.hindiDescription,
    this.shortDescription,
    this.hindiShortDescription,
    this.bookTitle,
    this.hindiBookTitle,
    this.totalChapters,
  });

  factory BookDetail.fromJson(Map<String, dynamic> json) => BookDetail(
        id: json["Id"],
        bookID: json["Book"],
        chapterName: json["Chapter Name"],
        hindiChapterName: json["Hindi Chapter Name"],
        description: json["English Description"],
        hindiDescription: json["Hindi Description"],
        shortDescription: json["Short Description"],
        hindiShortDescription: json["Hindi Short Description"],
        bookTitle: json["Title"],
        hindiBookTitle: json["Hindi Title"],
        totalChapters: json["Total Chapters"],
      );
}
