import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rick_morty_app/pages/home_page.dart';
import 'package:rick_morty_app/theme/app_images.dart';
import '../theme/app_colors.dart';

PreferredSizeWidget appBarComponent(BuildContext context, {bool isSecondPage = false}) {
  return AppBar(
    toolbarHeight: kToolbarHeight * 2.2,
    backgroundColor: AppColors.appBarColor,
    systemOverlayStyle: SystemUiOverlayStyle.dark,

    leading: Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 6),
        child: GestureDetector(
          onTap: () {
            final currentRoute = ModalRoute.of(context)?.settings.name;
            if (currentRoute == HomePage.routeId) return;
            Navigator.pop(context);
          },
          child: Icon(
            isSecondPage ? Icons.arrow_back : Icons.menu,
            color: Color(0xFFE6E1E5),
            size: 28,
          ),
        ),
      ),
    ),

    actions: [
      Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 6, right: 16),
          child: Icon(
            Icons.account_circle,
            color: Color(0xFFCAC4D0),
            size: 30,
          ),
        ),
      ),
    ],

    flexibleSpace: SafeArea(
      child: Column(
        children: [
          Image.asset(AppImages.logo),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              "RICK AND MORTY API",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w400,
                fontSize: 14.5,
                height: 1.0,                 
                letterSpacing: 14.5 * 0.165, 
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
