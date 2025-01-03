import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/services/storage_service.dart';
import 'package:chat_app/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImageScreen extends StatelessWidget {
  final String path;
  const ImageScreen({super.key,required this.path});

  @override
  Widget build(BuildContext context) {
    StorageService storageService=Get.put(StorageService());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.bgColors,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: ()async{
                await storageService.saveImageToLocal(path);
              },
              icon: const Icon(Icons.download)
          )
        ],
      ),
      body: Center(child: CachedNetworkImage(imageUrl:path)),
    );
  }
}
