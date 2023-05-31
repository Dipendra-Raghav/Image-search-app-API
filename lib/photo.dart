class AlbumPhoto {
  final int id;
  final List<Photo> photos;
  final int totalPages; // New field for total pages

  AlbumPhoto({this.id, this.photos, this.totalPages});

  factory AlbumPhoto.fromJson(Map<String, dynamic> json) {
    var photos = List<Map>.from(json["hits"].map((x) => x))
        .map((x) => Photo(id: x['id'], url: x['webformatURL']))
        .toList();
    return AlbumPhoto(
      id: json['id'],
      photos: photos,
      totalPages:
          json['totalPages'], // Assign the total pages from the JSON response
    );
  }
}

class Photo {
  final int id;
  final String url; // Added type declaration for URL

  Photo({this.id, this.url});
}
