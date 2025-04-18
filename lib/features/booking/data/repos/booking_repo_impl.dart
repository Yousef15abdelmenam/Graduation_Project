// booking_repo_impl.dart

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:graduation_project/core/errors/failures.dart';
import 'package:graduation_project/core/utils/api_service.dart';
import 'package:graduation_project/features/booking/data/models/booking.model.dart';
import 'package:graduation_project/features/booking/data/repos/booking_repo.dart';

class BookingRepoImpl implements BookingRepo {
  final ApiService apiService;

  BookingRepoImpl(this.apiService);

  @override
  Future<Either<Failure, bool>> confirmBookingApi(BookingModel booking) async {
    try {
      // Make the API request to confirm booking
      final response = await apiService.post(
        endPoint: 'Booking',  // Adjust the endpoint as needed
        data: booking.toJson(),  // Convert the booking model to JSON
      );

      // Assuming the API response has a status field indicating success
      if (response['status'] == 'success') {
        return right(true);  // Booking was successful
      } else {
        return left(ServerFailure('Booking failed'));
      }
    } catch (e) {
      if (e is DioError) {
        return left(ServerFailure.fromDioError(e));  // Handle Dio errors
      } else {
        return left(ServerFailure(e.toString()));  // Handle other errors
      }
    }
  }
}
