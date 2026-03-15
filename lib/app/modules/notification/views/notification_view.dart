import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../controllers/notification_controller.dart';
import '../../../data/models/notification_model.dart';

class NotificationView extends GetView<NotificationController> {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: 24.r),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Notifications',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18.sp),
        ),
        centerTitle: true,
        actions: [
          Obx(() => controller.unreadCount.value > 0
              ? TextButton(
                  onPressed: () => controller.markAllAsRead(),
                  child: Text(
                    "Mark all as read",
                    style: TextStyle(color: const Color(0xFF006437), fontSize: 13.sp),
                  ),
                )
              : const SizedBox.shrink()),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.notifications.isEmpty) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF006437)));
        }

        if (controller.notifications.isEmpty) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          onRefresh: controller.fetchNotifications,
          color: const Color(0xFF006437),
          child: ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            itemCount: controller.notifications.length,
            itemBuilder: (context, index) {
              final notification = controller.notifications[index];
              return _buildNotificationItem(notification);
            },
          ),
        );
      }),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none, size: 80.r, color: Colors.grey[300]),
          SizedBox(height: 16.h),
          Text(
            "No Notifications Yet",
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.grey[600]),
          ),
          SizedBox(height: 8.h),
          Text(
            "We'll notify you when something important happens.",
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[400]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(NotificationModel notification) {
    IconData icon;
    Color iconColor;
    Color bgColor;

    switch (notification.type) {
      case 'ORDER':
        icon = Icons.shopping_bag_outlined;
        iconColor = Colors.orange;
        bgColor = Colors.orange[50]!;
        break;
      case 'PROFILE':
        icon = Icons.person_outline;
        iconColor = Colors.blue;
        bgColor = Colors.blue[50]!;
        break;
      case 'ACCOUNT':
        icon = Icons.account_circle_outlined;
        iconColor = Colors.green;
        bgColor = Colors.green[50]!;
        break;
      default:
        icon = Icons.notifications_none;
        iconColor = Colors.grey;
        bgColor = Colors.grey[50]!;
    }

    return Dismissible(
      key: Key(notification.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Icon(Icons.delete, color: Colors.white, size: 24.r),
      ),
      onDismissed: (direction) => controller.deleteNotification(notification.id),
      child: InkWell(
        onTap: () => controller.markAsRead(notification.id),
        child: Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: notification.isRead ? Colors.white : const Color(0xFFF0F9F4),
            border: Border(bottom: BorderSide(color: Colors.grey[100]!)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
                child: Icon(icon, color: iconColor, size: 22.r),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        Text(
                          _formatDate(notification.createdAt),
                          style: TextStyle(fontSize: 11.sp, color: Colors.grey),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      notification.message,
                      style: TextStyle(fontSize: 13.sp, color: Colors.grey[600], height: 1.4),
                    ),
                  ],
                ),
              ),
              if (!notification.isRead)
                Container(
                  margin: EdgeInsets.only(left: 8.w, top: 4.h),
                  width: 8.r,
                  height: 8.r,
                  decoration: const BoxDecoration(color: Color(0xFF006437), shape: BoxShape.circle),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 60) {
      return "${difference.inMinutes}m ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours}h ago";
    } else if (difference.inDays < 7) {
      return "${difference.inDays}d ago";
    } else {
      return DateFormat('dd MMM').format(date);
    }
  }
}
