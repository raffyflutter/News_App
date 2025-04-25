// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';
// import 'package:news_app/repository/news_repository.dart';
// import 'package:news_app/view_model/news_model.dart';

// import '../constant/pakistan_news_channel.dart';
// import '../controller/new_view_model_controller.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   void initState() {
//     super.initState();
//     newsViewModel.fetchNewsData();
//   }

//   final NewsViewModelController newsViewModelController =
//       Get.put(NewsViewModelController());

//   final NewsViewModel newsViewModel = NewsViewModel();
//   final NewsRepository newsController = NewsRepository();

//   @override
//   Widget build(BuildContext context) {
//     final format = DateFormat('yyyy-MM-dd');
//     return Scaffold(
//         appBar: AppBar(
//           actions: [
//             PopupMenuButton<PakistaniNewsChannel>(
//               onSelected: (PakistaniNewsChannel selectedChannel) {
//                 newsController.fetchNewsFromChannel(selectedChannel);
//                 print('selectedChannel:${selectedChannel}');
//               },
//               itemBuilder: (BuildContext context) {
//                 return PakistaniNewsChannel.values
//                     .map((PakistaniNewsChannel channel) {
//                   return PopupMenuItem<PakistaniNewsChannel>(
//                     value: channel,
//                     child: Text(channel.displayName),
//                   );
//                 }).toList();
//               },
//             ),
//           ],
//           leading: Icon(Icons.filter_alt_outlined),
//           automaticallyImplyLeading: false,
//           centerTitle: true,
//           title: Text('HeadLines',
//               style: GoogleFonts.poppins(
//                   fontSize: 18, fontWeight: FontWeight.bold)),
//         ),
//         body: Obx(() {
//           if (newsController.isLoading.value) {
//             return Center(
//               child: SpinKitCircle(size: 50.r, color: Colors.amber),
//             );
//           }

//           if (newsController.articlesList.isEmpty) {
//             return Center(child: Text('No articles found.'));
//           }

//           return SizedBox(
//             height: 250.h,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               itemCount: newsController.articlesList.length,
//               itemBuilder: (context, index) {
//                 final article = newsController.articlesList[index];
//                 return Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 10.w),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       InkWell(
//                         onTap: () {
//                           newsViewModelController
//                               .launchArticle(article.url ?? '');
//                         },
//                         child: Stack(
//                           children: [
//                             ClipRRect(
//                               borderRadius: BorderRadius.circular(10.r),
//                               child: CachedNetworkImage(
//                                 imageUrl:
//                                     article.urlToimage ?? article.image ?? '',
//                                 fit: BoxFit.fill,
//                                 width: ScreenUtil().screenWidth - 20.w,
//                                 height: 180.h,
//                               ),
//                             ),
//                             Positioned(
//                               bottom: 0,
//                               left: 0,
//                               right: 0,
//                               child: Container(
//                                 padding: EdgeInsets.all(10.w),
//                                 decoration: BoxDecoration(
//                                   color: Colors.black.withOpacity(0.7),
//                                   borderRadius: BorderRadius.only(
//                                     bottomLeft: Radius.circular(10.r),
//                                     bottomRight: Radius.circular(10.r),
//                                   ),
//                                 ),
//                                 child: Text(
//                                   article.title ?? '',
//                                   style: GoogleFonts.poppins(
//                                     color: Colors.white,
//                                     fontSize: 14.sp,
//                                   ),
//                                   maxLines: 3,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(height: 5.h),
//                       Padding(
//                         padding: EdgeInsets.only(left: 10.w),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'By: ${article.source?.name ?? 'Unknown'}',
//                               style: GoogleFonts.poppins(
//                                   color: Colors.black.withOpacity(0.7),
//                                   fontSize: 12.sp,
//                                   fontWeight: FontWeight.bold),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                             SizedBox(height: 2.h),
//                             Text(
//                               'Publish: ${article.publishedAt != null ? format.format(DateTime.parse(article.publishedAt!)) : 'N/A'}',
//                               style: GoogleFonts.poppins(
//                                 color: Colors.black.withOpacity(0.7),
//                                 fontSize: 10.sp,
//                               ),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           );
//         }));
//   }
// }
