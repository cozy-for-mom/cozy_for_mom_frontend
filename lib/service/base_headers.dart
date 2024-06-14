import 'package:cozy_for_mom_frontend/service/user/token_manager.dart'
    as TokenManager;

Future<Map<String, String>> getHeaders() async {
  final tokenManager = TokenManager.TokenManager();
  String? token = await tokenManager.getToken(); // 비동기적으로 토큰을 받아옴
  const beforeHeaders = {'Content-Type': 'application/json; charset=UTF-8'};
  final headers = {
    ...beforeHeaders, // 기존 헤더 확장
    if (token != null) 'Authorization': 'Bearer $token',
  };
  return headers;
}
