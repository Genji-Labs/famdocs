import 'package:flutter/material.dart';

class Notification{
  Image? image;
  final String message;
  final BigInt id;
  final bool read;
  final String time;
  NotificationAction? action;
  String? markerText;
  Function? actionCallback;
  Notification(this.message,this.id,this.read,this.time);

  void addAction(NotificationAction action,Function actionCallback) {
    this.action = action;
    this.actionCallback = actionCallback;
  }
  void setMarkerText(String text) => markerText = text;
  void setImage(Image image) => this.image = image;

}

enum NotificationAction{
  VIEWFILE,
  APPROVE_REQUEST,
}

extension NotificationActionProperties on NotificationAction{

  String title(){
    switch(name){
      case "APPROVE_REQUEST":
        return "Approve";
      case "VIEWFILE":
        return "View";
    }
    return "";
  }
}