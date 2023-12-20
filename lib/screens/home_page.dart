import 'package:srila_prabhupada_books/Helper/strings.dart';
import 'package:srila_prabhupada_books/screens/search.dart';
import 'package:srila_prabhupada_books/database/database_helper.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helper/color_constants.dart';
import '../helper/app_constants.dart';
import '../helper/session.dart';
import '../model/category.dart';
import '../localization/demo_localization.dart';
import '../widgets/bookmark_button.dart';
import '../widgets/common.dart';
import '../widgets/language_button.dart';
import 'about_us.dart';
import 'contact_us.dart';
import 'chapter_details.dart';
import 'chapter_list.dart';

class HomePage extends StatefulWidget
{
  final int? id;

  const HomePage({super.key, this.id,});

  @override
  MyHomePage createState() => MyHomePage();
}

class MyHomePage extends State<HomePage>
{
  static final DatabaseHelper instance = DatabaseHelper.privateConstructor();
  int? chapterId;
  String? title;
  var currentIndexPage = 0;
  double? width, height;
  final PageController controller = PageController(initialPage: 0);
  final key = GlobalKey<ScaffoldState>();
  final List<String> imgList =
  [
    "assets/images/slider01.png",
    "assets/images/slider02.png",
    "assets/images/slider03.png",
  ];

  @override
  void initState()
  {
    super.initState();
    initializeData();
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
  }

  initializeData()
  {
    getTitle();
    getIndicator();
  }

  update()
  {
    setState(() {});
  }

//------------------------------------------------------------------------------
//=============================== Animated Container ==============================

  animatedContainer()
  {
    return AnimatedContainer(
      transform: Matrix4.translationValues(xOffset, yOffset, 0)..scale(scaleFactor)..rotateY(isDrawerOpen ? -0.5 : 0,),
      decoration: BoxDecoration(
        color: darkMode ? ColorsRes.white : ColorsRes.grey,
        boxShadow:
        [
          BoxShadow(
            blurRadius: 60,
            color: ColorsRes.appColor.withOpacity(0.5),
            offset: const Offset(1, 3),
          ),
        ],
        borderRadius: BorderRadius.circular(isDrawerOpen ? 40 : 0.0),
      ),
      duration: const Duration(milliseconds: 250),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(isDrawerOpen ? 40 : 0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          controller: controller,
          child: Column(
            children: [
              const SizedBox(
                height: 5,
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 5,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    isDrawerOpen
                        ? IconButton(icon: Image.asset("assets/images/menu_icon.png",),
                            onPressed: ()
                            {
                              xOffset = 0;
                              yOffset = 0;
                              scaleFactor = 1;
                              isDrawerOpen = false;
                              setState(() {});
                            },
                          )
                        : IconButton(icon: Image.asset("assets/images/menu_icon.png",),
                            onPressed: ()
                            {
                              setState(()
                              {
                                xOffset = width! * 0.8;
                                yOffset = height! * 0.1;
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
                    IconButton(icon: Image.asset("assets/images/search_icon.png",),
                      onPressed: ()
                      {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const ListSearch(),),);
                      },
                    ),
                  ],
                ),
              ),
              getSliders(),
              const SizedBox(
                height: 10,
              ),
              threeButtons(),
              getBooks(),
            ],
          ),
        ),
      ),
    );
  }

//------------------------------------------------------------------------------
//==================================== Sliders =================================

  getImage(String img)
  {
    return Positioned.fill(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.asset(img, fit: BoxFit.fill),
      ),
    );
  }

  getSliders()
  {
    return CarouselSlider(
      options: CarouselOptions(
        enlargeCenterPage: true,
        enableInfiniteScroll: false,
        initialPage: 2,
        autoPlay: true,
        aspectRatio: 16 / 9,
      ),
      items: [
        Stack(
          children: [
            getImage("assets/images/slider01.jpg"),
          ],
        ),
        Stack(
          children: [
            getImage("assets/images/slider02.jpg"),
          ],
        ),
        Stack(
          children: [
            getImage("assets/images/slider03.jpg"),
          ],
        ),
      ],
    );
  }

