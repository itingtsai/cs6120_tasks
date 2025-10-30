; ModuleID = 'matmult-int.bc'
source_filename = "llvm-link"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

@Seed = local_unnamed_addr global i32 0, align 4
@ArrayA_ref = local_unnamed_addr global [20 x [20 x i64]] zeroinitializer, align 8
@ArrayB_ref = local_unnamed_addr global [20 x [20 x i64]] zeroinitializer, align 8
@__const.verify_benchmark.exp = private unnamed_addr constant [20 x [20 x i64]] [[20 x i64] [i64 291018000, i64 315000075, i64 279049970, i64 205074215, i64 382719905, i64 302595865, i64 348060915, i64 308986330, i64 343160760, i64 307099935, i64 292564810, i64 240954510, i64 232755815, i64 246511665, i64 328466830, i64 263664375, i64 324016395, i64 334656070, i64 285978755, i64 345370360], [20 x i64] [i64 252241835, i64 333432715, i64 299220275, i64 247745815, i64 422508990, i64 316728505, i64 359662270, i64 277775280, i64 323336795, i64 320656600, i64 249903690, i64 251499360, i64 242195700, i64 263484280, i64 348207635, i64 289485100, i64 328607555, i64 300799835, i64 269351410, i64 305703460], [20 x i64] [i64 304901010, i64 316252815, i64 263230275, i64 208939015, i64 421993740, i64 335002930, i64 348571170, i64 280992155, i64 289749970, i64 259701175, i64 295249990, i64 310900035, i64 250896625, i64 250154105, i64 315096035, i64 236364800, i64 312879355, i64 312580685, i64 275998435, i64 344137885], [20 x i64] [i64 286700525, i64 325985600, i64 253054970, i64 224361490, i64 353502130, i64 306544290, i64 323492140, i64 259123905, i64 307731610, i64 282414410, i64 281127810, i64 246936935, i64 207890815, i64 233789540, i64 339836730, i64 277296350, i64 319925620, i64 307470895, i64 290537580, i64 292297535], [20 x i64] [i64 272571255, i64 377663320, i64 304545985, i64 263001340, i64 375034885, i64 325423710, i64 410620380, i64 313191730, i64 356989815, i64 308508355, i64 218003850, i64 272487135, i64 266000220, i64 264734710, i64 367539620, i64 304146675, i64 355295500, i64 276019740, i64 251415695, i64 301225235], [20 x i64] [i64 272547900, i64 321522300, i64 288294345, i64 247748015, i64 389912855, i64 331874890, i64 370798315, i64 315467255, i64 367554485, i64 311947660, i64 258809685, i64 270536510, i64 256730515, i64 287143040, i64 363087030, i64 285672775, i64 353670120, i64 304219695, i64 274897255, i64 324684660], [20 x i64] [i64 233123995, i64 227142480, i64 212655155, i64 198592290, i64 345335250, i64 302661845, i64 253374925, i64 233243305, i64 233750030, i64 224590040, i64 200404820, i64 250791135, i64 234405760, i64 211723645, i64 280630165, i64 185245875, i64 296423665, i64 276278575, i64 252368265, i64 278726535], [20 x i64] [i64 277690535, i64 339615440, i64 320921550, i64 307114315, i64 400187215, i64 334374655, i64 376286920, i64 295993530, i64 362988020, i64 356272700, i64 293965465, i64 261574710, i64 259690975, i64 263037705, i64 416748985, i64 274683275, i64 385571030, i64 402782385, i64 323927010, i64 362778710], [20 x i64] [i64 267168970, i64 323401680, i64 279474330, i64 201934365, i64 362624300, i64 330736145, i64 371793675, i64 299650280, i64 333646005, i64 264791490, i64 215918320, i64 277512760, i64 264068435, i64 234555295, i64 321772515, i64 217507025, i64 310372440, i64 317544750, i64 245525965, i64 343183435], [20 x i64] [i64 281293570, i64 326519505, i64 233494705, i64 238516065, i64 297038200, i64 266273420, i64 349521550, i64 259343530, i64 306032255, i64 266397915, i64 210274920, i64 263743085, i64 231689610, i64 251949545, i64 293562740, i64 226822900, i64 309225440, i64 286212000, i64 206108715, i64 236678985], [20 x i64] [i64 288404350, i64 310319375, i64 282695670, i64 244150740, i64 426489380, i64 387525790, i64 342018190, i64 326086505, i64 352250260, i64 319997735, i64 300645835, i64 284822660, i64 271837440, i64 274000415, i64 361826730, i64 252399600, i64 348582320, i64 375813820, i64 316588255, i64 322499110], [20 x i64] [i64 273368780, i64 329706295, i64 288668335, i64 234501665, i64 381962610, i64 343186285, i64 337520205, i64 259637405, i64 295755465, i64 284778105, i64 205310525, i64 249598310, i64 256662470, i64 251533535, i64 336159770, i64 249342150, i64 333559450, i64 329296590, i64 278254845, i64 300673860], [20 x i64] [i64 318589575, i64 315522800, i64 260632295, i64 250009765, i64 337127730, i64 312810490, i64 346698590, i64 260810030, i64 388289910, i64 337081285, i64 283635410, i64 208148610, i64 234123865, i64 259653165, i64 370115255, i64 243311450, i64 377808245, i64 358786770, i64 286839730, i64 321912835], [20 x i64] [i64 229541925, i64 253967450, i64 223002545, i64 202302515, i64 303446955, i64 268472740, i64 285580065, i64 211013405, i64 287677960, i64 279773910, i64 227377310, i64 197461135, i64 222469715, i64 179536615, i64 306957380, i64 178407075, i64 281051570, i64 279718120, i64 234868230, i64 288991535], [20 x i64] [i64 290692955, i64 317729070, i64 297868235, i64 213450065, i64 469270935, i64 375344910, i64 326987580, i64 334565680, i64 325300040, i64 290325655, i64 254703825, i64 284914960, i64 245773820, i64 276641510, i64 323510795, i64 271034400, i64 337424250, i64 360011440, i64 281515520, i64 331261535], [20 x i64] [i64 287075125, i64 313194850, i64 269889345, i64 208109115, i64 420653930, i64 331900290, i64 355440665, i64 318065155, i64 343785360, i64 302163035, i64 308959360, i64 312666110, i64 268997740, i64 288557415, i64 370158305, i64 205012650, i64 318198795, i64 384484520, i64 316450105, i64 378714460], [20 x i64] [i64 278680580, i64 356815220, i64 307597060, i64 216073365, i64 390879235, i64 358775185, i64 358895230, i64 306434180, i64 315569040, i64 272688130, i64 249424325, i64 274584610, i64 273530970, i64 265450585, i64 325127920, i64 312802050, i64 317134900, i64 298518590, i64 269975470, i64 332586535], [20 x i64] [i64 245629780, i64 267021570, i64 234689035, i64 208808065, i64 366356035, i64 267059560, i64 349348005, i64 270158755, i64 348048340, i64 291550930, i64 272717800, i64 259714410, i64 236033845, i64 280627610, i64 335089770, i64 176610475, i64 259339950, i64 322752840, i64 236218295, i64 329687310], [20 x i64] [i64 226517370, i64 272306005, i64 271484080, i64 216145515, i64 400972075, i64 288475645, i64 332969550, i64 338410905, i64 329052205, i64 330392265, i64 306488095, i64 271979085, i64 232795960, i64 257593945, i64 339558165, i64 202700275, i64 320622065, i64 386350450, i64 315344865, i64 329233410], [20 x i64] [i64 224852610, i64 231292540, i64 236945875, i64 243273740, i64 336327040, i64 305144680, i64 248261920, i64 191671605, i64 241699245, i64 263085200, i64 198883715, i64 175742885, i64 202517850, i64 172427630, i64 296304160, i64 209188850, i64 326546955, i64 252990460, i64 238844535, i64 289753485]], align 8
@ResultArray = global [20 x [20 x i64]] zeroinitializer, align 8
@ArrayA = local_unnamed_addr global [20 x [20 x i64]] zeroinitializer, align 8
@ArrayB = local_unnamed_addr global [20 x [20 x i64]] zeroinitializer, align 8

