
import 'package:srila_prabhupada_books/Helper/strings.dart';
import 'package:flutter/material.dart';

import '../../Helper/color_constants.dart';
import '../../localization/demo_localization.dart';
import '../screens/search.dart';

class CustomAppbar extends StatefulWidget
{
  final Function? update;

  const CustomAppbar({super.key, this.update,});

  @override
  CustomAppbarState createState() => CustomAppbarState();
}

class CustomAppbarState extends State<CustomAppbar>
{
  double? width, height;


  @override
  Widget build(BuildContext context)
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        isDrawerOpen
            ? IconButton(icon: Image.asset("assets/images/menu_icon.png",),
                onPressed: () {
                  widget.update!;
                  xOffset = 0;
                  yOffset = 0;
                  scaleFactor = 1;
                  isDrawerOpen = false;
                  setState(
                    () {},
                  );
                  widget.update!;
                },
              )
            : IconButton(
                icon: Image.asset(
                  "assets/images/menu_icon.png",
                ),
                onPressed: () {
                  widget.update!;
                  setState(()
                    {
                      xOffset = width! * 0.8;
                      yOffset = height! * 0.1;
                      scaleFactor = 0.8;
                      isDrawerOpen = true;

                    },
                  );
                  widget.update!;
                },
              ),
        Text(
          DemoLocalization.of(context).translate("appName"),
          style: TextStyle(
            fontSize: 25,
            color: ColorsRes.appColor,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w500,
          ),
        ),
        IconButton(
          icon: Image.asset(
            "assets/images/search_icon.png",
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ListSearch(),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  void initState()
  {
    super.initState();
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
  }
}
