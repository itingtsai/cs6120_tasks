; ModuleID = 'nbody.bc'
source_filename = "llvm-link"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

%struct.body = type { [3 x double], double, [3 x double], double }

@verify_benchmark.expected = internal unnamed_addr constant [5 x %struct.body] [%struct.body { [3 x double] zeroinitializer, double 0.000000e+00, [3 x double] [double 0xBF3967E9A7E0D6F3, double 0xBF6AD4ECFE5089FB, double 0x3EF919331F0B8A72], double 0x4043BD3CC9BE45DE }, %struct.body { [3 x double] [double 0x40135DA0343CD92C, double 0xBFF290ABC01FDB7C, double 0xBFBA86F96C25EBF0], double 0.000000e+00, [3 x double] [double 0x3FE367069B93CCBC, double 0x40067EF2F57D949B, double 0xBF99D2D79A5A0715], double 0x3FA34C95D9AB33D8 }, %struct.body { [3 x double] [double 0x4020AFCDC332CA67, double 0x40107FCB31DE01B0, double 0xBFD9D353E1EB467C], double 0.000000e+00, [3 x double] [double 0xBFF02C21B8879442, double 0x3FFD35E9BF1F8F13, double 0x3F813C485F1123B4], double 0x3F871D490D07C637 }, %struct.body { [3 x double] [double 0x4029C9EACEA7D9CF, double 0xC02E38E8D626667E, double 0xBFCC9557BE257DA0], double 0.000000e+00, [3 x double] [double 0x3FF1531CA9911BEF, double 0x3FEBCC7F3E54BBC5, double 0xBF862F6BFAF23E7C], double 0x3F5C3DD29CF41EB3 }, %struct.body { [3 x double] [double 0x402EC267A905572A, double 0xC039EB5833C8A220, double 0x3FC6F1F393ABE540], double 0.000000e+00, [3 x double] [double 0x3FEF54B61659BC4A, double 0x3FE307C631C4FBA3, double 0xBFA1CB88587665F6], double 0x3F60A8F3531799AC }], align 8
@solar_bodies = internal unnamed_addr global [5 x %struct.body] [%struct.body { [3 x double] zeroinitializer, double 0.000000e+00, [3 x double] zeroinitializer, double 0x4043BD3CC9BE45DE }, %struct.body { [3 x double] [double 0x40135DA0343CD92C, double 0xBFF290ABC01FDB7C, double 0xBFBA86F96C25EBF0], double 0.000000e+00, [3 x double] [double 0x3FE367069B93CCBC, double 0x40067EF2F57D949B, double 0xBF99D2D79A5A0715], double 0x3FA34C95D9AB33D8 }, %struct.body { [3 x double] [double 0x4020AFCDC332CA67, double 0x40107FCB31DE01B0, double 0xBFD9D353E1EB467C], double 0.000000e+00, [3 x double] [double 0xBFF02C21B8879442, double 0x3FFD35E9BF1F8F13, double 0x3F813C485F1123B4], double 0x3F871D490D07C637 }, %struct.body { [3 x double] [double 0x4029C9EACEA7D9CF, double 0xC02E38E8D626667E, double 0xBFCC9557BE257DA0], double 0.000000e+00, [3 x double] [double 0x3FF1531CA9911BEF, double 0x3FEBCC7F3E54BBC5, double 0xBF862F6BFAF23E7C], double 0x3F5C3DD29CF41EB3 }, %struct.body { [3 x double] [double 0x402EC267A905572A, double 0xC039EB5833C8A220, double 0x3FC6F1F393ABE540], double 0.000000e+00, [3 x double] [double 0x3FEF54B61659BC4A, double 0x3FE307C631C4FBA3, double 0xBFA1CB88587665F6], double 0x3F60A8F3531799AC }], align 8

; Function Attrs: nofree norecurse nosync nounwind ssp memory(argmem: readwrite) uwtable(sync)
define void @offset_momentum(ptr noundef captures(none) %0, i32 noundef %1) local_unnamed_addr #0 {
  %3 = icmp eq i32 %1, 0
  br i1 %3, label %27, label %4

