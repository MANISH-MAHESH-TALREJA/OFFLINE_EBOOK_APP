import 'package:flutter/material.dart';

import '../../Helper/color_constants.dart';
import '../../localization/demo_localization.dart';
import '../screens/bookmark_list.dart';

// ignore: must_be_immutable
class BookMarkButton extends StatefulWidget
{
  final Function? update;
  bool? fromHome;

  BookMarkButton({super.key, this.update, this.fromHome});

  @override
  BookMarkButtonState createState() => BookMarkButtonState();
}

class BookMarkButtonState extends State<BookMarkButton>
{

  @override
  Widget build(BuildContext context)
  {
    return InkWell(
      onTap: ()
      {
        Navigator.push(context, MaterialPageRoute(builder: (context) => BookmarkList())).then((value)
        {
          setState(() {});
        });
      },
      child: Container(
        height: 40,
        width: 100,
        decoration: BoxDecoration(
          color: ColorsRes.appColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(
              width: 8,
            ),
            Image.asset(
              "assets/images/bookmark_selected.png",
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  DemoLocalization.of(context).translate("bookMark"),
                  style: TextStyle(
                    fontSize: 10,
                    color: ColorsRes.textColor,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
