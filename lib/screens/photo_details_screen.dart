import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:intl/intl.dart';
import 'package:mobile_up/data/models/vk_photo.dart';
import 'package:open_file/open_file.dart';
import 'package:photo_view/photo_view.dart';

class PhotoDetailsScreen extends StatefulWidget {
  const PhotoDetailsScreen({Key? key, required this.photo}) : super(key: key);

  final VKPhoto photo;

  @override
  _PhotoDetailsScreenState createState() => _PhotoDetailsScreenState();
}

class _PhotoDetailsScreenState extends State<PhotoDetailsScreen> {
  DateTime? _lastModify;
  final DateFormat _dateFormat = DateFormat.yMMMMd();
  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    _lastModify =
        await (await DefaultCacheManager().getSingleFile(widget.photo.urlLarge))
            .lastAccessed();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            _lastModify != null ? Text(_dateFormat.format(_lastModify!)) : null,
        actions: [
          IconButton(onPressed: _saveFile, icon: const Icon(Icons.ios_share)),
        ],
      ),
      body: Center(
        child: Hero(
          tag: widget.photo.id,
          child: PhotoView(
            backgroundDecoration:
                BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
            maxScale: PhotoViewComputedScale.covered * 2,
            minScale: PhotoViewComputedScale.contained,
            imageProvider: CachedNetworkImageProvider(widget.photo.urlLarge,
                errorListener: () {}),
            errorBuilder: (context, error, stacktrace) =>
                _getPlaceholder(error: true),
            loadingBuilder: (context, event) => _getPlaceholder(loading: true),
          ),
        ),
      ),
    );
  }

  Widget _getPlaceholder({bool loading = false, bool error = false}) => Stack(
        alignment: Alignment.center,
        children: [
          CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl: widget.photo.urlMedium,
            errorWidget: (context, url, error) => const Center(
              child: Icon(Icons.error),
            ),
          ),
          if (loading)
            const Align(
              alignment: Alignment.bottomRight,
              child: CircularProgressIndicator.adaptive(),
            ),
          if (error)
            const Align(
              alignment: Alignment.bottomRight,
              child: Icon(Icons.error),
            ),
        ],
      );

  Future<void> _saveFile() async {
    final fileContnent =
        await DefaultCacheManager().getSingleFile(widget.photo.urlLarge);

    OpenFile.open(fileContnent.path);
  }
}
