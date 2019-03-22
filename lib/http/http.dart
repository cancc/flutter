import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

class HttpUtil {
//  get 数据请求
  getJson(baseUrl) async {
    var dio = new Dio();
      var response;
      response = await dio.get(baseUrl);
//    print(response);
    return response;
  }
  // post 数据请求
  postJson(baseUrl, api, map) async {
    var dio = new Dio(new Options(
        baseUrl: baseUrl,
        headers: {
          "user-agent": "dio",
          "api": "1.0.0",
          "version": 1,
          "enterprise": 1,
          "pid": 5,
        },
//      contentType: ContentType.JSON,
        responseType: ResponseType.PLAIN)
    );
    Response<String> response;
    response = await dio.post(
      api,
      data: map,
      options: new Options(
          contentType: ContentType.parse("application/json; charset=utf-8")
      ),
    );
//    print(response);
    return response;
  }

//  post formdata表单请求
  postForm(baseUrl, api, map) async {
    var dio = new Dio(new Options(
        baseUrl: baseUrl,
        headers: {
          "user-agent": "dio",
          "api": "1.0.0",
          "version": 1,
          "enterprise": 1,
          "pid": 5,
        },
        responseType: ResponseType.PLAIN));
    Response<String> response;
    response = await dio.post(
        api,
        data: new FormData.from(map)
    );
//    print(response);
    return response;
  }

  //  post formdata表单请求
  postFormEdit(baseUrl, api, map) async {
    var dio = new Dio(new Options(
        baseUrl: baseUrl,
        headers: {
          "user-agent": "dio",
          "api": "1.0.0",
          "pid": 5,
        },
        responseType: ResponseType.PLAIN));
    Response<String> response;
    response = await dio.post(api,
        data: map,
        options: new Options(
            contentType: ContentType.parse("application/json; charset=utf-8")));
//    print(response);
    return response;
  }
}