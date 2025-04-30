// ignore_for_file: unrelated_type_equality_checks, use_function_type_syntax_for_parameters, deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/controller/new_view_model_controller.dart';
import 'package:news_app/model/news_category_model.dart';
import '../controller/categoriesNews.dart';

class CategoriesTabScreen extends StatefulWidget {
  const CategoriesTabScreen({super.key});

  @override
  State<CategoriesTabScreen> createState() => _CategoriesTabScreenState();
}

class _CategoriesTabScreenState extends State<CategoriesTabScreen>
    with TickerProviderStateMixin {
  late TabController tabController;
  final CategoryController categoryController = Get.put(CategoryController());
  final NewsCategorayModel newsCategoryModel = Get.put(NewsCategorayModel());
  final NewsViewModelController newsViewModelController =
      Get.put(NewsViewModelController());

  @override
  void initState() {
    super.initState();

    tabController = TabController(
      length: categoryController.categories.length,
      vsync: this,
    );

    tabController.addListener(() {
      if (tabController.indexIsChanging == false) {
        categoryController.selectCategory(tabController.index);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      categoryController
          .fetchNewsCategory(categoryController.selectedCategory.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.black,
      onRefresh: () async {
        await newsRepository.fetchNewsFromChannel(null);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            splashColor: Colors.white,
            icon: Icon(CupertinoIcons.back),
            onPressed: () {
              Get.back();
            },
          ),
          title: Text("Categories", style: GoogleFonts.poppins(fontSize: 15)),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 1,
          bottom: TabBar(
            controller: tabController,
            splashFactory: InkRipple.splashFactory,
            overlayColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed))
                  return Colors.transparent;
                return null; // default behavior
              },
            ),
            isScrollable: true,
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.black87,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(5.r),
              color: Colors.lightGreen,
            ),
            indicatorPadding: EdgeInsets.symmetric(vertical: 3),
            labelStyle: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
            tabs: categoryController.categories
                .map((category) => Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Tab(text: category.capitalizeFirst),
                    ))
                .toList(),
          ),
        ),
        body: Obx(
          () => TabBarView(
            controller: tabController,
            children: categoryController.categories.map((category) {
              if (categoryController.isLoading.value) {
                return Center(
                    child: SpinKitCircle(size: 50.r, color: Colors.amber));
              }

              final articles =
                  categoryController.newsDataMap[category]?.articles ?? [];

              if (articles.isEmpty) {
                return Center(
                    child: Text("No Data Found.",
                        style: GoogleFonts.poppins(color: Colors.black54)));
              }

              return ListView.builder(
                itemCount: articles.length,
                itemBuilder: (context, index) {
                  final article = articles[index];
                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 5.h),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  newsViewModelController
                                      .launchArticle(article.url ?? '');
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.r),
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) => Center(
                                        child: SpinKitCircle(
                                            size: 50.r, color: Colors.amber)),
                                    errorWidget: (context, url, error) =>
                                        Center(
                                            child: Container(
                                                height: double.infinity,
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.r),
                                                    border: Border.all(
                                                      color: Colors.black,
                                                    )),
                                                child: Center(
                                                  child: Text(
                                                      'Tap to see this News\non ${article.source?.name}'),
                                                ))),
                                    imageUrl: article.image ??
                                        article.urlToimage.toString(),
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

                                padding: EdgeInsets.all(
                                    5.w), // Padding for title text
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
                                        fontSize: 14.r,
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                    ),
                                    SizedBox(height: 2.h),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            'By: ${article.source?.name ?? 'Unknown'}',
                                            style: GoogleFonts.poppins(
                                                fontSize: 11.r,
                                                color: Colors.black54)),
                                        Text(
                                            'Published: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(article.publishedAt ?? DateTime.now().toString()))}',
                                            style: GoogleFonts.poppins(
                                                fontSize: 11.r,
                                                color: Colors.black45)),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 3.h,
                                    )
                                  ],
                                ),
                              ),
                            ]),
                      ),
                    ],
                  );
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