4:                                                ; preds = %2
  %5 = getelementptr inbounds nuw i8, ptr %0, i64 32
  %6 = zext i32 %1 to i64
  br label %7

7:                                                ; preds = %4, %24
  %8 = phi i64 [ 0, %4 ], [ %25, %24 ]
  %9 = getelementptr inbounds nuw %struct.body, ptr %0, i64 %8
  %10 = getelementptr inbounds nuw i8, ptr %9, i64 32
  %11 = getelementptr inbounds nuw i8, ptr %9, i64 56
  br label %12

12:                                               ; preds = %7, %12
  %13 = phi i64 [ 0, %7 ], [ %22, %12 ]
  %14 = getelementptr inbounds nuw [3 x double], ptr %10, i64 0, i64 %13
  %15 = load double, ptr %14, align 8, !tbaa !6
  %16 = load double, ptr %11, align 8, !tbaa !10
  %17 = fmul double %15, %16
  %18 = fdiv double %17, 0x4043BD3CC9BE45DE
  %19 = getelementptr inbounds nuw [3 x double], ptr %5, i64 0, i64 %13
  %20 = load double, ptr %19, align 8, !tbaa !6
  %21 = fsub double %20, %18
  store double %21, ptr %19, align 8, !tbaa !6
  %22 = add nuw nsw i64 %13, 1
  %23 = icmp eq i64 %22, 3
  br i1 %23, label %24, label %12, !llvm.loop !12

24:                                               ; preds = %12
  %25 = add nuw nsw i64 %8, 1
  %26 = icmp eq i64 %25, %6
  br i1 %26, label %27, label %7, !llvm.loop !15

27:                                               ; preds = %24, %2
  ret void
}

; Function Attrs: nofree norecurse nosync nounwind ssp memory(argmem: read) uwtable(sync)
define double @bodies_energy(ptr noundef readonly captures(none) %0, i32 noundef %1) local_unnamed_addr #1 {
  %3 = alloca [3 x double], align 8
  call void @llvm.lifetime.start.p0(i64 24, ptr nonnull %3) #9
  %4 = icmp eq i32 %1, 0
  br i1 %4, label %65, label %5

5:                                                ; preds = %2
  %6 = getelementptr inbounds nuw i8, ptr %3, i64 8
  %7 = getelementptr inbounds nuw i8, ptr %3, i64 16
  %8 = zext i32 %1 to i64
  %9 = zext i32 %1 to i64
  br label %14

10:                                               ; preds = %49, %14
  %11 = phi double [ %32, %14 ], [ %61, %49 ]
  %12 = add nuw nsw i64 %16, 1
  %13 = icmp eq i64 %33, %9
  br i1 %13, label %65, label %14, !llvm.loop !16

14:                                               ; preds = %5, %10
  %15 = phi i64 [ 0, %5 ], [ %33, %10 ]
  %16 = phi i64 [ 1, %5 ], [ %12, %10 ]
  %17 = phi double [ 0.000000e+00, %5 ], [ %11, %10 ]
  %18 = getelementptr inbounds nuw %struct.body, ptr %0, i64 %15
  %19 = getelementptr inbounds nuw i8, ptr %18, i64 56
  %20 = load double, ptr %19, align 8, !tbaa !10
  %21 = getelementptr inbounds nuw i8, ptr %18, i64 32
  %22 = load double, ptr %21, align 8, !tbaa !6
  %23 = getelementptr inbounds nuw i8, ptr %18, i64 40
  %24 = load double, ptr %23, align 8, !tbaa !6
  %25 = fmul double %24, %24
  %26 = tail call double @llvm.fmuladd.f64(double %22, double %22, double %25)
  %27 = getelementptr inbounds nuw i8, ptr %18, i64 48
  %28 = load double, ptr %27, align 8, !tbaa !6
  %29 = tail call double @llvm.fmuladd.f64(double %28, double %28, double %26)
  %30 = fmul double %20, %29
  %31 = fmul double %30, 5.000000e-01
  %32 = fadd double %17, %31
  %33 = add nuw nsw i64 %15, 1
  %34 = icmp samesign ult i64 %33, %8
  br i1 %34, label %35, label %10

