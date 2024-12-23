import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:you_tube/features/auth/model/user_model.dart';
import 'package:you_tube/features/auth/provider/user_provider.dart';
import 'package:you_tube/features/content/long_video/parts/video.dart';
import 'package:you_tube/features/uploaad/long_video/video_model.dart';
import 'package:timeago/timeago.dart' as timeago;

class Post extends ConsumerWidget {
  final VideoModel video;
  const Post({
    Key? key,
    required this.video,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<UserModel> userModel =
        ref.watch(anyUserDataProvider(video.userId));

    final user = userModel.whenData((user) => user);
    return GestureDetector(
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Video(
              video: video,
            ),
          ),
        );

        await FirebaseFirestore.instance
            .collection("videos")
            .doc(video.videoId)
            .update(
          {
            "views": FieldValue.increment(1),
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: video.thumbnail,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 5),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey,
                    backgroundImage: CachedNetworkImageProvider(
                      user.value!.profilePic,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    video.title,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.more_vert),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.sizeOf(context).width * 0.12,
              ),
              child: Row(
                children: [
                  Text(
                    user.value!.displayName,
                    style: const TextStyle(
                      color: Colors.blueGrey,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      video.views == 0 ? "No View" : "${video.views} views",
                      style: const TextStyle(
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                  Text(
                    timeago.format(video.datePublished),
                    style: const TextStyle(
                      color: Colors.blueGrey,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
