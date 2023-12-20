import 'package:srila_prabhupada_books/Helper/strings.dart';
import 'package:flutter/material.dart';
import '../../Helper/color_constants.dart';
import '../../localization/demo_localization.dart';
import '../../localization/language_constants.dart';

// ignore: must_be_immutable
class LanguageWidget extends StatefulWidget {
  final Function? update;
  bool? fromHome;

  LanguageWidget({super.key, this.update, this.fromHome});

  @override
  LanguageWidgetState createState() => LanguageWidgetState();
}

class LanguageWidgetState extends State<LanguageWidget> {

  @override
  Widget build(BuildContext context) {
    double? width = MediaQuery.of(context).size.width, height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        setState(
          () {
            showMenu<String>(
              color: darkMode ? ColorsRes.appColor : ColorsRes.grey,
              context: context,
              position: RelativeRect.fromLTRB(0, width * 0.64, 0, 0.0),
              items: [
                PopupMenuItem<String>(
                    value: '0',
                    child: Text(DemoLocalization.of(context).translate("ENGLISH"),
                        style: const TextStyle(color: Colors.white))),
                PopupMenuItem<String>(
                    value: '1',
                    child: Text(DemoLocalization.of(context).translate("HINDI"),
                        style: const TextStyle(color: Colors.white))),
              ],
              elevation: 7.0,
            ).then<void>(
              (String? itemSelected) {
                if (itemSelected == null) return;
                if (itemSelected == "0") {
                  changeLanguage(context, "en");
                  setState(() async {});
                  widget.update;
                } else if (itemSelected == "1") {
                  setState(() async {
                    changeLanguage(context, "hi");
                  });
                  widget.update;
                }
                else
                  {
                    changeLanguage(context, "en");
                    setState(() async {});
                    widget.update;
                  }
              },
            );
          },
        );
      },
      child: widget.fromHome!
          ? Container(
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
                    "assets/images/language_icon.png",
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Text(
                        DemoLocalization.of(context).translate("language"),
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
            )
          : Container(
              height: height * 0.055,
              width: width * 0.20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: ColorsRes.appColor,
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 5,
                      right: 4,
                    ),
                    child: Image.asset(
                      "assets/images/language_icon.png",
                    ),
                  ),
                  Expanded(
                    child: Text(
                      DemoLocalization.of(context).translate("language"),
                      style: TextStyle(
                        color: ColorsRes.textColor,
                        fontSize: 8,
                        fontFamily: "Poppins-ExtraLight",
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
