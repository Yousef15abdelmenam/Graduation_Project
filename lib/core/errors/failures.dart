import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

abstract class Failure {
  final String errMessage;

  Failure(this.errMessage);
}

class ServerFailure extends Failure {
  ServerFailure(super.errMessage);

  factory ServerFailure.fromDioError(DioError dioError) {
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailure('Connection timeout with ApiServer');
      case DioExceptionType.sendTimeout:
        return ServerFailure('Send TimeOut with ApiServer');
      case DioExceptionType.receiveTimeout:
        return ServerFailure('Recieve TimeOut with ApiServer');
      case DioExceptionType.badCertificate:
        return ServerFailure('Bad Certificate with the server');
      case DioExceptionType.badResponse:
        return ServerFailure.fromResponse(
            dioError.response!.statusCode!, dioError.response!.data);
      case DioExceptionType.cancel:
        return ServerFailure('Request to ApiServer was canceld');

      case DioExceptionType.connectionError:
        return ServerFailure('No Internet connection');

      case DioExceptionType.unknown:
        if (dioError.message!.contains('SocketException')) {
          return ServerFailure('No Internet connection');
        } else {
          return ServerFailure('oops there is an error');
        }

      default:
        return ServerFailure('oops there is an error');
    }
  }

  factory ServerFailure.fromResponse(int statuesCode, dynamic response) {
    if (statuesCode == 400 || statuesCode == 401 || statuesCode == 403) {
      return ServerFailure(response['error']['message']);
    } else if (statuesCode == 404) {
      return ServerFailure('Your Request Not Found , Please Try Later!');
    } else {
      return ServerFailure('oops there is an error');
    }
  }
}