35:                                               ; preds = %14, %49
  %36 = phi i64 [ %62, %49 ], [ %16, %14 ]
  %37 = phi double [ %61, %49 ], [ %32, %14 ]
  %38 = getelementptr inbounds nuw %struct.body, ptr %0, i64 %36
  br label %39

39:                                               ; preds = %35, %39
  %40 = phi i64 [ 0, %35 ], [ %47, %39 ]
  %41 = getelementptr inbounds nuw [3 x double], ptr %18, i64 0, i64 %40
  %42 = load double, ptr %41, align 8, !tbaa !6
  %43 = getelementptr inbounds nuw [3 x double], ptr %38, i64 0, i64 %40
  %44 = load double, ptr %43, align 8, !tbaa !6
  %45 = fsub double %42, %44
  %46 = getelementptr inbounds nuw [3 x double], ptr %3, i64 0, i64 %40
  store double %45, ptr %46, align 8, !tbaa !6
  %47 = add nuw nsw i64 %40, 1
  %48 = icmp eq i64 %47, 3
  br i1 %48, label %49, label %39, !llvm.loop !17

49:                                               ; preds = %39
  %50 = load double, ptr %3, align 8, !tbaa !6
  %51 = load double, ptr %6, align 8, !tbaa !6
  %52 = fmul double %51, %51
  %53 = tail call double @llvm.fmuladd.f64(double %50, double %50, double %52)
  %54 = load double, ptr %7, align 8, !tbaa !6
  %55 = tail call double @llvm.fmuladd.f64(double %54, double %54, double %53)
  %56 = tail call double @llvm.sqrt.f64(double %55)
  %57 = getelementptr inbounds nuw %struct.body, ptr %0, i64 %36, i32 3
  %58 = load double, ptr %57, align 8, !tbaa !10
  %59 = fmul double %20, %58
  %60 = fdiv double %59, %56
  %61 = fsub double %37, %60
  %62 = add nuw nsw i64 %36, 1
  %63 = trunc i64 %62 to i32
  %64 = icmp eq i32 %1, %63
  br i1 %64, label %10, label %35, !llvm.loop !18

65:                                               ; preds = %10, %2
  %66 = phi double [ 0.000000e+00, %2 ], [ %11, %10 ]
  call void @llvm.lifetime.end.p0(i64 24, ptr nonnull %3) #9
  ret double %66
}

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #2

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare double @llvm.fmuladd.f64(double, double, double) #3

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare double @llvm.sqrt.f64(double) #3

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #2

; Function Attrs: mustprogress nofree norecurse nosync nounwind ssp willreturn memory(none) uwtable(sync)
define void @initialise_benchmark() local_unnamed_addr #4 {
  ret void
}

; Function Attrs: nofree norecurse nosync nounwind ssp memory(readwrite, inaccessiblemem: none) uwtable(sync)
define void @warm_caches(i32 noundef %0) local_unnamed_addr #5 {
  %2 = tail call fastcc i32 @benchmark_body(i32 noundef %0)
  ret void
}

; Function Attrs: nofree noinline norecurse nosync nounwind ssp memory(readwrite, argmem: none, inaccessiblemem: none) uwtable(sync)
define internal fastcc range(i32 0, 2) i32 @benchmark_body(i32 noundef %0) unnamed_addr #6 {
  %2 = alloca [3 x double], align 8
  %3 = icmp sgt i32 %0, 0
  br i1 %3, label %4, label %96

4:                                                ; preds = %1
  %5 = getelementptr inbounds nuw i8, ptr %2, i64 8
  %6 = getelementptr inbounds nuw i8, ptr %2, i64 16
  br label %7

7:                                                ; preds = %4, %91
  %8 = phi i32 [ 0, %4 ], [ %92, %91 ]
  br label %9

9:                                                ; preds = %7, %26
  %10 = phi i64 [ %27, %26 ], [ 0, %7 ]
  %11 = getelementptr inbounds nuw %struct.body, ptr @solar_bodies, i64 %10
  %12 = getelementptr inbounds nuw i8, ptr %11, i64 32
  %13 = getelementptr inbounds nuw i8, ptr %11, i64 56
  br label %14

