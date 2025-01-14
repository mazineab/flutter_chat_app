import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/modules/setting/controllers/received_photos_controller.dart';
import 'package:chat_app/widget/message_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../data/models/message.dart';
import '../../../widget/image_screen.dart'; // For date formatting

class ReceivedPhotos extends StatelessWidget {
  const ReceivedPhotos({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        title: const Text('Received Photos',style: TextStyle(color: Colors.white,),),
      ),
      body: GetBuilder<ReceivedPhotosController>(
        init: ReceivedPhotosController(),
        builder: (controller) {
          // Group photos by day
          return Obx((){
            final groupedPhotos = groupPhotosByDay(controller.listPhotos);

            return controller.loading.value
                ? const Center(child: CircularProgressIndicator())
                : groupedPhotos.isEmpty
                ? const Center(child: Text("You don't have any photos in any chat yet.",style: TextStyle(color: Colors.white)))
                :ListView.builder(
              itemCount: groupedPhotos.keys.length,
              itemBuilder: (context, index) {
                final date = groupedPhotos.keys.elementAt(index);
                final photos = groupedPhotos[date]!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Section title (Date)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            date,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    /// Photos grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: photos.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 1,
                        mainAxisSpacing: 8,
                      ),
                      itemBuilder: (context, photoIndex) {
                        final photo = photos[photoIndex];
                        return photoWidget(photo);
                      },
                    ),
                  ],
                );
              },
            );
          }
            ,
          );
        },
      ),
    );
  }

  /// Groups photos by day, returning a map with date as the key and list of photos as the value.

  Map<String, List<Message>> groupPhotosByDay(List<Message> photos) {
    final Map<String, List<Message>> groupedPhotos = {};
    for (var photo in photos) {
      // Convert the `createdAt` timestamp to a `DateTime` object
      final DateTime createdAt = (photo.createdAt as Timestamp).toDate();

      // Format the date
      final String date = DateFormat('yyyy-MM-dd').format(createdAt);

      // Group photos by the formatted date
      if (groupedPhotos.containsKey(date)) {
        groupedPhotos[date]!.add(photo);
      } else {
        groupedPhotos[date] = [photo];
      }
    }
    return groupedPhotos;
  }

  Widget photoWidget(Message message){
    return GestureDetector(
      onTap: () {
        Get.to(() => ImageScreen(path: message.path!));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: message.path!.startsWith('https')
              ? CachedNetworkImage(
            imageUrl: message.path!,
            fit: BoxFit.cover,
            placeholder: (context, url) => Skeletonizer(
              enabled: true,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.grey[300],
              ),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          )
              : Skeletonizer(
            enabled: true,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.grey[300],
            ),
          ),
        ),
      ),
    );
  }

}
