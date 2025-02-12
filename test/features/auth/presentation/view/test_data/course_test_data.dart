import 'package:softwarica_student_management_bloc/features/course/domain/entity/course_entity.dart';

class CourseTestData {
  CourseTestData._();

  static List<CourseEntity> getCourseTestData() {
    List<CourseEntity> lstCourses = [
      const CourseEntity(
        courseId: "678746f51c4cbce68c03adea",
        courseName: "web api",
      ),
      const CourseEntity(
        courseId: "679786ec6f6bc14aff8e123d",
        courseName: "mobile",
      ),
      const CourseEntity(
        courseId: "6797875a6f6bc14aff8e124f",
        courseName: "design",
      ),
      const CourseEntity(
        courseId: "6797921edee755661cf1fc0a",
        courseName: "individual",
      ),
    ];

    return lstCourses;
  }
}