; Function Attrs: mustprogress nofree norecurse nosync nounwind ssp willreturn memory(none) uwtable(sync)
define range(i32 0, 2) i32 @values_match(i64 noundef %0, i64 noundef %1) local_unnamed_addr #0 {
  %3 = icmp eq i64 %0, %1
  %4 = zext i1 %3 to i32
  ret i32 %4
}

; Function Attrs: nofree norecurse nosync nounwind ssp memory(readwrite, inaccessiblemem: none) uwtable(sync)
define void @warm_caches(i32 noundef %0) local_unnamed_addr #1 {
  tail call fastcc void @benchmark_body(i32 noundef %0)
  ret void
}

; Function Attrs: nofree noinline norecurse nosync nounwind ssp memory(readwrite, argmem: none, inaccessiblemem: none) uwtable(sync)
define internal fastcc void @benchmark_body(i32 noundef %0) unnamed_addr #2 {
  %2 = icmp sgt i32 %0, 0
  br i1 %2, label %3, label %30

3:                                                ; preds = %1, %27
  %4 = phi i32 [ %28, %27 ], [ 0, %1 ]
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(3200) @ArrayA, ptr noundef nonnull align 8 dereferenceable(3200) @ArrayA_ref, i64 3200, i1 false)
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(3200) @ArrayB, ptr noundef nonnull align 8 dereferenceable(3200) @ArrayB_ref, i64 3200, i1 false)
  br label %5

