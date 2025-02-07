import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:softwarica_student_management_bloc/features/batch/domain/entity/batch_entity.dart';
import 'package:softwarica_student_management_bloc/features/batch/domain/use_case/get_all_batch_usecase.dart';

import 'repository.mock.dart';

void main() {
  late MockBatchRepository repository;
  late GetAllBatchUseCase usecase;

  setUp(() {
    repository = MockBatchRepository();
    usecase = GetAllBatchUseCase(batchRepository: repository);
  });

  final tBatch = BatchEntity(
    batchId: '1',
    batchName: 'Test batch',
  );

  final tBatch2 = BatchEntity(
    batchId: '2',
    batchName: 'Test batch 2',
  );

  final tBatches = [tBatch, tBatch2];

  test('should get batches from repository', () async {
    when(() => repository.getBatches()).thenAnswer(
      (_) async => Right(tBatches),
    );

    final result = await usecase();

    expect(result, Right(tBatches));

    verify(() => repository.getBatches()).called(1);
  });
}
