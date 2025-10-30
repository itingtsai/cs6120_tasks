; ModuleID = 'cubic.ll'
source_filename = "llvm-link"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

@soln_cnt0 = internal unnamed_addr global i32 0, align 4
@res0 = internal unnamed_addr global [3 x double] zeroinitializer, align 8
@soln_cnt1 = internal unnamed_addr global i32 0, align 4
@res1 = internal unnamed_addr global double 0.000000e+00, align 8

; Function Attrs: mustprogress nofree norecurse nosync nounwind ssp willreturn memory(read, argmem: none, inaccessiblemem: none) uwtable(sync)
define range(i32 0, 2) i32 @verify_benchmark(i32 noundef %0) local_unnamed_addr #0 {
  %2 = load i32, ptr @soln_cnt0, align 4, !tbaa !6
  %3 = icmp eq i32 %2, 3
  br i1 %3, label %4, label %28

4:                                                ; preds = %1
  %5 = load double, ptr @res0, align 8, !tbaa !10
  %6 = fsub double 2.000000e+00, %5
  %7 = tail call double @llvm.fabs.f64(double %6)
  %8 = fcmp olt double %7, 1.000000e-13
  br i1 %8, label %9, label %28

9:                                                ; preds = %4
  %10 = load double, ptr getelementptr inbounds nuw (i8, ptr @res0, i64 8), align 8, !tbaa !10
  %11 = fsub double 6.000000e+00, %10
  %12 = tail call double @llvm.fabs.f64(double %11)
  %13 = fcmp olt double %12, 1.000000e-13
  br i1 %13, label %14, label %28

14:                                               ; preds = %9
  %15 = load double, ptr getelementptr inbounds nuw (i8, ptr @res0, i64 16), align 8, !tbaa !10
  %16 = fsub double 2.500000e+00, %15
  %17 = tail call double @llvm.fabs.f64(double %16)
  %18 = fcmp olt double %17, 1.000000e-13
  %19 = load i32, ptr @soln_cnt1, align 4
  %20 = icmp eq i32 %19, 1
  %21 = select i1 %18, i1 %20, i1 false
  br i1 %21, label %22, label %28

22:                                               ; preds = %14
  %23 = load double, ptr @res1, align 8, !tbaa !10
  %24 = fsub double 2.500000e+00, %23
  %25 = tail call double @llvm.fabs.f64(double %24)
  %26 = fcmp olt double %25, 1.000000e-13
  %27 = zext i1 %26 to i32
  br label %28

28:                                               ; preds = %22, %14, %9, %4, %1
  %29 = phi i32 [ 0, %14 ], [ 0, %9 ], [ 0, %4 ], [ 0, %1 ], [ %27, %22 ]
  ret i32 %29
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare double @llvm.fabs.f64(double) #1

; Function Attrs: mustprogress nofree norecurse nosync nounwind ssp willreturn memory(none) uwtable(sync)
define void @initialise_benchmark() local_unnamed_addr #2 {
  ret void
}

; Function Attrs: nounwind ssp uwtable(sync)
define void @warm_caches(i32 noundef %0) local_unnamed_addr #3 {
  tail call fastcc void @benchmark_body(i32 noundef %0)
  ret void
}

; Function Attrs: nounwind ssp uwtable(sync)
define internal fastcc void @benchmark_body(i32 noundef %0) unnamed_addr #3 {
  %2 = alloca i32, align 4
  %3 = alloca [48 x double], align 8
  %4 = icmp sgt i32 %0, 0
  br i1 %4, label %.preheader, label %35

.preheader:                                       ; preds = %1
  %5 = load i32, ptr %2, align 4, !tbaa !6
  %6 = load i32, ptr %2, align 4, !tbaa !6
  %7 = load double, ptr %3, align 8, !tbaa !10
  br label %8

8:                                                ; preds = %.preheader, %32
  %9 = phi i32 [ %33, %32 ], [ 0, %.preheader ]
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %2) #9
  call void @llvm.lifetime.start.p0(i64 384, ptr nonnull %3) #9
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(384) %3, i8 0, i64 384, i1 false)
  call void @SolveCubic(double noundef 1.000000e+00, double noundef -1.050000e+01, double noundef 3.200000e+01, double noundef -3.000000e+01, ptr noundef nonnull %2, ptr noundef nonnull %3) #9
  store i32 %5, ptr @soln_cnt0, align 4, !tbaa !6
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) @res0, ptr noundef nonnull align 8 dereferenceable(24) %3, i64 24, i1 false)
  call void @SolveCubic(double noundef 1.000000e+00, double noundef -4.500000e+00, double noundef 1.700000e+01, double noundef -3.000000e+01, ptr noundef nonnull %2, ptr noundef nonnull %3) #9
  store i32 %6, ptr @soln_cnt1, align 4, !tbaa !6
  store double %7, ptr @res1, align 8, !tbaa !10
  call void @SolveCubic(double noundef 1.000000e+00, double noundef -3.500000e+00, double noundef 2.200000e+01, double noundef -3.100000e+01, ptr noundef nonnull %2, ptr noundef nonnull %3) #9
  call void @SolveCubic(double noundef 1.000000e+00, double noundef -1.370000e+01, double noundef 1.000000e+00, double noundef -3.500000e+01, ptr noundef nonnull %2, ptr noundef nonnull %3) #9
  br label %10

