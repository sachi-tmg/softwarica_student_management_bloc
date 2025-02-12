import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:softwarica_student_management_bloc/features/auth/presentation/view/register_view.dart';
import 'package:softwarica_student_management_bloc/features/auth/presentation/view_model/signup/register_bloc.dart';
import 'package:softwarica_student_management_bloc/features/batch/domain/entity/batch_entity.dart';
import 'package:softwarica_student_management_bloc/features/batch/presentation/view_model/batch_bloc.dart';
import 'package:softwarica_student_management_bloc/features/course/domain/entity/course_entity.dart';
import 'package:softwarica_student_management_bloc/features/course/presentation/view_model/course_bloc.dart';

import 'test_data/batch_test_data.dart';
import 'test_data/course_test_data.dart';

class MockBatchBloc extends MockBloc<BatchEvent, BatchState>
    implements BatchBloc {}

class MockCourseBloc extends MockBloc<CourseEvent, CourseState>
    implements CourseBloc {}

class MockRegisterBloc extends MockBloc<RegisterEvent, RegisterState>
    implements RegisterBloc {}

void main() {
  late MockBatchBloc batchBloc;
  late MockCourseBloc courseBloc;
  late MockRegisterBloc registerBloc;

  setUp(() {
    batchBloc = MockBatchBloc();
    courseBloc = MockCourseBloc();
    registerBloc = MockRegisterBloc();
  });

  Widget loadRegisterView(Widget body) {
    when(() => batchBloc.state).thenReturn(BatchState(
      isLoading: false,
      error: '',
      batches: BatchTestData.getBatchTestData(),
    ));
    // Load CourseTestData
    when(() => courseBloc.state).thenReturn(CourseState(
      isLoading: false,
      error: '',
      courses: CourseTestData.getCourseTestData(),
    ));
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<BatchBloc>.value(value: batchBloc),
          BlocProvider<CourseBloc>.value(value: courseBloc),
          BlocProvider<RegisterBloc>.value(value: registerBloc),
        ],
        child: RegisterView(),
      ),
    );
  }

  testWidgets('Check for the title "Register Student"', (tester) async {
    await tester.pumpWidget(loadRegisterView(RegisterView()));

    await tester.pumpAndSettle();

    expect(find.text('Register Student'), findsOneWidget);
  });

  // Check for the Dropdown data
  testWidgets('Load Dropdown value and select Second index data',
      (tester) async {
    await tester.pumpWidget(loadRegisterView(RegisterView()));

    await tester.pumpAndSettle();

    final dropdownFinder = find.byType(DropdownButtonFormField<BatchEntity>);
    await tester.ensureVisible(dropdownFinder);

    await tester.tap(dropdownFinder);

    // Use this because the menu items are not visible
    await tester.pumpAndSettle();

    //tap on the first item in the dropdown
    await tester.tap(find.byType(DropdownMenuItem<BatchEntity>).at(1));
    //Use this to close the dropdown
    await tester.pumpAndSettle();

    expect(find.text('33-B'), findsOneWidget);
  });

  // Check for the MultiSelect Dialog field
  testWidgets('Load MultiSelect Dialog and select mobile  and web api',
      (tester) async {
    await tester.pumpWidget(loadRegisterView(RegisterView()));

    await tester.pumpAndSettle();
    final multiSelectFinder = find.byType(MultiSelectDialogField<CourseEntity>);
    await tester.ensureVisible(multiSelectFinder);

    await tester.tap(multiSelectFinder);
    await tester.pumpAndSettle();

    await tester.tap(find.text('mobile'));
    await tester.tap(find.text('web api'));

    await tester.tap(find.text('OK'));

    await tester.pumpAndSettle();

    expect(find.text('mobile'), findsOneWidget);
  });

  // Test all the fields
  testWidgets('test all the fields', (tester) async {
    await tester.pumpWidget(loadRegisterView(RegisterView()));

    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), 'Sachi');
    await tester.enterText(find.byType(TextFormField).at(1), 'Tamang');
    await tester.enterText(find.byType(TextFormField).at(2), '9876543210');
    await tester.enterText(find.byType(TextFormField).at(3), 'sachi');
    await tester.enterText(find.byType(TextFormField).at(4), 'sachi123');

    //=========================== Find the dropdownformfield===========================

    final dropdownFinder = find.byType(DropdownButtonFormField<BatchEntity>);

    when(() => registerBloc.state).thenReturn(RegisterState(
      isLoading: false,
      isSuccess: true,
    ));

    await tester.ensureVisible(dropdownFinder);

    await tester.tap(dropdownFinder);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(DropdownMenuItem<BatchEntity>).at(0));

    await tester.pumpAndSettle();

    //=========================== Find the MultiSelectDialogField===========================
    final multiSelectFinder = find.byType(MultiSelectDialogField<CourseEntity>);
    await tester.ensureVisible(multiSelectFinder);

    await tester.tap(multiSelectFinder);
    await tester.pumpAndSettle();

    await tester.tap(find.text('mobile'));
    await tester.tap(find.text('web api'));

    await tester.tap(find.text('OK'));

    await tester.pumpAndSettle();

    //=========================== Find the register button===========================
    final registerButtonFinder =
        find.widgetWithText(ElevatedButton, 'Register');

    await tester.tap(registerButtonFinder);

    await tester.pumpAndSettle();

    expect(find.text('Sachi'), findsOneWidget);
    expect(find.text('Tamang'), findsOneWidget);
    expect(find.text('9876543210'), findsOneWidget);
    expect(find.text('sachi'), findsOneWidget);
    expect(find.text('sachi123'), findsOneWidget);
    expect(find.text('mobile'), findsOneWidget);
    expect(registerBloc.state.isSuccess, true);
  });
}
