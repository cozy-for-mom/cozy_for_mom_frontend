import 'dart:convert';

import 'package:cozy_for_mom_frontend/model/notification_model.dart';
import 'package:cozy_for_mom_frontend/service/base_api.dart';
import 'package:cozy_for_mom_frontend/service/base_headers.dart';
import 'package:cozy_for_mom_frontend/utils/http_response_handlers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class NotificationApiService extends ChangeNotifier {
  Future<List<dynamic>?> getNotifications(
      BuildContext context, String type) async {
    try {
      final url = Uri.parse('$baseUrl/notification/record?type=$type');

      final headers = await getHeaders();
      Response res = await get(url, headers: headers);
      String? message = jsonDecode(utf8.decode(res.bodyBytes))['message'];
      if (res.statusCode == 200) {
        Map<String, dynamic> body = jsonDecode(utf8.decode(res.bodyBytes));
        List<dynamic> notificationsData = body['data']['notification'];
        List<NotificationModel> notifications =
            notificationsData.map((notification) {
          return NotificationModel.fromJson(notification, type);
        }).toList();
        return notifications;
      } else {
        if (context.mounted) {
          handleHttpResponse(res.statusCode, context, message);
        }
        return null;
        // throw Exception('$type 알림 목록 조회를 실패하였습니다.');
      }
    } catch (e) {
      // 에러 처리
      print(e);
      return null;
    }
  }

  Future<Map<String, dynamic>?> getUpcomingNotification(
      BuildContext context) async {
    try {
      final url = Uri.parse('$baseUrl/notification/record/upcoming');

      final headers = await getHeaders();
      Response res = await get(url, headers: headers);
      String? message = jsonDecode(utf8.decode(res.bodyBytes))['message'];
      if (res.statusCode == 200) {
        Map<String, dynamic> upcomingNotification =
            jsonDecode(utf8.decode(res.bodyBytes));
        return upcomingNotification['data'];
      } else {
        if (context.mounted) {
          handleHttpResponse(res.statusCode, context, message);
        }
        return null;
        // throw Exception('가장 가까운 알림을 불러오는데 실패하였습니다.');
      }
    } catch (e) {
      // 에러 처리
      print(e);
      return null;
    }
  }

  Future<int?> recordNotification(
      BuildContext context, NotificationModel notification) async {
    final url = Uri.parse('$baseUrl/notification/record');
    final headers = await getHeaders();
    Map data = {
      'type': notification.type,
      'title': notification.title,
      'notifyAt': notification.notifyAt,
      'targetTimeAt': notification.targetTimeAt,
      'daysOfWeek': notification.daysOfWeek
    };

    final Response res =
        await post(url, headers: headers, body: jsonEncode(data));
    String? message = jsonDecode(utf8.decode(res.bodyBytes))['message'];
    Map<String, dynamic> resData = jsonDecode(res.body);
    if (res.statusCode == 201) {
      notifyListeners();
      return resData['data']['id'];
    } else {
      if (context.mounted) {
        handleHttpResponse(res.statusCode, context, message);
      }
      return null;
      // throw Exception(
      //     '${notification.type} ${notification.title} 알림 등록을 실패하였습니다.');
    }
  }

  Future<int?> modifyNotification(
      BuildContext context, int id, NotificationModel notification) async {
    final url = Uri.parse('$baseUrl/notification/record/$id');
    final headers = await getHeaders();
    Map data = {
      'title': notification.title,
      'notifyAt': notification.notifyAt,
      'targetTimeAt': notification.targetTimeAt,
      'daysOfWeek': notification.daysOfWeek
    };

    final Response res =
        await put(url, headers: headers, body: jsonEncode(data));
    String? message = jsonDecode(utf8.decode(res.bodyBytes))['message'];
    Map<String, dynamic> resData = jsonDecode(res.body);
    if (res.statusCode == 200) {
      return resData['data']['id'];
    } else {
      if (context.mounted) {
        handleHttpResponse(res.statusCode, context, message);
      }
      return null;
      // throw Exception(
      //     '${notification.type} ${notification.title} 알림 수정을 실패하였습니다.');
    }
  }

  Future<int?> modifyNotificationActive(
      BuildContext context, int id, bool isActive) async {
    final url = Uri.parse('$baseUrl/notification/record/active/$id');
    final headers = await getHeaders();
    Map data = {'isActive': isActive};

    final Response res =
        await put(url, headers: headers, body: jsonEncode(data));
    Map<String, dynamic> resData = jsonDecode(res.body);
    String? message = jsonDecode(utf8.decode(res.bodyBytes))['message'];
    if (res.statusCode == 200) {
      return resData['data']['id'];
    } else {
      if (context.mounted) {
        handleHttpResponse(res.statusCode, context, message);
      }
      return null;
      // throw Exception('알림 활성화 수정을 실패하였습니다.');
    }
  }

  Future<void> deleteNotification(BuildContext context, int id) async {
    final url = Uri.parse('$baseUrl/notification/record/$id');
    final headers = await getHeaders();
    Response res = await delete(url, headers: headers);
    if (res.statusCode == 204) {
      print('$id 알림 기록이 삭제되었습니다.');
    } else {
      if (context.mounted) {
        handleHttpResponse(res.statusCode, context, null);
      }
      // throw '$id 알림 기록 삭제를 실패하였습니다.';
    }
  }
}
