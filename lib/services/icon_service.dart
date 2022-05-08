import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

/*

Service to turn the icon name into flutter image widget

*/

class IconService {
  static CachedNetworkImage getIcon(String id) {
    return CachedNetworkImage(
      imageUrl: "http://openweathermap.org/img/wn/$id@2x.png",
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      placeholder: (context, url) =>
          const SpinKitChasingDots(color: Colors.white, size: 25),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}
