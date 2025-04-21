import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/controller/news_controller.dart';
import 'package:news_app/model/news_model.dart';
import 'package:news_app/view_model/news_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NewsViewModelController newsViewModelController =
      Get.put(NewsViewModelController());

  final NewsViewModel newsViewModel = NewsViewModel();

  @override
  Widget build(BuildContext context) {
    final format = DateFormat('yyyy-MM-dd');
    return Scaffold(
        appBar: AppBar(
          actions: [
            PopupMenuButton<String>(
              onSelected: (String value) {
                if (value == 'settings') {
                  // Handle settings action
                  print('Settings clicked');
                } else if (value == 'logout') {
                  // Handle logout action
                  print('Logout clicked');
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  enabled: false, // Disable interaction for the title
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text('Filter', // Title text
                        style: GoogleFonts.aDLaMDisplay(color: Colors.black)),
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'settings',
                  child: Text('Settings'),
                ),
                PopupMenuItem<String>(
                  value: 'logout',
                  child: Text('Logout'),
                ),
              ],
              icon: Icon(Icons.more_vert),
            ),
            SizedBox(width: 15.w),
          ],
          leading: Icon(Icons.filter_alt_outlined),
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text('HeadLines',
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        body: Obx(
          () {
            if (newsViewModelController.isLaunching.value) {
              return Center(
                child: SpinKitCircle(size: 50.r, color: Colors.amber),
              );
            }
            return FutureBuilder<NewsModel?>(
                future: newsViewModel.fetchNewsData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: SpinKitCircle(
                        size: 50.r,
                        color: Colors.amber,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    // return Center(child: Text("Error: ${snapshot.error}"));
                    return Container(
                      color: Colors.amber,
                      height: 200.h,
                      width: ScreenUtil().screenWidth - 20.w,
                    );
                  } else if (snapshot.hasData) {
                    return SizedBox(
                      height: 250
                          .h, // Increased height to make space for the author name
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data?.articles?.length ?? 0,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment
                                  .start, // Aligns everything to the start
                              children: [
                                // Image section
                                InkWell(
                                  onTap: () {
                                    newsViewModelController.launchArticle(
                                        snapshot.data!.articles![index].url
                                            .toString());
                                  },
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                        child: CachedNetworkImage(
                                          imageUrl: snapshot
                                              .data!.articles![index].urlToimage
                                              .toString(),
                                          fit: BoxFit.fill,
                                          width:
                                              ScreenUtil().screenWidth - 20.w,
                                          height: 180.h, // Image height
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        child: Container(
                                          padding: EdgeInsets.all(
                                              10.w), // Padding for title text
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.black.withOpacity(0.7),
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(10.r),
                                              bottomRight:
                                                  Radius.circular(10.r),
                                            ),
                                          ),
                                          child: Text(
                                            snapshot
                                                .data!.articles![index].title
                                                .toString(),
                                            style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 14.sp,
                                            ),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap:
                                                true, // Allow wrapping of text
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5.h),

                                Padding(
                                  padding: EdgeInsets.only(left: 10.w),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'By: ${snapshot.data!.articles![index].source?.name ?? 'Unknown'}',
                                        style: GoogleFonts.poppins(
                                            color:
                                                Colors.black.withOpacity(0.7),
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.bold),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(
                                        height: 2.h,
                                      ),
                                      Text(
                                        'Publish: ${format.format(DateTime.parse(snapshot.data!.articles![index].publishedAt!))}',
                                        style: GoogleFonts.poppins(
                                          color: Colors.black.withOpacity(0.7),
                                          fontSize: 10.sp,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return Center(child: Text('No data available.'));
                  }
                });
          },
        ));
  }
}
