// RUN: clspv %s -o %t.spv
// RUN: spirv-dis -o %t2.spvasm %t.spv
// RUN: FileCheck %s < %t2.spvasm
// RUN: spirv-val --target-env vulkan1.0 %t.spv

// CHECK-DAG: %[[HALF_TYPE_ID:[a-zA-Z0-9_]*]] = OpTypeFloat 16
// CHECK-DAG: %[[HALF_VECTOR_TYPE_ID:[a-zA-Z0-9_]*]] = OpTypeVector %[[HALF_TYPE_ID]] 4
// CHECK-DAG: %[[CONSTANT_42_ID:[a-zA-Z0-9_]*]] = OpConstant %[[HALF_TYPE_ID]] 0x1.5p+5
// CHECK-DAG: %[[COMPOSITE_42_ID:[a-zA-Z0-9_]*]] = OpConstantComposite %[[HALF_VECTOR_TYPE_ID]] %[[CONSTANT_42_ID]] %[[CONSTANT_42_ID]] %[[CONSTANT_42_ID]] %[[CONSTANT_42_ID]]
// CHECK-DAG: %[[CONSTANT_1_ID:[a-zA-Z0-9_]*]] = OpConstant %[[HALF_TYPE_ID]] 0x1p+0
// CHECK-DAG: %[[COMPOSITE_1_ID:[a-zA-Z0-9_]*]] = OpConstantComposite %[[HALF_VECTOR_TYPE_ID]] %[[CONSTANT_1_ID]] %[[CONSTANT_1_ID]] %[[CONSTANT_1_ID]] %[[CONSTANT_1_ID]]
// CHECK: %[[LOADB_ID:[a-zA-Z0-9_]*]] = OpLoad %[[HALF_VECTOR_TYPE_ID]]
// CHECK: %[[MUL_ID:[a-zA-Z0-9_]*]] = OpFMul %[[HALF_VECTOR_TYPE_ID]] %[[LOADB_ID]] %[[COMPOSITE_42_ID]]
// CHECK: %[[ADD_ID:[a-zA-Z0-9_]*]] = OpFAdd %[[HALF_VECTOR_TYPE_ID]] %[[MUL_ID]] %[[COMPOSITE_1_ID]]
// CHECK: OpStore {{.*}} %[[ADD_ID]]

void kernel __attribute__((reqd_work_group_size(1, 1, 1))) foo(global half4* a, global half4* b)
{
  *a = mad(*b, (half4)42.0f, (half4)1.0f);
}

