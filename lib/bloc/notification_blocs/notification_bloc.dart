import 'package:famdocs/models/notification.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationBloc extends Cubit<List<Notification>>{
  NotificationBloc(super.initialState);

  void loadNotifications(int offset,int limit){
    //request for notifications
    List<Notification> test = [Notification("This is a notification text just for testing", BigInt.one, false,"2h"),
      Notification("This is a notification text just for testingThis is a notification text just for testing", BigInt.one, false,"3h")
      ,Notification("This is a notification text just for testingThis is a notification text just for testing", BigInt.one, false,"4h")];
    Notification notif = Notification("This is a notification text just for testingThis is a notification text just for testing", BigInt.one, false, "5h");
    notif.setMarkerText("Today");
    test.add(notif);
    notif = Notification("This is a notification text just for testingThis is a notification text just for testing", BigInt.one, false, "6h");
    notif.addAction(NotificationAction.APPROVE_REQUEST, (){});
    test.add(notif);
    emit(test);
  }
}