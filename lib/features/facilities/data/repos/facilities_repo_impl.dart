import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:graduation_project/core/errors/failures.dart';
import 'package:graduation_project/core/utils/api_service.dart';
import 'package:graduation_project/features/facilities/data/models/facilities/facilities.model.dart';
import 'package:graduation_project/features/facilities/data/repos/facilities_repo.dart';

class FacilitiesRepoImpl implements FacilitiesRepo {
  final ApiService apiService;

  FacilitiesRepoImpl(this.apiService);

  @override
  Future<Either<Failure, List<FacilitiesModel>>> fetchFacilities() async {
    try {
      var data = await apiService.get(
          endPoint: 'Facilities/1');

        List<FacilitiesModel> facilities = [];
        facilities.add(FacilitiesModel.fromJson(data)); // Single object
        return right(facilities);

    } catch (e) {
      if (e is DioError) {
        return left(ServerFailure.fromDioError(e));
      } else {
        return left(ServerFailure(e.toString()));
      }
    }
  }
}
