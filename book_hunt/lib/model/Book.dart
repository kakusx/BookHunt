class Book {
  final String title;
  final String author;
  final String price;
  final String classno;
  final String publisher;
  final String abstract;
  final String period;
  final String isbn;

  Book(this.title, this.author, this.price, this.classno, this.publisher, this.abstract, this.period, this.isbn);

  Book.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        author = json['author'],
        price = json['price'],
        classno = json['classno'],
        publisher = json['publisher'],
        abstract = json['abstract'],
        period = json['period'],
        isbn = json['isbn'];

  Map<String, dynamic> toJson() => <String, dynamic>{
        "title": title,
        "author": author,
        "price": price,
        "classno": classno,
        "publisher": publisher,
        "abstract": abstract,
        "period": period,
        "isbn": isbn
      };
}
