import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/models/notification_model.dart';
import '../../../data/providers/notification_provider.dart';

class NotificationController extends GetxController {
  final NotificationProvider _provider = NotificationProvider();
  final GetStorage _storage = GetStorage();
  
  var notifications = <NotificationModel>[].obs;
  var unreadCount = 0.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;
      final token = _storage.read('access_token');
      if (token != null) {
        final response = await _provider.getNotifications(token);
        notifications.assignAll(response.notifications);
        unreadCount.value = response.unreadCount;
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markAsRead(int id) async {
    try {
      final token = _storage.read('access_token');
      if (token != null) {
        await _provider.markAsRead(token, id);
        // Update local state
        final index = notifications.indexWhere((n) => n.id == id);
        if (index != -1 && !notifications[index].isRead) {
          notifications[index] = NotificationModel(
            id: notifications[index].id,
            userId: notifications[index].userId,
            title: notifications[index].title,
            message: notifications[index].message,
            type: notifications[index].type,
            isRead: true,
            createdAt: notifications[index].createdAt,
          );
          unreadCount.value--;
          notifications.refresh();
        }
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> markAllAsRead() async {
    try {
      final token = _storage.read('access_token');
      if (token != null) {
        await _provider.markAllAsRead(token);
        fetchNotifications(); // Refresh list
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> deleteNotification(int id) async {
    try {
      final token = _storage.read('access_token');
      if (token != null) {
        await _provider.deleteNotification(token, id);
        notifications.removeWhere((n) => n.id == id);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}
