// ignore_for_file: prefer_const_constructors, unused_import, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:star_maker/routes/routes.dart';
import 'package:star_maker/utils/colors.dart';
import 'package:star_maker/views/karaoke/component/category_container.dart';
import 'package:star_maker/views/karaoke/component/gradient_text.dart';
import 'package:star_maker/views/karaoke/main/fragment/categorydetail/category_detail.dart';

class CategoriesView extends StatefulWidget {
  const CategoriesView({super.key});

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GradientTextStatic('Categories',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w800),
                        colors: [Colors.purpleAccent, Colors.blue]),
                    Image.asset('assets/images/Search.png'),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Divider(
                  thickness: 1,
                  color: Color.fromARGB(255, 81, 100, 209),
                ),
              ),
              Gap(10),
              Container(
                height: MediaQuery.of(context).size.height * 0.7,
                decoration: BoxDecoration(
                    // border: Border.all(),
                    ),
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 179 / 195,
                      crossAxisSpacing: 12.0,
                    ),
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      List<Map<String, dynamic>> categories = [
                        {
                          'name': 'Popular Now',
                          'pic': 'assets/images/categoryimg.png',
                        },
                        {
                          'name': 'Arabic',
                          'pic': 'assets/images/arabic_category.png',
                        },
                        {
                          'name': 'English',
                          'pic': 'assets/images/english_category.png',
                        },
                        {
                          'name': 'Hindi',
                          'pic': 'assets/images/hindi_category.png',
                        },
                        {
                          'name': 'Islamic',
                          'pic': 'assets/images/islamic_category.png',
                        },
                        
                      ];

                      Map<String, dynamic> category = categories[index];
                      return CategoryContainer(
                        name: category['name'],
                        pic: category['pic'],
                        ontap: () {
                          AppRoutes.navigateTocategorydetailView(context);
                        },
                      );
                    }),
              )
            ],
          ),
        ),
      )),
    );
  }
}
