// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/controller/categoriesNews.dart';
import 'package:news_app/controller/new_view_model_controller.dart';
import 'package:news_app/repository/news_repository.dart';
import 'package:news_app/routes/routes.dart';
import 'package:news_app/views/category_news.dart';
import '../constant/pakistan_news_channel.dart';

class HomesScreen extends StatefulWidget {
  const HomesScreen({super.key});

  @override
  State<HomesScreen> createState() => _HomesScreenState();
}

class _HomesScreenState extends State<HomesScreen> {
  @override
  void initState() {
    super.initState();
    newsRepository.fetchNewsData();
    newsRepository.fetchNewsFromChannel(null);
  }

  final NewsRepository newsRepository = Get.put(NewsRepository());
  final CategoryController categoryController = Get.put(CategoryController());

  final NewsViewModelController newsViewModelController =
      Get.put(NewsViewModelController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: RefreshIndicator(
        color: Colors.black,
        onRefresh: () async {
          await newsRepository.fetchNewsData();
          await newsRepository.fetchNewsFromChannel(null);
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            scrolledUnderElevation: 0,
            elevation: 0,
            backgroundColor: Colors.white,
            leading: IconButton(
                onPressed: () {
                  // Navigator.push(context, MaterialPageRoute(
                  //   builder: (context) {
                  //     return CategoriesTabScreen();
                  //   },
                  // ));
                  Get.toNamed(Routes.categoryScreen);
                },
                icon: Icon(Icons.category_outlined)),
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Text('HeadLines',
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            actions: [
              PopupMenuButton<PakistaniNewsChannel>(
                onSelected: (PakistaniNewsChannel selectedChannel) {
                  newsRepository.fetchNewsFromChannel(selectedChannel);
                  print('selectedChannel:${selectedChannel}');
                },
                itemBuilder: (BuildContext context) {
                  return PakistaniNewsChannel.values
                      .map((PakistaniNewsChannel channel) {
                    return PopupMenuItem<PakistaniNewsChannel>(
                      value: channel,
                      child: Text(channel.displayName),
                    );
                  }).toList();
                },
              ),
            ],
          ),
          body: Obx(() {
            // Show loading spinner when fetching news data
            if (newsRepository.isLoading.value &&
                newsRepository.countryArticles.isEmpty) {
              return Center(
                  child: SpinKitCircle(size: 50.r, color: Colors.amber));
            }

            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // ---------- Horizontal List (Country-based News) ----------
                    SizedBox(
                      height: 2.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.w, vertical: 10.h),
                      child: Text("Top Headlines",
                          style: GoogleFonts.poppins(
                              fontSize: 16, fontWeight: FontWeight.w400)),
                    ),
                    SizedBox(
                      height: ScreenUtil().screenWidth < 500 ? 285.h : 280.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: newsRepository.countryArticles.length,
                        itemBuilder: (context, index) {
                          final article = newsRepository.countryArticles[index];
                          return SizedBox(
                            width: 340.w, // or any width you prefer
                            child: buildNewsCard(article, index,
                                isHorizontal: true),
                          );
                        },
                      ),
                    ),

                    // ---------- Vertical List (Channel-based News) ----------
                    if (newsRepository.channelArticles.isNotEmpty) ...[
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.w, vertical: 10.h),
                        child: Text("Channel News",
                            style: GoogleFonts.poppins(
                                fontSize: 16, fontWeight: FontWeight.w400)),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: newsRepository.channelArticles.length,
                        itemBuilder: (context, index) {
                          final article = newsRepository.channelArticles[index];
                          return buildNewsCard(article, index,
                              isHorizontal: false);
                        },
                      ),
                    ] else ...[
                      Center(
                        child: Text(
                          'Not to found data\nPlease check your internet connection',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              fontSize: 14.sp, color: Colors.black54),
                        ),
                      )
                    ]
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget buildNewsCard(article, int index, {required bool isHorizontal}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        InkWell(
          onTap: () {
            newsViewModelController.launchArticle(article.url ?? '');
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: CachedNetworkImage(
              placeholder: (context, url) =>
                  Center(child: SpinKitCircle(size: 50.r, color: Colors.amber)),
              errorWidget: (context, url, error) => Center(
                  child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                            color: Colors.black,
                          )),
                      child: Center(
                        child: Text(
                            'Tap to see this News\non ${article.source?.name}'),
                      ))),
              imageUrl: article.image ?? '',
              fit: BoxFit.fill,
              width: ScreenUtil().screenWidth - 20.w,
              height: 180.h,
            ),
          ),
        ),
        SizedBox(
          height: 5.h,
        ),
        Container(
          width: ScreenUtil().screenWidth - 20.w,

          padding: EdgeInsets.all(5.w), // Padding for title text
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10.r),
              bottomRight: Radius.circular(10.r),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                article.title ?? '',
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 15.r,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                softWrap: true, // Allow wrapping of text
              ),
              SizedBox(height: 2.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('By: ${article.source?.name ?? 'Unknown'}',
                      style: GoogleFonts.poppins(
                          fontSize: 11.r, color: Colors.black54)),
                  Text(
                      'Published: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(article.publishedAt ?? DateTime.now().toString()))}',
                      style: GoogleFonts.poppins(
                          fontSize: 11.r, color: Colors.black45)),
                ],
              ),
              SizedBox(
                height: 3.h,
              )
            ],
          ),
        ),
      ]), // Column
    );
  }
}