10:                                               ; preds = %29, %8
  %11 = phi i32 [ 1, %8 ], [ %30, %29 ]
  %12 = uitofp nneg i32 %11 to double
  br label %13

13:                                               ; preds = %26, %10
  %14 = phi i32 [ 10, %10 ], [ %27, %26 ]
  %15 = sitofp i32 %14 to double
  br label %16

16:                                               ; preds = %23, %13
  %17 = phi double [ 5.000000e+00, %13 ], [ %24, %23 ]
  br label %18

18:                                               ; preds = %18, %16
  %19 = phi i32 [ -1, %16 ], [ %21, %18 ]
  %20 = sitofp i32 %19 to double
  call void @SolveCubic(double noundef %12, double noundef %15, double noundef %17, double noundef %20, ptr noundef nonnull %2, ptr noundef nonnull %3) #9
  %21 = add nsw i32 %19, -1
  %22 = icmp samesign ugt i32 %21, -3
  br i1 %22, label %18, label %23, !llvm.loop !12

23:                                               ; preds = %18
  %24 = fadd double %17, 5.000000e-01
  %25 = fcmp olt double %24, 6.000000e+00
  br i1 %25, label %16, label %26, !llvm.loop !15

26:                                               ; preds = %23
  %27 = add nsw i32 %14, -1
  %28 = icmp samesign ugt i32 %27, 8
  br i1 %28, label %13, label %29, !llvm.loop !16

29:                                               ; preds = %26
  %30 = add nuw nsw i32 %11, 1
  %31 = icmp eq i32 %30, 3
  br i1 %31, label %32, label %10, !llvm.loop !17

32:                                               ; preds = %29
  call void @llvm.lifetime.end.p0(i64 384, ptr nonnull %3) #9
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %2) #9
  %33 = add nuw nsw i32 %9, 1
  %34 = icmp eq i32 %33, %0
  br i1 %34, label %.loopexit, label %8, !llvm.loop !18

.loopexit:                                        ; preds = %32
  br label %35

35:                                               ; preds = %.loopexit, %1
  ret void
}

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #4

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr writeonly captures(none), i8, i64, i1 immarg) #5

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i64(ptr noalias writeonly captures(none), ptr noalias readonly captures(none), i64, i1 immarg) #6

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #4

; Function Attrs: noinline nounwind ssp uwtable(sync)
define noundef i32 @benchmark() local_unnamed_addr #7 {
  tail call fastcc void @benchmark_body(i32 noundef 10)
  ret i32 0
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind ssp willreturn memory(argmem: write) uwtable(sync)
define void @SolveCubic(double noundef %0, double noundef %1, double noundef %2, double noundef %3, ptr noundef writeonly captures(none) initializes((0, 4)) %4, ptr noundef writeonly captures(none) initializes((0, 8)) %5) local_unnamed_addr #8 {
  %7 = fdiv double %1, %0
  %8 = fdiv double %2, %0
  %9 = fdiv double %3, %0
  %10 = fmul double %8, -3.000000e+00
  %11 = tail call double @llvm.fmuladd.f64(double %7, double %7, double %10)
  %12 = fdiv double %11, 9.000000e+00
  %13 = fmul double %7, 2.000000e+00
  %14 = fmul double %7, %13
  %15 = fmul double %7, 9.000000e+00
  %16 = fneg double %8
  %17 = fmul double %15, %16
  %18 = tail call double @llvm.fmuladd.f64(double %14, double %7, double %17)
  %19 = tail call double @llvm.fmuladd.f64(double %9, double 2.700000e+01, double %18)
  %20 = fdiv double %19, 5.400000e+01
  %21 = fmul double %12, %12
  %22 = fmul double %12, %21
  %23 = fneg double %22
  %24 = tail call double @llvm.fmuladd.f64(double %20, double %20, double %23)
  %25 = fcmp ugt double %24, 0.000000e+00
  br i1 %25, label %46, label %26