5:                                                ; preds = %24, %3
  %6 = phi i64 [ 0, %3 ], [ %25, %24 ]
  br label %7

7:                                                ; preds = %21, %5
  %8 = phi i64 [ 0, %5 ], [ %22, %21 ]
  %9 = getelementptr inbounds nuw [20 x i64], ptr @ResultArray, i64 %6, i64 %8
  store i64 0, ptr %9, align 8, !tbaa !6
  br label %10

10:                                               ; preds = %10, %7
  %11 = phi i64 [ 0, %7 ], [ %19, %10 ]
  %12 = phi i64 [ 0, %7 ], [ %18, %10 ]
  %13 = getelementptr inbounds nuw [20 x i64], ptr @ArrayA, i64 %6, i64 %11
  %14 = load i64, ptr %13, align 8, !tbaa !6
  %15 = getelementptr inbounds nuw [20 x i64], ptr @ArrayB, i64 %11, i64 %8
  %16 = load i64, ptr %15, align 8, !tbaa !6
  %17 = mul nsw i64 %16, %14
  %18 = add nsw i64 %17, %12
  %19 = add nuw nsw i64 %11, 1
  %20 = icmp eq i64 %19, 20
  br i1 %20, label %21, label %10, !llvm.loop !10

21:                                               ; preds = %10
  store i64 %18, ptr %9, align 8, !tbaa !6
  %22 = add nuw nsw i64 %8, 1
  %23 = icmp eq i64 %22, 20
  br i1 %23, label %24, label %7, !llvm.loop !13

24:                                               ; preds = %21
  %25 = add nuw nsw i64 %6, 1
  %26 = icmp eq i64 %25, 20
  br i1 %26, label %27, label %5, !llvm.loop !14

27:                                               ; preds = %24
  %28 = add nuw nsw i32 %4, 1
  %29 = icmp eq i32 %28, %0
  br i1 %29, label %30, label %3, !llvm.loop !15

30:                                               ; preds = %27, %1
  ret void
}

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i64(ptr noalias writeonly captures(none), ptr noalias readonly captures(none), i64, i1 immarg) #3

