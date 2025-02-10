import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:softwarica_student_management_bloc/core/error/failure.dart';
import 'package:softwarica_student_management_bloc/features/batch/domain/entity/batch_entity.dart';
import 'package:softwarica_student_management_bloc/features/batch/domain/use_case/create_batch_usecase.dart';
import 'package:softwarica_student_management_bloc/features/batch/domain/use_case/delete_batch_usecase.dart';
import 'package:softwarica_student_management_bloc/features/batch/domain/use_case/get_all_batch_usecase.dart';
import 'package:softwarica_student_management_bloc/features/batch/presentation/view_model/batch_bloc.dart';

class MockCreateBatchUsecase extends Mock implements CreateBatchUseCase {}

class MockGetAllBatchUsecase extends Mock implements GetAllBatchUseCase {}

class MockDeleteBatchUsecase extends Mock implements DeleteBatchUsecase {}

void main() {
  late CreateBatchUseCase createBatchUseCase;
  late GetAllBatchUseCase getAllBatchUseCase;
  late DeleteBatchUsecase deleteBatchUsecase;
  late BatchBloc batchBloc;

  setUp(() {
    createBatchUseCase = MockCreateBatchUsecase();
    getAllBatchUseCase = MockGetAllBatchUsecase();
    deleteBatchUsecase = MockDeleteBatchUsecase();

    batchBloc = BatchBloc(
      createBatchUseCase: createBatchUseCase,
      getAllBatchUseCase: getAllBatchUseCase,
      deleteBatchUsecase: deleteBatchUsecase,
    );
  });

  final batch = BatchEntity(batchId: '1', batchName: 'Batch 1');
  final batch2 = BatchEntity(batchId: '2', batchName: 'Batch 2');
  final lstBatches = [batch, batch2];

  blocTest<BatchBloc, BatchState>(
    'emits [BatchState] with loaded batches when LoadBatche is added',
    build: () {
      when(() => getAllBatchUseCase.call())
          .thenAnswer((_) async => Left(ApiFailure(message: 'Error')));
      return batchBloc;
    },
    act: (bloc) => bloc.add(LoadBatches()),
    skip: 1,
    expect: () =>
        [BatchState.initial().copyWith(isLoading: false, batches: lstBatches)],
    verify: (_) {
      verify(() => getAllBatchUseCase.call()).called(1);
    },
  );
}
