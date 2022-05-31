import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoViewPage extends StatelessWidget {
  const PhotoViewPage({Key? key, required this.urls}) : super(key: key);
  final List<String> urls;

  @override
  Widget build(BuildContext context) {
    return PhotoViewGallery.builder(
      scrollPhysics: const BouncingScrollPhysics(),
      builder: (BuildContext context, int index) {
        return PhotoViewGalleryPageOptions(
          imageProvider: NetworkImage(urls[index]),
          initialScale: PhotoViewComputedScale.contained * 0.8,
          //heroAttributes: PhotoViewHeroAttributes(tag: urls[index]),
        );
      },
      itemCount:urls.length,
      loadingBuilder: (context, loadingProgress){
        if (loadingProgress ==
            null) return const Center(child: CircularProgressIndicator());
        return Center(
          child: SizedBox(
            width: 20.0,
            height: 20.0,
            child: CircularProgressIndicator(
              value: loadingProgress
                  .expectedTotalBytes !=
                  null
                  ? loadingProgress
                  .cumulativeBytesLoaded /
                  loadingProgress
                      .expectedTotalBytes!
                  : null,
            ),
          ),
        );
      },
      // backgroundDecoration: widget.backgroundDecoration,
      // pageController: widget.pageController,
      onPageChanged: (int val){
        print(val);
      },
    );
  }
}