14:                                               ; preds = %14, %9
  %15 = phi i64 [ 0, %9 ], [ %24, %14 ]
  %16 = getelementptr inbounds nuw [3 x double], ptr %12, i64 0, i64 %15
  %17 = load double, ptr %16, align 8, !tbaa !6
  %18 = load double, ptr %13, align 8, !tbaa !10
  %19 = fmul double %17, %18
  %20 = fdiv double %19, 0x4043BD3CC9BE45DE
  %21 = getelementptr inbounds nuw [3 x double], ptr getelementptr inbounds nuw (i8, ptr @solar_bodies, i64 32), i64 0, i64 %15
  %22 = load double, ptr %21, align 8, !tbaa !6
  %23 = fsub double %22, %20
  store double %23, ptr %21, align 8, !tbaa !6
  %24 = add nuw nsw i64 %15, 1
  %25 = icmp eq i64 %24, 3
  br i1 %25, label %26, label %14, !llvm.loop !12

26:                                               ; preds = %14
  %27 = add nuw nsw i64 %10, 1
  %28 = icmp eq i64 %27, 5
  br i1 %28, label %29, label %9, !llvm.loop !15

29:                                               ; preds = %26, %87
  %30 = phi i32 [ %89, %87 ], [ 0, %26 ]
  %31 = phi double [ %88, %87 ], [ 0.000000e+00, %26 ]
  call void @llvm.lifetime.start.p0(i64 24, ptr nonnull %2) #9
  br label %36

32:                                               ; preds = %71, %36
  %33 = phi double [ %54, %36 ], [ %83, %71 ]
  %34 = add nuw nsw i64 %38, 1
  %35 = icmp eq i64 %55, 5
  br i1 %35, label %87, label %36, !llvm.loop !16

36:                                               ; preds = %32, %29
  %37 = phi i64 [ 0, %29 ], [ %55, %32 ]
  %38 = phi i64 [ 1, %29 ], [ %34, %32 ]
  %39 = phi double [ 0.000000e+00, %29 ], [ %33, %32 ]
  %40 = getelementptr inbounds nuw %struct.body, ptr @solar_bodies, i64 %37
  %41 = getelementptr inbounds nuw i8, ptr %40, i64 56
  %42 = load double, ptr %41, align 8, !tbaa !10
  %43 = getelementptr inbounds nuw i8, ptr %40, i64 32
  %44 = load double, ptr %43, align 8, !tbaa !6
  %45 = getelementptr inbounds nuw i8, ptr %40, i64 40
  %46 = load double, ptr %45, align 8, !tbaa !6
  %47 = fmul double %46, %46
  %48 = tail call double @llvm.fmuladd.f64(double %44, double %44, double %47)
  %49 = getelementptr inbounds nuw i8, ptr %40, i64 48
  %50 = load double, ptr %49, align 8, !tbaa !6
  %51 = tail call double @llvm.fmuladd.f64(double %50, double %50, double %48)
  %52 = fmul double %42, %51
  %53 = fmul double %52, 5.000000e-01
  %54 = fadd double %39, %53
  %55 = add nuw nsw i64 %37, 1
  %56 = icmp samesign ult i64 %37, 4
  br i1 %56, label %57, label %32

57:                                               ; preds = %36, %71
  %58 = phi i64 [ %84, %71 ], [ %38, %36 ]
  %59 = phi double [ %83, %71 ], [ %54, %36 ]
  %60 = getelementptr inbounds nuw %struct.body, ptr @solar_bodies, i64 %58
  br label %61

61:                                               ; preds = %61, %57
  %62 = phi i64 [ 0, %57 ], [ %69, %61 ]
  %63 = getelementptr inbounds nuw [3 x double], ptr %40, i64 0, i64 %62
  %64 = load double, ptr %63, align 8, !tbaa !6
  %65 = getelementptr inbounds nuw [3 x double], ptr %60, i64 0, i64 %62
  %66 = load double, ptr %65, align 8, !tbaa !6
  %67 = fsub double %64, %66
  %68 = getelementptr inbounds nuw [3 x double], ptr %2, i64 0, i64 %62
  store double %67, ptr %68, align 8, !tbaa !6
  %69 = add nuw nsw i64 %62, 1
  %70 = icmp eq i64 %69, 3
  br i1 %70, label %71, label %61, !llvm.loop !17

