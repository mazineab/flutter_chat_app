import 'dart:async';
import 'dart:io';

import 'package:chat_app/data/models/conversation.dart';
import 'package:chat_app/data/models/enums/message_type.dart';
import 'package:chat_app/data/models/message.dart';
import 'package:chat_app/data/repositories/chat_repositorie.dart';
import 'package:chat_app/data/repositories/users_repositorie.dart';
import 'package:chat_app/modules/current_user_controller.dart';
import 'package:chat_app/services/audio_service.dart';
import 'package:chat_app/services/image_picker_service.dart';
import 'package:chat_app/services/storage_service.dart';
import 'package:chat_app/utils/services/notification_service.dart';
import 'package:chat_app/widget/snackBars/snack_bars.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController{
  final ImagePickerService imagePickerService=Get.put(ImagePickerService());
  final StorageService _storageService=Get.put(StorageService());
  final UsersRepositorie _usersRepositories=Get.put(UsersRepositorie());
  final ChatRepositories _chatRepositories=Get.put(ChatRepositories());
  CurrentUserController currentUserController=Get.find();
  ScrollController scrollController=ScrollController();
  StreamSubscription<QuerySnapshot>? streamSubscription;
  Rx<File?> rxFile=Rx<File?>(null);



  Rx<Conversation> conversation=Conversation().obs;
  List<Message> messages=<Message>[].obs;
  List<Message> myMessages=<Message>[].obs;
  List<Message> friendMessages=<Message>[].obs;
  TextEditingController textEditingController=TextEditingController();
  RxBool ableToSend=false.obs;
  RxString friendFullName=''.obs;

  checkTextField(){
    if(textEditingController.text.isNotEmpty){
      ableToSend.value=true;
    }else{
      ableToSend.value=false;
    }
    update();
  }

  void startStream(){
    streamSubscription=_chatRepositories.messagesStream(conversation.value.uid!, onData: (List<Message> listMessages){
      messages.assignAll(listMessages);
      update();
    },onError: (error){
      CustomSnackBar.showError("Failed to fetch messages real time. Please try again.");
    });
  }


  fetchMessages()async{
    try{
      if(conversation.value.uid != null){
        List<Message> listMessages=await _chatRepositories.fetchMessageOfConversation(conversation.value.uid!);
        messages.assignAll(listMessages);
      }else{
        CustomSnackBar.showError("Failed to fetch messages of this conversation");
      }

    }catch(e){
      print(Exception("$e"));
      CustomSnackBar.showError("Failed to fetch messages. Please try again.");
    }finally{
      update();
    }
  }

  Future<void> sendMessage()async{
    try{
      Message message=Message(
        senderId: currentUserController.authUser.value.docId,
        isRead: false,
        createdAt: Timestamp.fromDate(DateTime.now()),
      );
      if(textEditingController.text.isNotEmpty){
        message.messageType=MessageType.text;
        message.messageContent=textEditingController.text;
      }else if(textEditingController.text.isEmpty && rxFile.value!=null){
        message.messageType=MessageType.image;
        message.messageContent="Photo";
        message.path=rxFile.value?.path;
      }else if(textEditingController.text.isEmpty && rxAudio.value!=null){
        message.messageType=MessageType.audio;
        message.messageContent="Audio";
        message.path=rxAudio.value?.path;
      }

      bool isSender=currentUserController.authUser.value.docId==conversation.value.senderDocId;
      await _chatRepositories.sendMessage(message, conversation.value.uid!,isSender);
      if(message.messageType==MessageType.image){
        String path=await _storageService.uploadImageInConversation(conversation.value.uid!,rxFile.value!);
        await _chatRepositories.updateMessagePath(conversation.value.uid!,messages.first.uid!,path);
      }else if(message.messageType==MessageType.audio){
        String path=await _storageService.uploadAudioInConversation(conversation.value.uid!,rxAudio.value!,messages.first.uid!);
        await _chatRepositories.updateMessagePath(conversation.value.uid!,messages.first.uid!,path);
      }
      textEditingController.clear();
      String? fcmToken=await _usersRepositories.getUserFcmToken(isSender
          ?conversation.value.receiverDocId ?? ''
          :conversation.value.senderDocId ?? ''
      );
      if(fcmToken!=null){
        await Get.find<NotificationService>().sendNotifications(
            fcmToken: fcmToken,
            title: "Chat App",
            body: "${currentUserController.authUser.value.name} send you message",
            userId: ""
        );
      }

    }catch(e){
      CustomSnackBar.showError("Failed to send your message, please try again.");
      Exception(e);
    }
  }

  void uploadFromGallery()async{
    File? file =await imagePickerService.loadFromGallery();
    if(file!=null){
      rxFile.value=file;
      await sendMessage();
    }else{
      return;
    }
    update();
  }

  String getFriendFullName(Conversation conv)=>
    conv.senderDocId==currentUserController.authUser.value.docId ? conv.receiverFullName! : conv.senderFullName!;


  @override
  void onInit() async{
    await setConversation();
    startStream();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
    // await fetchMessages();
    super.onInit();
  }

  void _scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.jumpTo(scrollController.position.minScrollExtent);
    }
  }

  setConversation()async{
    conversation.value=Get.arguments["conversation"];
    friendFullName.value=getFriendFullName(conversation.value);
  }



  /// TODO parts of audio recording and playback functionality
  Rx<File?> rxAudio=Rx<File?>(null);
  var isRecording=false.obs;
  var isAudioPlaying=false.obs;
  var currentAudioPath=''.obs;
  startAudioRecording()async {
    try {
      AudioService audioService = Get.put(AudioService());
      isRecording.value = true;
      await audioService.handleRecord();
      update();
    } catch (e) {
      Exception(e);
    }
  }


  finishAudioRecording()async{
    try{
      AudioService audioService = Get.find();
      File? audioFile=await audioService.stopRecording();
      if(audioFile!=null){
        rxAudio.value=audioFile;
        await sendMessage();
      }else{
        print("Not recorded");
      }
      isRecording.value=false;
      update();
    }catch(e){
      Exception(e);
    }
  }

  startAudioPlayback(String path)async{
    try{
      AudioService audioService = Get.put(AudioService());
      audioService.isPlaying.listen((value){
        isAudioPlaying.value=value;
        update();
      });
      currentAudioPath.value=path;
      await audioService.startPlaying(path);
    }catch(e){
      Exception(e);
    }
  }

  cancelAudioRecording()async{
    AudioService audioService = Get.find();
    await audioService.cancelRecording();
    isRecording.value=false;
    update();
  }

}