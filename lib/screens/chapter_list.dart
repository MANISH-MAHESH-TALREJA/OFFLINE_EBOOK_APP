import 'package:srila_prabhupada_books/helper/strings.dart';
import 'package:srila_prabhupada_books/screens/search.dart';
import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helper/color_constants.dart';
import '../helper/app_constants.dart';
import '../database/database_helper.dart';
import '../localization/demo_localization.dart';
import '../model/detail.dart';
import '../widgets/common.dart';
import '../widgets/language_button.dart';
import 'about_us.dart';
import 'contact_us.dart';
import 'bookmark_list.dart';
import 'chapter_details.dart';

class ChapterList extends StatefulWidget
{
  final int? id, totalChapters;
  final String? englishTitle, hindiTitle, bookImage, authorName, hindiAuthorName;
  const ChapterList({super.key, this.id, this.englishTitle, this.hindiTitle, this.bookImage, this.authorName, this.hindiAuthorName, this.totalChapters});
  @override
  ChapterListExtended createState() => ChapterListExtended();
}

class ChapterListExtended extends State<ChapterList>
{
  static final DatabaseHelper instance = DatabaseHelper.privateConstructor();

  List<BookDetail> item = [];
  List<BookDetail> _notesForDisplay = [];
  Icon searchIcon = const Icon(Icons.search);
  String? title;
  int? bookDetailsID, lastChapter;
  bool typing = false;
  String? source, query;

  update() {setState(() {},);}

  List<TextSpan> highlightOccurrences(source, query)
  {
    if (query == null || query.isEmpty)
    {
      return [TextSpan(text: source)];
    }

    var matches = <Match>[];
    for (final token in query.trim().toLowerCase().split(' '))
    {
      matches.addAll(token.allMatches(source.toLowerCase()));
    }

    if (matches.isEmpty)
    {
      return [TextSpan(text: source)];
    }

    matches.sort((a, b) => a.start.compareTo(b.start));

    int lastMatchEnd = 0;
    final List<TextSpan> children = [];
    for (final match in matches)
    {
      if (match.end <= lastMatchEnd)
      {

      }
      else if (match.start <= lastMatchEnd)
      {
        children.add(
          TextSpan(
            text: source.substring(
              lastMatchEnd,
              match.end,
            ),
            style: const TextStyle(
              backgroundColor: Color(0xff9a0b0b),
              color: Colors.white,
            ),
          ),
        );
      }
      else if (match.start > lastMatchEnd)
      {
        children.add(TextSpan(text: source.substring(lastMatchEnd, match.start)));
        children.add(TextSpan(text: source.substring(match.start, match.end,), style: const TextStyle(backgroundColor: Color(0xff9a0b0b), color: Colors.white)));
      }
      if (lastMatchEnd < match.end)
      {
        lastMatchEnd = match.end;
      }
    }
    if (lastMatchEnd < source.length)
    {
      children.add(TextSpan(text: source.substring(lastMatchEnd, source.length)));
    }
    return children;
  }

  @override
  void initState()
  {
    super.initState();
    getTitle();
    getIndicator();
    super.initState();
    setState(()
    {
      instance.getBookChapters(widget.id!).then((value)
      {
        item.addAll(value);
        _notesForDisplay = item;
      });
    });
  }

