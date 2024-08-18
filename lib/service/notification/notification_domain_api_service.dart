import 'dart:convert';

import 'package:cozy_for_mom_frontend/model/notification_model.dart';
import 'package:cozy_for_mom_frontend/service/base_api.dart';
import 'package:cozy_for_mom_frontend/service/base_headers.dart';
import 'package:cozy_for_mom_frontend/utils/http_response_handlers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class NotificationApiService extends ChangeNotifier {
  Future<List<dynamic>> getNotifications(
      BuildContext context, String type) async {
    try {
      final url = Uri.parse('$baseUrl/notification/record?type=$type');

      final headers = await getHeaders();
      Response res = await get(url, headers: headers);
      if (res.statusCode == 200) {
        Map<String, dynamic> body = jsonDecode(utf8.decode(res.bodyBytes));
        List<dynamic> notificationsData = body['data']['notification'];
        List<NotificationModel> notifications =
            notificationsData.map((notification) {
          return NotificationModel.fromJson(notification, type);
        }).toList();
        return notifications;
      } else {
        handleHttpResponse(res.statusCode, context);

        throw Exception('$type 알림 목록 조회를 실패하였습니다.');
      }
    } catch (e) {
      // 에러 처리
      print(e);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getUpcomingNotification(
      BuildContext context) async {
    try {
      final url = Uri.parse('$baseUrl/notification/record/upcoming');

      final headers = await getHeaders();
      Response res = await get(url, headers: headers);
      if (res.statusCode == 200) {
        Map<String, dynamic> upcomingNotification =
            jsonDecode(utf8.decode(res.bodyBytes));
        return upcomingNotification['data'];
      } else {
        handleHttpResponse(res.statusCode, context);

        throw Exception('가장 가까운 알림을 불러오는데 실패하였습니다.');
      }
    } catch (e) {
      // 에러 처리
      print(e);
      rethrow;
    }
  }

  Future<int> recordNotification(
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

    final Response response =
        await post(url, headers: headers, body: jsonEncode(data));
    Map<String, dynamic> responseData = jsonDecode(response.body);
    if (response.statusCode == 201) {
      notifyListeners();
      return responseData['data']['id'];
    } else {
      handleHttpResponse(response.statusCode, context);

      throw Exception(
          '${notification.type} ${notification.title} 알림 등록을 실패하였습니다.');
    }
  }

  Future<int> modifyNotification(
      BuildContext context, int id, NotificationModel notification) async {
    final url = Uri.parse('$baseUrl/notification/record/$id');
    final headers = await getHeaders();
    Map data = {
      'title': notification.title,
      'notifyAt': notification.notifyAt,
      'targetTimeAt': notification.targetTimeAt,
      'daysOfWeek': notification.daysOfWeek
    };

    final Response response =
        await put(url, headers: headers, body: jsonEncode(data));
    Map<String, dynamic> responseData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return responseData['data']['id'];
    } else {
      handleHttpResponse(response.statusCode, context);

      throw Exception(
          '${notification.type} ${notification.title} 알림 수정을 실패하였습니다.');
    }
  }

  Future<int> modifyNotificationActive(
      BuildContext context, int id, bool isActive) async {
    final url = Uri.parse('$baseUrl/notification/record/active/$id');
    final headers = await getHeaders();
    Map data = {'isActive': isActive};

    final Response response =
        await put(url, headers: headers, body: jsonEncode(data));
    Map<String, dynamic> responseData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return responseData['data']['id'];
    } else {
      handleHttpResponse(response.statusCode, context);

      throw Exception('알림 활성화 수정을 실패하였습니다.');
    }
  }

  Future<void> deleteNotification(BuildContext context, int id) async {
    final url = Uri.parse('$baseUrl/notification/record/$id');
    final headers = await getHeaders();
    Response res = await delete(url, headers: headers);
    if (res.statusCode == 204) {
      print('$id 알림 기록이 삭제되었습니다.');
    } else {
      handleHttpResponse(res.statusCode, context);

      throw '$id 알림 기록 삭제를 실패하였습니다.';
    }
  }
}
