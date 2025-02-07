import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:softwarica_student_management_bloc/core/error/failure.dart';
import 'package:softwarica_student_management_bloc/features/batch/domain/use_case/delete_batch_usecase.dart';

import 'repository.mock.dart';
import 'token.mock.dart';

void main() {
  late DeleteBatchUsecase usecase;
  late MockBatchRepository repository;
  late MockTokenSharedPrefs tokenSharedPrefs;

  setUp(() {
    repository = MockBatchRepository();
    tokenSharedPrefs = MockTokenSharedPrefs();
    usecase = DeleteBatchUsecase(
      batchRepository: repository,
      tokenSharedPrefs: tokenSharedPrefs,
    );
  });

  final tBatchId = '1';
  final token = 'token';
  final deleteBatchParams = DeleteBatchParams(batchId: tBatchId);

  test('delete batch using id', () async {
    when(() => tokenSharedPrefs.getToken())
        .thenAnswer((_) async => Right(token));

    when(() => repository.deleteBatch(any(), any())).thenAnswer(
      (_) async => Right(null),
    );

    final result = await usecase(deleteBatchParams);

    expect(result, Right(null));

    verify(() => tokenSharedPrefs.getToken()).called(1);
    verify(() => repository.deleteBatch(tBatchId, token)).called(1);

    verifyNoMoreInteractions(repository);
    verifyNoMoreInteractions(tokenSharedPrefs);
  });

  test('delete batch using id and check whether the is is batch1', () async {
    when(() => tokenSharedPrefs.getToken())
        .thenAnswer((_) async => Right(token));

    when(() => repository.deleteBatch(any(), any())).thenAnswer(
      (invocation) async {
        final batchId = invocation.positionalArguments[0] as String;

        if (batchId == 'batchId') {
          return Right(null);
        } else {
          return Left(ApiFailure(
            message: 'Batch not found',
          ));
        }
      },
    );

    final result = await usecase(DeleteBatchParams(batchId: 'batch1'));

    expect(result, Right(null));

    verify(() => tokenSharedPrefs.getToken()).called(1);
    verify(() => repository.deleteBatch('batch1', token)).called(1);

    verifyNoMoreInteractions(repository);

    verifyNoMoreInteractions(tokenSharedPrefs);
  });
}