; Function Attrs: nofree noinline norecurse nosync nounwind ssp memory(readwrite, inaccessiblemem: none) uwtable(sync)
define noundef i32 @benchmark() local_unnamed_addr #4 {
  tail call fastcc void @benchmark_body(i32 noundef 46)
  ret i32 0
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind ssp willreturn memory(write, argmem: none, inaccessiblemem: none) uwtable(sync)
define void @InitSeed() local_unnamed_addr #5 {
  store i32 0, ptr @Seed, align 4, !tbaa !16
  ret void
}

; Function Attrs: nofree norecurse nosync nounwind ssp memory(argmem: readwrite) uwtable(sync)
define void @Test(ptr noundef readonly captures(none) %0, ptr noundef readonly captures(none) %1, ptr noundef writeonly captures(none) %2) local_unnamed_addr #6 {
  br label %4

4:                                                ; preds = %23, %3
  %5 = phi i64 [ 0, %3 ], [ %24, %23 ]
  br label %6

6:                                                ; preds = %20, %4
  %7 = phi i64 [ 0, %4 ], [ %21, %20 ]
  %8 = getelementptr inbounds nuw [20 x i64], ptr %2, i64 %5, i64 %7
  store i64 0, ptr %8, align 8, !tbaa !6
  br label %9

9:                                                ; preds = %9, %6
  %10 = phi i64 [ 0, %6 ], [ %18, %9 ]
  %11 = phi i64 [ 0, %6 ], [ %17, %9 ]
  %12 = getelementptr inbounds nuw [20 x i64], ptr %0, i64 %5, i64 %10
  %13 = load i64, ptr %12, align 8, !tbaa !6
  %14 = getelementptr inbounds nuw [20 x i64], ptr %1, i64 %10, i64 %7
  %15 = load i64, ptr %14, align 8, !tbaa !6
  %16 = mul nsw i64 %15, %13
  %17 = add nsw i64 %16, %11
  store i64 %17, ptr %8, align 8, !tbaa !6
  %18 = add nuw nsw i64 %10, 1
  %19 = icmp eq i64 %18, 20
  br i1 %19, label %20, label %9, !llvm.loop !10

20:                                               ; preds = %9
  %21 = add nuw nsw i64 %7, 1
  %22 = icmp eq i64 %21, 20
  br i1 %22, label %23, label %6, !llvm.loop !13

23:                                               ; preds = %20
  %24 = add nuw nsw i64 %5, 1
  %25 = icmp eq i64 %24, 20
  br i1 %25, label %26, label %4, !llvm.loop !14

26:                                               ; preds = %23
  ret void
}

; Function Attrs: nofree norecurse nosync nounwind ssp memory(argmem: readwrite) uwtable(sync)
define void @Multiply(ptr noundef readonly captures(none) %0, ptr noundef readonly captures(none) %1, ptr noundef writeonly captures(none) %2) local_unnamed_addr #6 {
  br label %4

4:                                                ; preds = %3, %23
  %5 = phi i64 [ 0, %3 ], [ %24, %23 ]
  br label %6

6:                                                ; preds = %4, %20
  %7 = phi i64 [ 0, %4 ], [ %21, %20 ]
  %8 = getelementptr inbounds nuw [20 x i64], ptr %2, i64 %5, i64 %7
  store i64 0, ptr %8, align 8, !tbaa !6
  br label %9

9:                                                ; preds = %6, %9
  %10 = phi i64 [ 0, %6 ], [ %18, %9 ]
  %11 = phi i64 [ 0, %6 ], [ %17, %9 ]
  %12 = getelementptr inbounds nuw [20 x i64], ptr %0, i64 %5, i64 %10
  %13 = load i64, ptr %12, align 8, !tbaa !6
  %14 = getelementptr inbounds nuw [20 x i64], ptr %1, i64 %10, i64 %7
  %15 = load i64, ptr %14, align 8, !tbaa !6
  %16 = mul nsw i64 %15, %13
  %17 = add nsw i64 %11, %16
  store i64 %17, ptr %8, align 8, !tbaa !6
  %18 = add nuw nsw i64 %10, 1
  %19 = icmp eq i64 %18, 20
  br i1 %19, label %20, label %9, !llvm.loop !10

