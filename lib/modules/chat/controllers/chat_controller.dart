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
import 'package:intl/intl.dart';

class ChatController extends GetxController{
  final ImagePickerService imagePickerService=Get.put(ImagePickerService());
  final StorageService _storageService=Get.put(StorageService());
  final UsersRepositorie _usersRepositories=Get.put(UsersRepositorie());
  final ChatRepositories _chatRepositories=Get.put(ChatRepositories());
  CurrentUserController currentUserController=Get.find();
  ScrollController scrollController=ScrollController();
  StreamSubscription<QuerySnapshot>? streamSubscription;
  Rx<File?> rxFile=Rx<File?>(null);
  RxMap rxGroupedMessages = {}.obs;



  Rx<Conversation> conversation=Conversation().obs;
  // List<Message> messages=<Message>[].obs;
  List<Message> myMessages=<Message>[].obs;
  List<Message> friendMessages=<Message>[].obs;
  TextEditingController textEditingController=TextEditingController();
  RxBool ableToSend=false.obs;
  RxBool ableToSendPicture=true.obs;
  RxString friendFullName=''.obs;
  var isUpload=false.obs;

  checkTextField(){
    if(textEditingController.text.isNotEmpty){
      ableToSend.value=true;
    }else{
      ableToSend.value=false;
    }
  }

  void startStream(){
    streamSubscription=_chatRepositories.messagesStream(conversation.value.uid!, onData: (List<Message> listMessages){
      // messages.assignAll(listMessages);
      groupMessageByDay(listMessages);
    },onError: (error){
      CustomSnackBar.showError("Failed to fetch messages real time. Please try again.");
    });
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
        message.isUpload=true;
      }else if(textEditingController.text.isEmpty && rxAudio.value!=null){
        message.messageType=MessageType.audio;
        message.messageContent="Audio";
        message.audioDuration = audioDurationValue.value != 0 ? audioDurationValue.value : null;
        message.isUpload=true;
      }

      bool isSender=currentUserController.authUser.value.docId==conversation.value.senderDocId;
      textEditingController.clear();
      ableToSend.value=false;
      var messageUid=await _chatRepositories.sendMessage(message, conversation.value.uid!,isSender);
      if(message.messageType==MessageType.image){
        ableToSendPicture.value=false;
        String path=await _storageService.uploadImageInConversation(conversation.value.uid!,rxFile.value!);
        rxFile.value=null;
        await _chatRepositories.updateMessagePath(conversation.value.uid!,messageUid,path);
      }else if(message.messageType==MessageType.audio){
        ableToSendPicture.value=false;
        String path=await _storageService.uploadAudioInConversation(conversation.value.uid!,rxAudio.value!,messageUid);
        rxAudio.value=null;
        await _chatRepositories.updateMessagePath(conversation.value.uid!,messageUid,path);
      }
      ableToSendPicture.value=true;
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
  }

  void uploadFromCamera()async{
    File? file=await imagePickerService.loadFromCamera();
    if(file!=null){
      rxFile.value=file;
      await sendMessage();
    }else{
      return;
    }
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

  ///grouped message by date
  groupMessageByDay(List<Message> messagess) {
    final Map<String, List<Message>> groupedMessages = {};
    for (var message in messagess) {
      final DateTime createdAt = (message.createdAt as Timestamp).toDate();
      final String date = DateFormat('yyyy-MM-dd').format(createdAt);
      if (groupedMessages.containsKey(date)) {
        groupedMessages[date]!.add(message);
      } else {
        groupedMessages[date] = [message];
      }
    }
    rxGroupedMessages.assignAll(groupedMessages);
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
      await startAudioWithCounter(true,null);
      await audioService.handleRecord();
    } catch (e) {
      Exception(e);
    }
  }


  finishAudioRecording()async{
    try{
      isRecording.value=false;
      AudioService audioService = Get.find();
      File? audioFile=await audioService.stopRecording();
      if(audioFile!=null){
        rxAudio.value=audioFile;
        await sendMessage();
      }
      stopCounter();
    }catch(e){
      Exception(e);
    }
  }

  startAudioPlayback(String path,int audioDuration)async{
    try{
      AudioService audioService = Get.put(AudioService());
      audioService.isPlaying.listen((value){
        isAudioPlaying.value=value;
      });
      currentAudioPath.value=path;
      await startAudioWithCounter(false,audioDuration);
      await audioService.startPlaying(path);
    }catch(e){
      Exception(e);
    }
  }

  pausePlaying()async{
    AudioService audioService = Get.find();
    await audioService.pausePlaying();
    isAudioPlaying.value=false;
    stopCounter();
  }

  cancelAudioRecording()async{
    AudioService audioService = Get.find();
    await audioService.cancelRecording();
    countdownTimer.value?.cancel();
    countdownTimer.value = null;
    isRecording.value=false;
  }


  Rx<Timer?> countdownTimer = Rx<Timer?>(null);
  var audioDurationValue=0.obs;

  startAudioWithCounter(bool isRecording,int? audioDuration) async{
    try{
      countdownTimer.value?.cancel();
      countdownTimer.value = Timer.periodic(const Duration(seconds: 1), (timer) async{
        audioDurationValue.value=countdownTimer.value!.tick;
        if (isRecording && timer.tick >= 59) {
          await finishAudioRecording();
          countdownTimer.value?.cancel();
          countdownTimer.value = null;
        }
        else if(!isRecording && audioDuration!=null && timer.tick >= audioDuration){
          stopCounter();
        }
      });
    }catch(e){
      Exception(e);
    }
  }

  void stopCounter() {
    countdownTimer.value?.cancel();
    countdownTimer.value = null;
    audioDurationValue.value=0;
  }

}