26:                                               ; preds = %6
  store i32 3, ptr %4, align 4, !tbaa !6
  %27 = tail call double @llvm.sqrt.f64(double %22)
  %28 = fdiv double %20, %27
  %29 = tail call double @llvm.acos.f64(double %28)
  %30 = tail call double @llvm.sqrt.f64(double %12)
  %31 = fmul double %30, -2.000000e+00
  %32 = fdiv double %29, 3.000000e+00
  %33 = tail call double @llvm.cos.f64(double %32)
  %34 = fdiv double %7, -3.000000e+00
  %35 = tail call double @llvm.fmuladd.f64(double %31, double %33, double %34)
  store double %35, ptr %5, align 8, !tbaa !10
  %36 = fadd double %29, 0x401921FB54442D18
  %37 = fdiv double %36, 3.000000e+00
  %38 = tail call double @llvm.cos.f64(double %37)
  %39 = tail call double @llvm.fmuladd.f64(double %31, double %38, double %34)
  %40 = getelementptr inbounds nuw i8, ptr %5, i64 8
  store double %39, ptr %40, align 8, !tbaa !10
  %41 = fadd double %29, 0x402921FB54442D18
  %42 = fdiv double %41, 3.000000e+00
  %43 = tail call double @llvm.cos.f64(double %42)
  %44 = tail call double @llvm.fmuladd.f64(double %31, double %43, double %34)
  %45 = getelementptr inbounds nuw i8, ptr %5, i64 16
  store double %44, ptr %45, align 8, !tbaa !10
  br label %58

46:                                               ; preds = %6
  store i32 1, ptr %4, align 4, !tbaa !6
  %47 = tail call double @llvm.sqrt.f64(double %24)
  %48 = tail call double @llvm.fabs.f64(double %20)
  %49 = fadd double %48, %47
  %50 = tail call double @llvm.pow.f64(double %49, double 0x3FD5555555555555)
  %51 = fdiv double %12, %50
  %52 = fadd double %50, %51
  %53 = fcmp olt double %20, 0.000000e+00
  %54 = fneg double %52
  %55 = select i1 %53, double %52, double %54
  %56 = fdiv double %7, 3.000000e+00
  %57 = fsub double %55, %56
  store double %57, ptr %5, align 8, !tbaa !10
  br label %58

58:                                               ; preds = %46, %26
  ret void
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare double @llvm.fmuladd.f64(double, double, double) #1

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare double @llvm.sqrt.f64(double) #1

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare double @llvm.acos.f64(double) #1

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare double @llvm.cos.f64(double) #1

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare double @llvm.pow.f64(double, double) #1

attributes #0 = { mustprogress nofree norecurse nosync nounwind ssp willreturn memory(read, argmem: none, inaccessiblemem: none) uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" }
attributes #1 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #2 = { mustprogress nofree norecurse nosync nounwind ssp willreturn memory(none) uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" }
attributes #3 = { nounwind ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" }
attributes #4 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #5 = { nocallback nofree nounwind willreturn memory(argmem: write) }
attributes #6 = { nocallback nofree nounwind willreturn memory(argmem: readwrite) }
attributes #7 = { noinline nounwind ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" }
attributes #8 = { mustprogress nofree norecurse nosync nounwind ssp willreturn memory(argmem: write) uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" }
attributes #9 = { nounwind }

!llvm.ident = !{!0, !0}
!llvm.module.flags = !{!1, !2, !3, !4, !5}

!0 = !{!"Homebrew clang version 21.1.2"}
!1 = !{i32 2, !"SDK Version", [2 x i32] [i32 15, i32 5]}
!2 = !{i32 1, !"wchar_size", i32 4}
!3 = !{i32 8, !"PIC Level", i32 2}
!4 = !{i32 7, !"uwtable", i32 1}
!5 = !{i32 7, !"frame-pointer", i32 1}
!6 = !{!7, !7, i64 0}
!7 = !{!"int", !8, i64 0}
!8 = !{!"omnipotent char", !9, i64 0}
!9 = !{!"Simple C/C++ TBAA"}
!10 = !{!11, !11, i64 0}
!11 = !{!"double", !8, i64 0}
!12 = distinct !{!12, !13, !14}
!13 = !{!"llvm.loop.mustprogress"}
!14 = !{!"llvm.loop.unroll.disable"}
!15 = distinct !{!15, !13, !14}
!16 = distinct !{!16, !13, !14}
!17 = distinct !{!17, !13, !14}
!18 = distinct !{!18, !13, !14}
