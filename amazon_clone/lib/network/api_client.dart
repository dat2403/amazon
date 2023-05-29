import 'package:http_interceptor/http_interceptor.dart';

class ApiClient {
  static InterceptedClient client = InterceptedClient.build(interceptors: [
    LoggingInterceptor(),
  ]);
}

class LoggingInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    print(">> ${data.url}: ${data.method}");
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    print("<< [${data.statusCode}] ${data.url}: ${data.method}");
    return data;
  }
}

class HttpHandlerInterceptor implements InterceptorContract {
  final Function onAuthFail;

  HttpHandlerInterceptor({required this.onAuthFail});

  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    if (data.statusCode == 401) {
      onAuthFail.call();
    }
    return data;
  }
}
