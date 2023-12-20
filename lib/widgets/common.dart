import 'package:flutter/material.dart';

import '../../Helper/color_constants.dart';
import '../../Helper/strings.dart';

getProgress()
{
  return const Center(
    child: CircularProgressIndicator(),
  );
}

mainContainer()
{
  return Container(width: double.infinity, height: double.infinity, color: darkMode ? Colors.grey[200] : ColorsRes.grey,);
}

blurDesign02(BuildContext context)
{
  double? width = MediaQuery.of(context).size.width, height = MediaQuery.of(context).size.height;
  return isDrawerOpen
      ? Positioned.directional(
          textDirection: Directionality.of(context),
          top: height * 0.0,
          start: width * 0.75, // detail ma aya 0.50 htu
          child: Container(
            width: width * 0.25,
            height: height,
            color: Colors.white.withOpacity(0.3),
          ),
        )
      : Container();
}

blurDesign01(BuildContext context)
{
  double? width = MediaQuery.of(context).size.width, height = MediaQuery.of(context).size.height;
  return isDrawerOpen
      ? Positioned.directional(
          textDirection: Directionality.of(context),
          top: height * 0.0,
          start: width * 0.50,
          child: Container(
            width: width * 0.25,
            height: height,
            color: Colors.white.withOpacity(0.3),
          ),
        )
      : Container();
}

drawerHeading(BuildContext context)
{
  double? width = MediaQuery.of(context).size.width, height = MediaQuery.of(context).size.height;
  return Container(
    decoration: BoxDecoration(
      color: ColorsRes.textColor,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(0),
        topRight: Radius.circular(30.0),
        bottomLeft: Radius.circular(0),
        bottomRight: Radius.circular(30.0),
      ),
    ),
    height: MediaQuery.of(context).size.height * 0.42,
    child: Stack(
      children: [
        Positioned.directional(
          textDirection: Directionality.of(context),
          top: height * 0.045,
          start: width * 0.07,
          child: Image.asset(
            "assets/images/srila_prabhupada.png", height: height * 0.29, width: width * 0.575, alignment: Alignment.center, fit: BoxFit.fill,
          ),
        ),
        Positioned.directional(
          textDirection: Directionality.of(context),
          top: height * 0.34,
          start: width * 0.0750,
          child: Text(
            "SRILA PRABHUPADA BOOKS",
            style: TextStyle(
                color: ColorsRes.appColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: "Poppins-Bold"),
          ),
        ),
        Positioned.directional(
          textDirection: Directionality.of(context),
          top: height * 0.37,
          start: width * 0.160,
          child: Text(
            "REF FROM - VEDABASE.IO",
            style: TextStyle(
              color: ColorsRes.appColor,
              fontSize: 12,
                fontFamily: "Poppins"
            ),
          ),
        ),
      ],
    ),
  );
}