20:                                               ; preds = %9
  %21 = add nuw nsw i64 %7, 1
  %22 = icmp eq i64 %21, 20
  br i1 %22, label %23, label %6, !llvm.loop !13

23:                                               ; preds = %20
  %24 = add nuw nsw i64 %5, 1
  %25 = icmp eq i64 %24, 20
  br i1 %25, label %26, label %4, !llvm.loop !14

26:                                               ; preds = %23
  ret void
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind ssp willreturn memory(readwrite, argmem: none, inaccessiblemem: none) uwtable(sync)
define range(i32 -8094, 8095) i32 @RandomInteger() local_unnamed_addr #7 {
  %1 = load i32, ptr @Seed, align 4, !tbaa !16
  %2 = mul nsw i32 %1, 133
  %3 = add nsw i32 %2, 81
  %4 = srem i32 %3, 8095
  store i32 %4, ptr @Seed, align 4, !tbaa !16
  ret i32 %4
}

; Function Attrs: nofree norecurse nosync nounwind ssp memory(write, argmem: none, inaccessiblemem: none) uwtable(sync)
define void @initialise_benchmark() local_unnamed_addr #8 {
  store i32 0, ptr @Seed, align 4, !tbaa !16
  br label %1

1:                                                ; preds = %0, %15
  %2 = phi i64 [ 0, %0 ], [ %16, %15 ]
  %3 = phi i32 [ 0, %0 ], [ %10, %15 ]
  br label %5

4:                                                ; preds = %15
  store i32 %10, ptr @Seed, align 4, !tbaa !16
  br label %18

5:                                                ; preds = %1, %5
  %6 = phi i64 [ 0, %1 ], [ %13, %5 ]
  %7 = phi i32 [ %3, %1 ], [ %10, %5 ]
  %8 = mul nuw nsw i32 %7, 133
  %9 = add nuw nsw i32 %8, 81
  %10 = urem i32 %9, 8095
  %11 = zext nneg i32 %10 to i64
  %12 = getelementptr inbounds nuw [20 x [20 x i64]], ptr @ArrayA_ref, i64 0, i64 %2, i64 %6
  store i64 %11, ptr %12, align 8, !tbaa !6
  %13 = add nuw nsw i64 %6, 1
  %14 = icmp eq i64 %13, 20
  br i1 %14, label %15, label %5, !llvm.loop !18

15:                                               ; preds = %5
  %16 = add nuw nsw i64 %2, 1
  %17 = icmp eq i64 %16, 20
  br i1 %17, label %4, label %1, !llvm.loop !19

18:                                               ; preds = %4, %31
  %19 = phi i64 [ 0, %4 ], [ %32, %31 ]
  %20 = phi i32 [ %10, %4 ], [ %26, %31 ]
  br label %21

21:                                               ; preds = %18, %21
  %22 = phi i64 [ 0, %18 ], [ %29, %21 ]
  %23 = phi i32 [ %20, %18 ], [ %26, %21 ]
  %24 = mul nuw nsw i32 %23, 133
  %25 = add nuw nsw i32 %24, 81
  %26 = urem i32 %25, 8095
  %27 = zext nneg i32 %26 to i64
  %28 = getelementptr inbounds nuw [20 x [20 x i64]], ptr @ArrayB_ref, i64 0, i64 %19, i64 %22
  store i64 %27, ptr %28, align 8, !tbaa !6
  %29 = add nuw nsw i64 %22, 1
  %30 = icmp eq i64 %29, 20
  br i1 %30, label %31, label %21, !llvm.loop !20

