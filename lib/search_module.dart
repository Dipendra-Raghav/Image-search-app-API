import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pixabay_search/photo.dart';

class SearchModule {
  static const API_KEY = "36497626-10915860f625ebfc83be127f3";
  final _controller = StreamController<AlbumPhoto>.broadcast();

  StreamSink<AlbumPhoto> get _sink => _controller.sink;

  Stream<AlbumPhoto> get stream => _controller.stream;

  Future<AlbumPhoto> fetchAlbumPhoto(String query, int page,
      [String lang = "en"]) async {
    var url = Uri.encodeFull(
        'https://pixabay.com/api/?key=$API_KEY&q=$query&image_type=photo&pretty=true&per_page=40&page=$page&lang=$lang');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return AlbumPhoto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }

  void search(String query, int page) async {
    AlbumPhoto album = await fetchAlbumPhoto(query, page);
    _sink.add(album);
  }
}
