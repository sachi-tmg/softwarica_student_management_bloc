import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:softwarica_student_management_bloc/core/error/failure.dart';
import 'package:softwarica_student_management_bloc/features/auth/domain/use_case/login_usecase.dart';

import '../../../batch/domain/use_case/token.mock.dart';
import 'auth_repo.mock.dart';

void main() {
  late AuthRepoMock repository;
  late MockTokenSharedPrefs tokenSharedPrefs;
  late LoginUseCase usecase;

  setUp(() {
    repository = AuthRepoMock();
    tokenSharedPrefs = MockTokenSharedPrefs();
    usecase = LoginUseCase(repository, tokenSharedPrefs);
  });

  test(
      'should call the [AuthRepo.login] with correct username and password (sachi, sachi123)',
      () async {
    when(() => repository.loginStudent(any(), any()))
        .thenAnswer((invocation) async {
      final username = invocation.positionalArguments[0] as String;
      final password = invocation.positionalArguments[1] as String;
      if (username == 'sachi' && password == 'sachi123') {
        return Future.value(const Right('token'));
      } else {
        return Future.value(
            Left(ApiFailure(message: 'Invalid username or password')));
      }
    });

    when(() => tokenSharedPrefs.saveToken(any())).thenAnswer(
      (_) async => Right(null),
    );
    final result = await usecase(LoginParams(
      username: 'sachi',
      password: 'sachi123',
    ));

    expect(result, const Right('token'));

    verify(() => repository.loginStudent(any(), any())).called(1);
    verify(() => tokenSharedPrefs.saveToken(any())).called(1);

    verifyNoMoreInteractions(repository);
    verifyNoMoreInteractions(tokenSharedPrefs);
  });
}

  // tearDown(() {
  //   reset(repository);
  //   reset(tokenSharedPrefs);
  // });