31:                                               ; preds = %21
  %32 = add nuw nsw i64 %19, 1
  %33 = icmp eq i64 %32, 20
  br i1 %33, label %34, label %18, !llvm.loop !21

34:                                               ; preds = %31
  store i32 %26, ptr @Seed, align 4, !tbaa !16
  ret void
}

; Function Attrs: mustprogress nofree norecurse nounwind ssp willreturn memory(read, argmem: none, inaccessiblemem: none) uwtable(sync)
define range(i32 0, 2) i32 @verify_benchmark(i32 noundef %0) local_unnamed_addr #9 {
  %2 = tail call i32 @memcmp(ptr noundef nonnull dereferenceable(3200) @ResultArray, ptr noundef nonnull dereferenceable(3200) @__const.verify_benchmark.exp, i64 noundef 3200)
  %3 = icmp eq i32 %2, 0
  %4 = zext i1 %3 to i32
  ret i32 %4
}

; Function Attrs: mustprogress nofree nounwind willreturn memory(argmem: read)
declare i32 @memcmp(ptr noundef captures(none), ptr noundef captures(none), i64 noundef) local_unnamed_addr #10

attributes #0 = { mustprogress nofree norecurse nosync nounwind ssp willreturn memory(none) uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" }
attributes #1 = { nofree norecurse nosync nounwind ssp memory(readwrite, inaccessiblemem: none) uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" }
attributes #2 = { nofree noinline norecurse nosync nounwind ssp memory(readwrite, argmem: none, inaccessiblemem: none) uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" }
attributes #3 = { nocallback nofree nounwind willreturn memory(argmem: readwrite) }
attributes #4 = { nofree noinline norecurse nosync nounwind ssp memory(readwrite, inaccessiblemem: none) uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" }
attributes #5 = { mustprogress nofree norecurse nosync nounwind ssp willreturn memory(write, argmem: none, inaccessiblemem: none) uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" }
attributes #6 = { nofree norecurse nosync nounwind ssp memory(argmem: readwrite) uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" }
attributes #7 = { mustprogress nofree norecurse nosync nounwind ssp willreturn memory(readwrite, argmem: none, inaccessiblemem: none) uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" }
attributes #8 = { nofree norecurse nosync nounwind ssp memory(write, argmem: none, inaccessiblemem: none) uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" }
attributes #9 = { mustprogress nofree norecurse nounwind ssp willreturn memory(read, argmem: none, inaccessiblemem: none) uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" }
attributes #10 = { mustprogress nofree nounwind willreturn memory(argmem: read) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" }

!llvm.ident = !{!0}
!llvm.module.flags = !{!1, !2, !3, !4, !5}

!0 = !{!"Homebrew clang version 21.1.2"}
!1 = !{i32 2, !"SDK Version", [2 x i32] [i32 15, i32 5]}
!2 = !{i32 1, !"wchar_size", i32 4}
!3 = !{i32 8, !"PIC Level", i32 2}
!4 = !{i32 7, !"uwtable", i32 1}
!5 = !{i32 7, !"frame-pointer", i32 1}
!6 = !{!7, !7, i64 0}
!7 = !{!"long", !8, i64 0}
!8 = !{!"omnipotent char", !9, i64 0}
!9 = !{!"Simple C/C++ TBAA"}
!10 = distinct !{!10, !11, !12}
!11 = !{!"llvm.loop.mustprogress"}
!12 = !{!"llvm.loop.unroll.disable"}
!13 = distinct !{!13, !11, !12}
!14 = distinct !{!14, !11, !12}
!15 = distinct !{!15, !11, !12}
!16 = !{!17, !17, i64 0}
!17 = !{!"int", !8, i64 0}
!18 = distinct !{!18, !11, !12}
!19 = distinct !{!19, !11, !12}
!20 = distinct !{!20, !11, !12}
!21 = distinct !{!21, !11, !12}