  @override
  Widget build(BuildContext context)
  {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            mainContainer(),
            blurDesign02(context),
            Container(
              decoration: BoxDecoration(
                color: ColorsRes.appColor,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0),
                  topLeft: Radius.circular(0),
                  bottomLeft: Radius.circular(0),
                ),
              ),
              width: MediaQuery.of(context).size.width * 0.75,
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  drawerHeading(context),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Column(
                      children: [
                        ListTile(
                          title: Row(
                            children: [
                              Image.asset("assets/images/mode_icon.png"),
                              const SizedBox(width: 10,),
                              Expanded(
                                child: Text(
                                  DemoLocalization.of(context).translate("Dark Mode"),
                                  style: TextStyle(
                                    color: ColorsRes.white,
                                    fontSize: 16,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 50,
                              ),
                              darkMode == true ? Image.asset("assets/images/toggle_light.png") : Image.asset("assets/images/toggle_dark.png"),
                            ],
                          ),
                          onTap: ()
                          {
                            if (darkMode == true)
                            {
                              setState(()
                              {
                                darkMode = false;
                                setDarkMode(darkMode);
                              });
                            }
                            else
                            {
                              setState(()
                              {
                                darkMode = true;
                                setDarkMode(darkMode);
                              });
                            }
                          },
                        ),
                        ListTile(
                          title: Row(
                            children: [
                              Image.asset("assets/images/rate_us_icon.png"),
                              const SizedBox(width: 10,),
                              Expanded(
                                child: Text(
                                  DemoLocalization.of(context).translate("Rate Us"),
                                  style: TextStyle(
                                    color: ColorsRes.white,
                                    fontSize: 16,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          onTap: ()
                          {
                            LaunchReview.launch(androidAppId: packageName);
                          },
                        ),
                        ListTile(
                          title: Row(
                            children: [
                              Image.asset("assets/images/share_app.png"),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  DemoLocalization.of(context).translate("Share App"),
                                  style: TextStyle(
                                    color: ColorsRes.white,
                                    fontSize: 16,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          onTap: ()
                          {
                            setState(()
                            {
                              Share.share('https://play.google.com/store/apps/details? id=$packageName');
                            });
                          },
                        ),
                        ListTile(
                          title: Row(
                            children: [
                              Image.asset("assets/images/contactus_icon.png"),
                              const SizedBox(width: 10,),
                              Expanded(
                                child: Text(
                                  DemoLocalization.of(context).translate("Contact Us"),
                                  style: TextStyle(
                                    color: ColorsRes.white,
                                    fontSize: 16,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          onTap: ()
                          {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const ContactUs()));
                          },
                        ),
                        ListTile(
                          title: Row(
                            children: [
                              Image.asset("assets/images/about_us_icon.png"),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  DemoLocalization.of(context).translate("About Us"),
                                  style: TextStyle(
                                    color: ColorsRes.white,
                                    fontSize: 16,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          onTap: ()
                          {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutUs()));
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              transform: Matrix4.translationValues(xOffset, yOffset, 0)..scale(scaleFactor)..rotateY(isDrawerOpen ? -0.5 : 0),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(blurRadius: 60, color: ColorsRes.appColor.withOpacity(0.5), offset: const Offset(1, 3),),
                ],
                color: darkMode ? ColorsRes.white : ColorsRes.black,
                borderRadius: BorderRadius.circular(isDrawerOpen ? 40 : 0.0,),
              ),
              duration: const Duration(milliseconds: 250),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(isDrawerOpen ? 40 : 0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width * 0.7,
                        color: darkMode ? Colors.grey[100] : ColorsRes.grey,
                        child: Stack(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.width * 0.5,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(30.0),
                                  bottomRight: Radius.circular(30.0),
                                ),

                                color: darkMode ? ColorsRes.white : ColorsRes.grey1,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 15.0,
                                      left: 5,
                                      right: 5,
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            isDrawerOpen
                                                ? IconButton(
                                                    icon: Image.asset("assets/images/menu_icon.png",),
                                                    onPressed: () {
                                                      xOffset = 0;
                                                      yOffset = 0;
                                                      scaleFactor = 1;
                                                      isDrawerOpen = false;
                                                      setState(() {});
                                                    },
                                                  )
                                                : IconButton(
                                                    icon: Image.asset("assets/images/menu_icon.png",),
                                                    onPressed: ()
                                                    {
                                                      setState(()
                                                        {
                                                          xOffset = width * 0.8;
                                                          yOffset = height * 0.1;
                                                          scaleFactor = 0.8;
                                                          isDrawerOpen = true;

                                                        },
                                                      );
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
                                              icon: Image.asset("assets/images/search_icon.png",),
                                              onPressed: ()
                                              {
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => const ListSearch()));
                                              },
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 12.0,
                                            left: 12.0,
                                            right: 12.0,
                                          ),
                                          child: Text(()
                                            {
                                              if (languageFlag == "en")
                                              {
                                                return widget.englishTitle!;
                                              }
                                              else if (languageFlag == "hi")
                                              {
                                                return widget.hindiTitle!;
                                              } else
                                              {
                                                return widget.englishTitle!;
                                              }
                                            }(),
                                            style: TextStyle(
                                              color: ColorsRes.appColor,
                                              fontSize: 20.0,
                                              fontFamily: "Poppins",
                                              fontWeight: FontWeight.w600,
                                              height: 1.0,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 12.0,
                                            top: 8.0,
                                            right: 12.0,
                                          ),
                                          child: Text(
                                            DemoLocalization.of(context).translate("Written by") + " " + ()
                                            {
                                                  if (languageFlag == "en")
                                                  {
                                                    return widget.authorName;
                                                  }
                                                  else if (languageFlag == "hi")
                                                  {
                                                    return widget.hindiAuthorName;
                                                  }
                                                  else
                                                  {
                                                    return widget.authorName;
                                                  }
                                                }(),
                                            style: TextStyle(
                                              color: darkMode ? ColorsRes.appColor : ColorsRes.white,
                                              fontFamily: "Poppins",
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 12.0,
                                            right: 12.0,
                                          ),
                                          child: Text(
                                            "${widget.totalChapters} ${DemoLocalization.of(context).translate("Chapters")}",
                                            style: TextStyle(color: darkMode ? ColorsRes.appColor : ColorsRes.white, fontFamily: "Poppins"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned.directional(
                              textDirection: Directionality.of(context),
                              top: height * 0.128,
                              start: width * 0.675,
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15.0),
                                    child: Image.asset(
                                      "assets/book_images/${widget.bookImage}",
                                      height: 150,
                                      width: 110,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned.directional(
                                textDirection: Directionality.of(context),
                                top: width * 0.54,
                                start: width * 0.02,
                                child: LanguageWidget(
                                  update: update,
                                  fromHome: false,
                                )
                            ),
                            Positioned.directional(
                              textDirection: Directionality.of(context),
                              top: width * 0.54,
                              start: width * 0.235,
                              child: GestureDetector(
                                onTap: ()
                                {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => BookmarkList()));
                                },
                                child: Container(
                                  height: height * 0.055,
                                  width: width * 0.20,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: ColorsRes.appColor,
                                  ),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 10, right: 4,),
                                        child: Image.asset("assets/images/bookmark_selected.png",),
                                      ),
                                      Expanded(
                                        child: Text(
                                          DemoLocalization.of(context).translate("bookMark"),
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
                              ),
                            ),
                            Positioned.directional(
                              textDirection: Directionality.of(context),
                              top: width * 0.54,
                              start: width * 0.45,
                              child: GestureDetector(
                                onTap: () async
                                {
                                  await getTitle();
                                  await getIndicator();
                                  setState(() {});
                                  if (bookDetailsID == null)
                                  {
                                    if(!mounted)
                                    {
                                      return;
                                    }
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: ColorsRes.appColor,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(50))
                                        ),
                                        duration: const Duration(seconds: 2),
                                        content: Text(
                                          DemoLocalization.of(context).translate("Indicator not set !"),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: ColorsRes.white, fontFamily: 'Times new Roman'),
                                        ),
                                      ),
                                    );
                                  }
                                  else
                                  {
                                    if(!mounted)
                                    {
                                      return;
                                    }
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailPage(
                                          chapterID: bookDetailsID,
                                          // title: title,
                                        ),
                                      ),
                                    ).then((value)
                                    {
                                      setState(()
                                      {
                                        xOffset = 0;
                                        yOffset = 0;
                                        scaleFactor = 1;
                                        isDrawerOpen = false;
                                      });
                                      },
                                    );
                                  }
                                },
                                child: Container(
                                  height: height * 0.055,
                                  width: width * 0.20,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: ColorsRes.appColor,),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 10, right: 4,),
                                        child: bookDetailsID == null ? Image.asset("assets/images/pinned_unselected.png") : Image.asset("assets/images/pinned_selected.png"),
                                      ),
                                      Expanded(
                                        child: Text(
                                          DemoLocalization.of(context).translate("pinned"),
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
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.61,
                        width: MediaQuery.of(context).size.width,
                        color: darkMode ? ColorsRes.white : ColorsRes.grey1,
                        child: Stack(
                          children: [
                            FutureBuilder(
                              future: instance.getBookChapters(widget.id!),
                              builder: (context, index)
                              {
                                return ListView.builder(
                                  itemCount: _notesForDisplay.length,
                                  itemBuilder: (context, index)
                                  {
                                    var item = _notesForDisplay[index++];
                                    lastChapter = _notesForDisplay.length;
                                    return GestureDetector(
                                      onTap: ()
                                      {
                                        setState(()
                                        {
                                          bookNotComplete = true;
                                        });
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage(chapterID: item.id))).then((value)
                                        {
                                          setState(()
                                          {
                                            xOffset = 0;
                                            yOffset = 0;
                                            scaleFactor = 1;
                                            isDrawerOpen = false;
                                          });
                                          },
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Container(
                                          height: height * 0.16, //100
                                          decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.only(
                                              topRight: Radius.circular(30.0),
                                              topLeft: Radius.circular(30.0),
                                            ),
                                            color: darkMode ? ColorsRes.white : ColorsRes.grey1,
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.black,
                                                blurRadius: 8.0,
                                                spreadRadius: -8,
                                                offset: Offset(1, -4),
                                              ),
                                            ],
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              top: 20.0,
                                              right: 20.0,
                                              left: 20.0,
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    (()
                                                    {
                                                      if (query == null || query!.isEmpty)
                                                      {
                                                        return Expanded(
                                                          child: Text(()
                                                            {
                                                              if (languageFlag == "en")
                                                              {
                                                                return item.chapterName!;
                                                              }
                                                              else if (languageFlag == "hi")
                                                              {
                                                                return item.hindiChapterName!;
                                                              }
                                                              else
                                                              {
                                                                return item.chapterName!;
                                                              }
                                                            }(),
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              color: ColorsRes.appColor,
                                                              fontFamily: 'Poppins',
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                      else
                                                      {
                                                        return Text("$index.");
                                                      }
                                                    }()),
                                                    Image.asset("assets/images/chapter_icon.png")
                                                  ],
                                                ),
                                                Expanded(
                                                  child: Text(()
                                                    {
                                                      if (languageFlag == "en")
                                                      {
                                                        return item.shortDescription!;
                                                      }
                                                      else if (languageFlag == "hi")
                                                      {
                                                        return item.hindiShortDescription!;
                                                      }
                                                      else
                                                      {
                                                        return item.shortDescription!;
                                                      }
                                                    }(),
                                                    style: TextStyle(
                                                      color: darkMode ? ColorsRes.appColor : ColorsRes.white,
                                                      fontFamily: "Poppins",
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            isDrawerOpen
                ? Positioned.directional(
                    textDirection: Directionality.of(context),
                    top: height * 0.0,
                    start: width * 0.75,
                    child: Container(
                      width: width * 0.25,
                      height: height,
                      color: Colors.white.withOpacity(0.3),
                    ),
                  )
                : Container(),
            isDrawerOpen
                ? Positioned.directional(
                    textDirection: Directionality.of(context),
                    top: height * 0.1,
                    start: width * 0.8,
                    child: GestureDetector(
                      onTap: ()
                      {
                        setState(()
                        {
                          xOffset = 0;
                          yOffset = 0;
                          scaleFactor = 1;
                          isDrawerOpen = false;
                        });
                      },
                      child: Container(width: width * 0.195, height: height * 0.79, color: Colors.transparent),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  Future<String> getTitle() async
  {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    title = preferences.getString("Title");
    return title!;
  }

  Future<int> getIndicator() async
  {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    bookDetailsID = preferences.getInt("In");

    return bookDetailsID!;
  }

  setDarkMode(bool darkMode) async
  {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setBool("DARK MODE", darkMode);
  }
}