71:                                               ; preds = %61
  %72 = load double, ptr %2, align 8, !tbaa !6
  %73 = load double, ptr %5, align 8, !tbaa !6
  %74 = fmul double %73, %73
  %75 = tail call double @llvm.fmuladd.f64(double %72, double %72, double %74)
  %76 = load double, ptr %6, align 8, !tbaa !6
  %77 = tail call double @llvm.fmuladd.f64(double %76, double %76, double %75)
  %78 = tail call double @llvm.sqrt.f64(double %77)
  %79 = getelementptr inbounds nuw %struct.body, ptr @solar_bodies, i64 %58, i32 3
  %80 = load double, ptr %79, align 8, !tbaa !10
  %81 = fmul double %42, %80
  %82 = fdiv double %81, %78
  %83 = fsub double %59, %82
  %84 = add nuw nsw i64 %58, 1
  %85 = and i64 %84, 4294967295
  %86 = icmp eq i64 %85, 5
  br i1 %86, label %32, label %57, !llvm.loop !18

87:                                               ; preds = %32
  call void @llvm.lifetime.end.p0(i64 24, ptr nonnull %2) #9
  %88 = fadd double %31, %33
  %89 = add nuw nsw i32 %30, 1
  %90 = icmp eq i32 %89, 100
  br i1 %90, label %91, label %29, !llvm.loop !19

91:                                               ; preds = %87
  %92 = add nuw nsw i32 %8, 1
  %93 = icmp eq i32 %92, %0
  br i1 %93, label %94, label %7, !llvm.loop !20

94:                                               ; preds = %91
  %95 = fadd double %88, 0x4030E852FE60EF84
  br label %96

96:                                               ; preds = %94, %1
  %97 = phi double [ 0x4030E852FE60EF84, %1 ], [ %95, %94 ]
  %98 = tail call double @llvm.fabs.f64(double %97)
  %99 = fcmp olt double %98, 1.000000e-13
  %100 = zext i1 %99 to i32
  ret i32 %100
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare double @llvm.fabs.f64(double) #3

; Function Attrs: nofree noinline norecurse nosync nounwind ssp memory(readwrite, inaccessiblemem: none) uwtable(sync)
define range(i32 0, 2) i32 @benchmark() local_unnamed_addr #7 {
  %1 = tail call fastcc i32 @benchmark_body(i32 noundef 1)
  ret i32 %1
}

; Function Attrs: nofree norecurse nosync nounwind ssp memory(read, argmem: none, inaccessiblemem: none) uwtable(sync)
define range(i32 0, 2) i32 @verify_benchmark(i32 noundef %0) local_unnamed_addr #8 {
  %2 = icmp eq i32 %0, 0
  br i1 %2, label %40, label %6

3:                                                ; preds = %32
  %4 = add nuw nsw i64 %7, 1
  %5 = icmp eq i64 %4, 5
  br i1 %5, label %40, label %6, !llvm.loop !21

6:                                                ; preds = %1, %3
  %7 = phi i64 [ %4, %3 ], [ 0, %1 ]
  %8 = getelementptr inbounds nuw [5 x %struct.body], ptr @solar_bodies, i64 0, i64 %7
  %9 = getelementptr inbounds nuw [5 x %struct.body], ptr @verify_benchmark.expected, i64 0, i64 %7
  %10 = getelementptr inbounds nuw i8, ptr %8, i64 32
  %11 = getelementptr inbounds nuw i8, ptr %9, i64 32
  br label %15

12:                                               ; preds = %24
  %13 = add nuw nsw i64 %16, 1
  %14 = icmp eq i64 %13, 3
  br i1 %14, label %32, label %15, !llvm.loop !22

