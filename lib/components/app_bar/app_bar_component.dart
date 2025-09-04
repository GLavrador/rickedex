import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rick_morty_app/pages/home_page.dart';
import 'package:rick_morty_app/theme/app_images.dart';
import '../../theme/app_colors.dart';

PreferredSizeWidget appBarComponent(BuildContext context, {bool isSecondPage = false}) {
  return AppBar(
    toolbarHeight: kToolbarHeight * 2.2,
    backgroundColor: AppColors.appBarColor,
    systemOverlayStyle: SystemUiOverlayStyle.dark,

    // espaço extra só nas páginas de detalhe (voltar + home)
    leadingWidth: isSecondPage ? 96 : null,

    leading: Builder(
      builder: (ctx) => Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: isSecondPage
              ? Row(
                  children: [
                    const SizedBox(width: 14),
                    GestureDetector(
                      onTap: () {
                        final currentRoute = ModalRoute.of(ctx)?.settings.name;
                        if (currentRoute == HomePage.routeId) return;
                        Navigator.pop(ctx);
                      },
                      child: const Icon(Icons.arrow_back, color: Color(0xFFE6E1E5)),
                    ),

                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(ctx).pushNamedAndRemoveUntil(
                          HomePage.routeId,
                          (route) => false,
                        );
                      },
                      child: const Icon(Icons.home_outlined, color: Color(0xFFE6E1E5)),
                    ),
                  ],
                )

              : GestureDetector(
                  onTap: () => Scaffold.of(ctx).openDrawer(),
                  child: const Icon(Icons.menu, color: Color(0xFFE6E1E5)),
                ),
        ),
      ),
    ),

    actions: [
      Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 6, right: 16),
          child: const Icon(Icons.account_circle, color: Color(0xFFCAC4D0), size: 26),
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
