import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:photo_albums/photo_list.dart';

class PhotoPage extends StatefulWidget {
  const PhotoPage({super.key});

  @override
  State<PhotoPage> createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  final _dio = Dio(BaseOptions(responseType: ResponseType.plain));
  List<PhotoList>? _list;
  String? _error;

  void getPhotoAlbums() async {
    try {
      setState(() {
        _error = null;
      });

      final response =
          await _dio.get('https://jsonplaceholder.typicode.com/albums');
      List list = jsonDecode(response.data.toString());

      setState(() {
        _list = list.map((item) => PhotoList.fromJson(item)).toList();
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPhotoAlbums();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Photo Albums",
            style: TextStyle(
                color: Colors.black, fontSize: 32, inherit: false),
          ),
        ),
        showAlbums(),
      ],
    );
  }

  Widget showAlbums() {
    Widget? body;
    if (_error != null) {
      body = Column(
        children: [
          Text(_error!),
          SizedBox(
            height: 16,
          ),
          ElevatedButton(
              onPressed: () {
                getPhotoAlbums();
              },
              child: Text('RETRY')),
        ],
      );
    } else if (_list == null) {
      body = Center(
        child: CircularProgressIndicator(),
      );
    } else {
      body = Expanded(
        child: ListView.builder(
            itemCount: _list!.length,
            itemBuilder: (context, index) {
              var item = _list![index];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 4.0, right: 8, left: 8, bottom: 4),
                        child: Text(item.title),
                      ),
                      Row(
                        children: [
                          Container(
                            child: Center(child: Text("Album ID: ${item.id.toString()}")),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(180),
                              color: Colors.pinkAccent,
                            ),
                            padding: EdgeInsets.all(8),
                          ),
                          SizedBox(width: 8,),
                          Container(
                            child: Center(child: Text("User ID: ${item.userId.toString()}")),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(180),
                              color: Colors.greenAccent,
                            ),
                            padding: EdgeInsets.all(8),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            }),
      );
    }

    return Container(
      child: body,
    );
  }
}