// ------------------------------------------------------------------------
// =============================== 3 Buttons ==============================

  threeButtons() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 15.0,
        right: 15.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          LanguageWidget(
            update: update,
            fromHome: true,
          ),
          BookMarkButton(
            update: update,
            fromHome: true,
          ),
          getThirdButton(),
        ],
      ),
    );
  }

  // Third Button
  getThirdButton()
  {
    return InkWell(
      onTap: () async
      {
        await getTitle();
        await getIndicator();
        if (chapterId == null)
        {
          if(!mounted)
          {
            return;
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: ColorsRes.appColor,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(50),
                ),
              ),
              duration: const Duration(
                seconds: 2,
              ),
              content: Text(
                DemoLocalization.of(context).translate("indicatorNotSet"),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ColorsRes.white,
                  fontFamily: 'Times new Roman',
                ),
              ),
            ),
          );
        } else {
          if(!mounted)
          {
            return;
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailPage(
                chapterID: chapterId,
              ),
            ),
          );
        }
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
            chapterId == null
                ? Image.asset(
                    "assets/images/pinned_unselected.png",
                  )
                : Image.asset(
                    "assets/images/pinned_selected.png",
                  ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  DemoLocalization.of(context).translate("pinned"),
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

//------------------------------------------------------------------------------
//=============================== 3 Buttons ====================================
  getBooks() {
    return Container(
      margin: const EdgeInsets.all(15),
      color: darkMode ? ColorsRes.white : ColorsRes.grey,
      child: FutureBuilder(
        //Fetching all the persons from the list using the instance of the DatabaseHelper class
        future: instance.getBooks(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          //Checking if we got data or not from the DB
          if (snapshot.hasData) {
            return GridView.builder(
              physics: const BouncingScrollPhysics(parent: ScrollPhysics()),
              itemCount: snapshot.data.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 0.965,
              ),
              itemBuilder: (BuildContext context, int index) {
                Books item = snapshot.data[index];
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        // data base to global variable title
                        /*englishTitle = item.englishTitle;
                        hindiTitle = item.hindiTitle;
                        // data base to global variable Author
                        authorName = item.englishAuthor!;
                        hindiAuthorName = item.hindiAuthor!;
                        bookImage = item.bookImage!;
                        // data base to global variable For Chapter Count
                        totalChapters = item.chapter;

                        debugPrint(englishTitle);
                        debugPrint(hindiTitle);
                        debugPrint(authorName);
                        debugPrint(hindiAuthorName);
                        debugPrint(bookImage);
                        debugPrint(totalChapters.toString());*/
                        Future.delayed(Duration.zero, () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChapterList(
                                id: item.id!,
                                englishTitle: item.englishTitle!,
                                hindiTitle: item.englishTitle!,
                                authorName: item.englishAuthor!,
                                hindiAuthorName: item.hindiAuthor!,
                                bookImage: item.bookImage!,
                                totalChapters: item.chapter,
                              ),
                            ),
                          ).then(
                            (value) {
                              setState(
                                () {
                                  xOffset = 0;
                                  yOffset = 0;
                                  scaleFactor = 1;
                                  isDrawerOpen = false;
                                  initializeData();
                                },
                              );
                            },
                          );
                        });
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child:Image.asset(
                            "assets/book_images/${item.bookImage}",
                              height: 165,
                              width: 160,
                              fit: BoxFit.fill,
                          ),
                          ),
                          /*Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  () {
                                    if (languageFlag == "en") {
                                      return item.englishTitle!;
                                    } else if (languageFlag == "hi") {
                                      return item.hindiTitle!;
                                    } else {
                                      return item.englishTitle!;
                                    }
                                  }(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: ColorsRes.appColor,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: "Poppins",
                                    fontSize: 18,
                                    height: 1.0,
                                  ),
                                ),
                              ),
                            ],
                          ),*/
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          } else {
            return getProgress();
          }
        },
      ),
    );
  }

//------------------------------------------------------------------------------
//=============================== Build Method ==============================

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: key,
      backgroundColor: darkMode ? Colors.grey[200] : ColorsRes.grey,
      body: SafeArea(
        child: Stack(
          children: [
            mainContainer(),
            blurDesign01(context),
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
                              const SizedBox(
                                width: 10,
                              ),
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
                              darkMode == true
                                  ? Image.asset("assets/images/toggle_light.png")
                                  : Image.asset("assets/images/toggle_dark.png"),
                            ],
                          ),
                          onTap: () {
                            if (darkMode == true) {
                              setState(
                                () {
                                  darkMode = false;
                                  setDarkMode(darkMode);
                                },
                              );
                            } else {
                              setState(
                                () {
                                  darkMode = true;
                                  setDarkMode(darkMode);
                                },
                              );
                            }
                          },
                        ),
                        /*ListTile(
                          title: Row(
                            children: [
                              Image.asset("assets/images/terms_and_conditions_icon.png"),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Text(
                                  DemoLocalization.of(context).translate("Terms & Conditions"),
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
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Terms_Condition(),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          title: Row(
                            children: [
                              Image.asset("assets/images/privacy_policy_icon.png"),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Text(
                                  DemoLocalization.of(context).translate("Privacy Policy"),
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
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Privacy_Policy(),
                              ),
                            );
                          },
                        ),*/
                        ListTile(
                          title: Row(
                            children: [
                              Image.asset("assets/images/rate_us_icon.png"),
                              const SizedBox(
                                width: 10,
                              ),
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
                          onTap: () {
                            LaunchReview.launch(
                              androidAppId: packageName,
                            );
                          },
                        ),
                        ListTile(
                          title: Row(
                            children: [
                              Image.asset("assets/images/share_app.png"),
                              const SizedBox(
                                width: 10,
                              ),
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
                          onTap: () {
                            setState(
                              () {
                                Share.share(
                                    'https://play.google.com/store/apps/details? id=$packageName');
                              },
                            );
                          },
                        ),
                        ListTile(
                          title: Row(
                            children: [
                              Image.asset("assets/images/contactus_icon.png"),
                              const SizedBox(
                                width: 10,
                              ),
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
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ContactUs(),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          title: Row(
                            children: [
                              Image.asset("assets/images/about_us_icon.png"),
                              const SizedBox(
                                width: 10,
                              ),
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
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AboutUs(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            animatedContainer(),
            blurDesign02(context),
            isDrawerOpen
                ? Positioned.directional(
                    textDirection: Directionality.of(context),
                    top: height! * 0.1,
                    start: width! * 0.8,
                    child: GestureDetector(
                      onTap: () {
                        setState(
                          () {
                            xOffset = 0;
                            yOffset = 0;
                            scaleFactor = 1;
                            isDrawerOpen = false;
                          },
                        );
                      },
                      child: Container(
                        width: width! * 0.195,
                        height: height! * 0.79,
                        color: Colors.transparent,
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

// ------------------------------------------------------------------------------
// =============================== Shared Preference ============================

  Future<String> getTitle() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    title = preferences.getString("Title");
    return title ?? "";
  }

  Future<int> getIndicator() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    chapterId = preferences.getInt("In");
    return chapterId ?? 0;
  }
}
