class Bookmark {
  int? id;
  int? bookMarkId;

  Bookmark({
    this.bookMarkId,
  });

  factory Bookmark.fromJson(Map<String, dynamic> json) => Bookmark(bookMarkId: json["bookmarkId"],);
  //
  Map<String, dynamic> toJson() => {"v_id": bookMarkId};

  Map<String, dynamic> toMap() {
    return {"bookmarkId": bookMarkId};
  }
}