15:                                               ; preds = %6, %12
  %16 = phi i64 [ 0, %6 ], [ %13, %12 ]
  %17 = getelementptr inbounds nuw [3 x double], ptr %8, i64 0, i64 %16
  %18 = load double, ptr %17, align 8, !tbaa !6
  %19 = getelementptr inbounds nuw [3 x double], ptr %9, i64 0, i64 %16
  %20 = load double, ptr %19, align 8, !tbaa !6
  %21 = fsub double %18, %20
  %22 = tail call double @llvm.fabs.f64(double %21)
  %23 = fcmp olt double %22, 1.000000e-13
  br i1 %23, label %24, label %40

24:                                               ; preds = %15
  %25 = getelementptr inbounds nuw [3 x double], ptr %10, i64 0, i64 %16
  %26 = load double, ptr %25, align 8, !tbaa !6
  %27 = getelementptr inbounds nuw [3 x double], ptr %11, i64 0, i64 %16
  %28 = load double, ptr %27, align 8, !tbaa !6
  %29 = fsub double %26, %28
  %30 = tail call double @llvm.fabs.f64(double %29)
  %31 = fcmp olt double %30, 1.000000e-13
  br i1 %31, label %12, label %40

32:                                               ; preds = %12
  %33 = getelementptr inbounds nuw [5 x %struct.body], ptr @solar_bodies, i64 0, i64 %7, i32 3
  %34 = load double, ptr %33, align 8, !tbaa !10
  %35 = getelementptr inbounds nuw [5 x %struct.body], ptr @verify_benchmark.expected, i64 0, i64 %7, i32 3
  %36 = load double, ptr %35, align 8, !tbaa !10
  %37 = fsub double %34, %36
  %38 = tail call double @llvm.fabs.f64(double %37)
  %39 = fcmp olt double %38, 1.000000e-13
  br i1 %39, label %3, label %40

40:                                               ; preds = %3, %32, %24, %15, %1
  %41 = phi i32 [ 0, %1 ], [ 0, %15 ], [ 0, %24 ], [ 0, %32 ], [ 1, %3 ]
  ret i32 %41
}

attributes #0 = { nofree norecurse nosync nounwind ssp memory(argmem: readwrite) uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" }
attributes #1 = { nofree norecurse nosync nounwind ssp memory(argmem: read) uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" }
attributes #2 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #3 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #4 = { mustprogress nofree norecurse nosync nounwind ssp willreturn memory(none) uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" }
attributes #5 = { nofree norecurse nosync nounwind ssp memory(readwrite, inaccessiblemem: none) uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" }
attributes #6 = { nofree noinline norecurse nosync nounwind ssp memory(readwrite, argmem: none, inaccessiblemem: none) uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" }
attributes #7 = { nofree noinline norecurse nosync nounwind ssp memory(readwrite, inaccessiblemem: none) uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" }
attributes #8 = { nofree norecurse nosync nounwind ssp memory(read, argmem: none, inaccessiblemem: none) uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" }
attributes #9 = { nounwind }

!llvm.ident = !{!0}
!llvm.module.flags = !{!1, !2, !3, !4, !5}

!0 = !{!"Homebrew clang version 21.1.2"}
!1 = !{i32 2, !"SDK Version", [2 x i32] [i32 15, i32 5]}
!2 = !{i32 1, !"wchar_size", i32 4}
!3 = !{i32 8, !"PIC Level", i32 2}
!4 = !{i32 7, !"uwtable", i32 1}
!5 = !{i32 7, !"frame-pointer", i32 1}
!6 = !{!7, !7, i64 0}
!7 = !{!"double", !8, i64 0}
!8 = !{!"omnipotent char", !9, i64 0}
!9 = !{!"Simple C/C++ TBAA"}
!10 = !{!11, !7, i64 56}
!11 = !{!"body", !8, i64 0, !7, i64 24, !8, i64 32, !7, i64 56}
!12 = distinct !{!12, !13, !14}
!13 = !{!"llvm.loop.mustprogress"}
!14 = !{!"llvm.loop.unroll.disable"}
!15 = distinct !{!15, !13, !14}
!16 = distinct !{!16, !13, !14}
!17 = distinct !{!17, !13, !14}
!18 = distinct !{!18, !13, !14}
!19 = distinct !{!19, !13, !14}
!20 = distinct !{!20, !13, !14}
!21 = distinct !{!21, !13, !14}
!22 = distinct !{!22, !13, !14}
