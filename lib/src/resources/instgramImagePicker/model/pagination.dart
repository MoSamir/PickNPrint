class Pagination {
  final String next;

  Pagination(
    //this.cursor,
    this.next,
  );

  Pagination.fromJson(Map json)
      :next = json != null ? json['next_url'] : '';
}
