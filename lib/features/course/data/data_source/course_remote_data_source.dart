import 'package:dio/dio.dart';
import 'package:softwarica_student_management_bloc/app/constants/api_endpoints.dart';
import 'package:softwarica_student_management_bloc/features/course/data/data_source/course_data_source.dart';
import 'package:softwarica_student_management_bloc/features/course/data/dto/get_all_course_dto.dart';
import 'package:softwarica_student_management_bloc/features/course/data/model/course_api_model.dart';
import 'package:softwarica_student_management_bloc/features/course/domain/entity/course_entity.dart';

class CourseRemoteDataSource implements ICourseDataSource {
  final Dio _dio;

  CourseRemoteDataSource({
    required Dio dio,
  }) : _dio = dio;

  @override
  Future<void> createCourse(CourseEntity course) async {
    try {
      var courseApiModel = CourseApiModel.fromEntity(course);
      var response = await _dio.post(
        ApiEndpoints.createCourse,
        data: courseApiModel.toJson(),
      );
      if (response.statusCode == 201) {
        return;
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception(e);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> deleteCourse(String id) async {
    try {
      final response = await _dio.delete('${ApiEndpoints.deleteCourse}$id');
      if (response.statusCode == 204) {
        // Successful delete, return nothing
        await getCourses();
        return;
      } else {
        // Handle unexpected status codes
        throw Exception('Failed to delete course: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('DioException: ${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<List<CourseEntity>> getCourses() async {
    try {
      var response = await _dio.get(ApiEndpoints.getAllCourse);
      if (response.statusCode == 200) {
        GetAllCourseDTO courseAddDTO = GetAllCourseDTO.fromJson(response.data);
        return CourseApiModel.toEntityList(courseAddDTO.data);
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception(e);
    } catch (e) {
      throw Exception(e);
    }
  }
}
