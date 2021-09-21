import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobile_up/data/models/app_state.dart';
import 'package:mobile_up/data/models/vk_photo.dart';
import 'package:mobile_up/generated/l10n.dart';
import 'package:mobile_up/screens/photo_details_screen.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    Provider.of<AppState>(context, listen: false).fetchAlbum();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).appTitle),
          actions: [
            MaterialButton(
              child: Text(
                S.of(context).exit,
                style: const TextStyle(fontSize: 18),
              ),
              onPressed: () {
                Provider.of<AppState>(context, listen: false).logout();
              },
            )
          ],
        ),
        body: SafeArea(
          child: Consumer<AppState>(
            builder: (context, state, _) {
              return GridView.builder(
                itemCount: state.photos.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, mainAxisSpacing: 2, crossAxisSpacing: 2),
                itemBuilder: (context, index) =>
                    _buildItem(context, state.photos[index]),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, VKPhoto photo) {
    return GestureDetector(
      onTap: () => _navigateToDetails(photo),
      child: Hero(
        tag: photo.id,
        child: CachedNetworkImage(
          fit: BoxFit.cover,
          imageUrl: photo.urlMedium,
          progressIndicatorBuilder: (context, url, progress) => Center(
            child: SizedBox(
              width: 100,
              child: LinearProgressIndicator(value: progress.progress),
            ),
          ),
          errorWidget: (context, url, error) => const Center(
            child: Icon(Icons.error),
          ),
        ),
      ),
    );
  }

  void _navigateToDetails(VKPhoto photo) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PhotoDetailsScreen(
          photo: photo,
        ),
      ),
    );
  }
}
