import 'package:chat_app/services/permission_service.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioService extends GetxService {
  PermissionService permissionService=PermissionService();
  FlutterSoundRecorder recorder = FlutterSoundRecorder();
  FlutterSoundPlayer player = FlutterSoundPlayer();

  var isRecording = false.obs;
  var isPlaying = false.obs;
  String recordingPath = '';
  String playingPath = '';


  Future<void> handleRecord() async {
    try {
      if(await permissionService.checkPermission(Permission.microphone)){
        return await startRecording();
      }else{
        if(await permissionService.requestPermission(Permission.microphone)){
          return await startRecording();
        }else{
          throw Exception("Permission not granted");
        }
      }

    } catch (e) {
      Exception("Error starting recorder: $e");
    }
  }

  startRecording()async{
    try{
      final dir = await getTemporaryDirectory();
      recordingPath = '${dir.path}/recorded_audio.aac';
      await recorder.startRecorder(
        toFile: recordingPath,
        codec: Codec.aacADTS,
      );
      isRecording.value = true;
    }catch(e){
      Exception(e);
    }

  }

  // Stop recording
  Future<File?> stopRecording() async {
    try {
      await recorder.stopRecorder();
      isRecording.value = false;
      return File(recordingPath);
    } catch (e) {
      throw Exception("Error stopping recorder: $e");
    }
  }

  Future<void> cancelRecording() async {
    try {
      if (isRecording.value) {
        await recorder.stopRecorder();
        isRecording.value = false;
      }
      if (recordingPath.isNotEmpty) {
        final file = File(recordingPath);
        if (await file.exists()) {
          await file.delete();
        }
      }
    } catch (e) {
      Exception(e);
    }
  }

  // Start Playing
  Future<void> startPlaying(String url) async {
    try {
        await player.startPlayer(
          fromURI: url,
          codec: Codec.aacADTS,
          whenFinished:()=> isPlaying.value=false,
        );
        isPlaying.value = true;
        } catch (e) {
          throw Exception("Failed to start audio playback: $e");
        }
  }

  // Pause Playing
  Future<void> pausePlaying() async {
    try {
      await player.pausePlayer();
      isPlaying.value = false;
    } catch (e) {
      print("Error pausing player: $e");
    }
  }
  //
  // // Stop Playing
  // Future<void> stopPlaying() async {
  //   try {
  //     await _player.stopPlayer();
  //     isPlaying = false;
  //     // update();
  //   } catch (e) {
  //     print("Error stopping player: $e");
  //   }
  // }

  // @override
  // void onClose() {
  //   recorder._closeAudioSession();
  //   _player._closeAudioSession();
  //   super.onClose();
  // }

@override
  void onInit() async{
    await recorder.openRecorder();
    await player.openPlayer();
    super.onInit();
  }
}
