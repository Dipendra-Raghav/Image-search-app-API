import 'package:flutter/material.dart';
import 'package:pixabay_search/search_module.dart';
import 'photo.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _controller = TextEditingController();
  final searchModule = SearchModule();
  int currentPage = 1;
  List<Photo> loadedPhotos = [];

  @override
  void initState() {
    super.initState();
    _controller.text = "dessert";
    searchModule.search(_controller.text, currentPage);
  }

  void searchPhotos(String query, int page) {
    searchModule.search(query, page);
  }

  void loadMorePhotos() {
    currentPage++;
    searchPhotos(_controller.text, currentPage);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Search Images',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('CodeRoofs IT Solutions Images'),
        ),
        body: Column(
          children: <Widget>[
            TextField(
              controller: _controller,
              textInputAction: TextInputAction.search,
              onSubmitted: (value) {
                currentPage = 1;
                loadedPhotos.clear();
                searchPhotos(value, currentPage);
              },
              decoration: InputDecoration(
                hintText: "Enter a value",
                prefixIcon: IconButton(
                  onPressed: () => _controller.clear(),
                  icon: Icon(Icons.clear),
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    currentPage = 1;
                    loadedPhotos.clear();
                    searchPhotos(_controller.text, currentPage);
                  },
                  icon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<AlbumPhoto>(
                stream: searchModule.stream,
                builder:
                    (BuildContext context, AsyncSnapshot<AlbumPhoto> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.photos.isEmpty) {
                      return Center(child: Text('No results found'));
                    }

                    loadedPhotos.addAll(snapshot.data.photos);

                    return NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        if (scrollInfo is ScrollEndNotification) {
                          if (scrollInfo.metrics.pixels ==
                              scrollInfo.metrics.maxScrollExtent) {
                            loadMorePhotos();
                          }
                        }
                        return false;
                      },
                      child: GridView.count(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        crossAxisCount: 3,
                        children: loadedPhotos.map((Photo photo) {
                          return GridTile(
                            child: Image.network(photo.url, fit: BoxFit.cover),
                          );
                        }).toList(),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text("${snapshot.error}"));
                  }

                  return Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
