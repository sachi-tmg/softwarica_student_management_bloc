import 'package:softwarica_student_management_bloc/features/batch/domain/entity/batch_entity.dart';

class BatchTestData {
  BatchTestData._();

  static List<BatchEntity> getBatchTestData() {
    List<BatchEntity> lstBatches = [
      const BatchEntity(
        batchId: "678746611c4cbce68c03ade6",
        batchName: "33-A",
      ),
      const BatchEntity(
        batchId: "6787466d1c4cbce68c03ade8",
        batchName: "33-B",
      ),
      const BatchEntity(
        batchId: "679791cfdee755661cf1fbf4",
        batchName: "33-C",
      ),
      const BatchEntity(
        batchId: "679791f8dee755661cf1fc00",
        batchName: "33-D",
      ),
    ];

    return lstBatches;
  }
}
