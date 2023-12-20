import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:flutter_screen_wake/flutter_screen_wake.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:launch_review/launch_review.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:srila_prabhupada_books/model/category.dart';
import 'package:srila_prabhupada_books/model/detail.dart';
import '../helper/color_constants.dart';
import '../helper/app_constants.dart';
import '../helper/strings.dart';
import '../model/bookmark.dart';
import '../database/bookmark_database_helper.dart';
import '../database/database_helper.dart';
import '../localization/demo_localization.dart';
import '../widgets/common.dart';
import '../widgets/language_button.dart';
import 'about_us.dart';
import 'contact_us.dart';

// ignore: must_be_immutable
class DetailPage extends StatefulWidget 
{
  int? chapterID;
  DetailPage({super.key, this.chapterID});

  @override
  DetailPageExtended createState() => DetailPageExtended();
}

class DetailPageExtended extends State<DetailPage> with TickerProviderStateMixin, WidgetsBindingObserver 
{
  static final DatabaseHelper instance = DatabaseHelper.privateConstructor();

  final key = GlobalKey<ScaffoldState>();
  BookDetail? bookDetail;
  Books? books;
  double? width, height;
  String? detailText;

// --------------------------- PINNED ------------------------------------------
  
  int? categoryId;
  int catId = 0;
  String pinnedIcon = "pinned_unselected";

  setCategory(int catID) async
  {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt("Category", catID);
  }

  setTitle(String title) async
  {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("Title", title);
  }

  setIndicator() async
  {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setInt("In", categoryId!);
  }

  getIndicator() async
  {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getInt("In");
  }

  // INDICATOR
  setDataIndic() async
  {
    getIndicator().then((value)
    {
      setState(()
      {

        categoryId = value;
        setIconIndic();
      });
    });
  }

  // INDICATOR ICON
  setIconIndic() async
  {
    if (categoryId != bookDetail!.id!)
    {
      setState(() {pinnedIcon = "pinned_unselected";},);
    }
    else
    {
      setState(() {pinnedIcon = "pinned_selected";},);
    }
  }
  
// --------------------------- BOOKMARK ----------------------------------------

  Bookmark? book;
  bool bookmark = true;
  int? bookMarkId;
  String bookmarkIcon = "bookmark_unselected";

  static final BookmarkHelper instance1 = BookmarkHelper.privateConstructor();

  // GET BOOKMARK ICON
  _restoreBookmark() async 
  {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool("bookmark") ?? true;
  }

  // SET BOOKMARK ICON
  _bookmark() async 
  {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setBool("bookmark", bookmark);
  }

  setBookmarkId() async 
  {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setInt("bb", bookMarkId!);
  }

  getBookmarkId() async 
  {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getInt("bb");
  }

  setDataBookmark() async 
  {
    getBookmarkId().then((value)
    {
      setState(()
      {
        bookMarkId = value;
      });
    });
  }

  setDataBookmark1() async 
  {
    _restoreBookmark().then((value)
    {
      setState(()
      {
        bookmark = value;
        setIconBookmark();
      });
    });
  }

  setIconBookmark() async 
  {
    if (bookMarkId == widget.chapterID) 
    {
      if (bookmark) 
      {
        setState(() 
          {
            bookmarkIcon = "bookmark_unselected";
          });
      } 
      else 
      {
        setState(()
        {
          bookmarkIcon = "bookmark_selected";
        });
      }
    }
  }
  
// --------------------------- BRIGHTNESS --------------------------------------

  double brightness = 0.1;

  getBrightnessSlider() async 
  {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.getDouble('brightness');
  }

  brightnessSet() async 
  {
    brightness = await FlutterScreenWake.brightness;
    setState(()
    {
      brightness = brightness;
    });
  }

  Future<void> showBrightness() async 
  {
    return showDialog<void>(
      context: context,
      builder: (_) 
      {
        return FittedBox(
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            backgroundColor: darkMode ? ColorsRes.appColor : ColorsRes.grey,
            insetPadding:
                const EdgeInsets.symmetric(horizontal: 70, vertical: 350),
            content: StatefulBuilder(
              builder: (context, state) => FittedBox(
                child: Column(
                  children: [
                    Text(
                      DemoLocalization.of(context).translate("Brightness"),
                      style: TextStyle(
                        color: ColorsRes.white,fontFamily: "Poppins",
                        fontSize: 20.0,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Slider(
                      value: brightness,
                      divisions: 6,
                      inactiveColor: ColorsRes.white,
                      activeColor: ColorsRes.white,
                      onChanged: (double b) 
                      {
                        state(()
                        {
                          setState(()
                          {
                            brightness = b;
                          });
                          FlutterScreenWake.setBrightness(b);
                        },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  update() 
  {
    setState(() {},);
  }


// --------------------------- FONT COLOR --------------------------------------

  Color? _tempMainColor, _mainColor = darkMode ? Colors.black : Colors.white;

  setColorSlider() async 
  {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setInt('Color', _mainColor!.value);
  }

  getColorSlider() async 
  {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    Color myColor = Color(preferences.getInt('Color') ?? _mainColor!.value);
    return myColor;
  }

  colorPicker() async 
  {
    getColorSlider().then((value)
    {
      setState(()
      {
        _mainColor = value;
      });
    });
  }

  void _fontDialog() async 
  {
    showDialog(context: context,
      builder: (_) 
      {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          backgroundColor: darkMode ? ColorsRes.appColor : ColorsRes.grey,
          title: Text(
            DemoLocalization.of(context).translate("Set color"),
            style: TextStyle(
              fontSize: 18,
              color: ColorsRes.white,fontFamily: "Poppins",
            ),
          ),
          content: SizedBox(
            height: height! * 0.3,
            child: MaterialColorPicker(onMainColorChange: (color) => setState(() => _tempMainColor = color),),
          ),
          actions: [
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: Text(
                DemoLocalization.of(context).translate("Cancel"),
                style: TextStyle(
                  color: ColorsRes.white,fontFamily: "Poppins",
                  fontSize: 18,
                ),
              ),
            ),
            TextButton(
              child: Text(
                DemoLocalization.of(context).translate("Submit"),
                style: TextStyle(
                  color: ColorsRes.white,fontFamily: "Poppins",
                  fontSize: 18,
                ),
              ),
              onPressed: () 
              {
                Navigator.of(context).pop();
                setState(() => _mainColor = _tempMainColor);
                setColorSlider();
              },
            ),
          ],
        );
      },
    );
  }
  
// --------------------------- TEXT SIZE ---------------------------------------

  double _fontSize = 18;

  setFontSlider() async 
  {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setDouble('Font', _fontSize);
  }

  getFontSlider() async 
  {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getDouble('Font');
  }

  fontSize() async 
  {
    getFontSlider().then((value)
    {
      if (value != null)
      {
        setState(()
        {
          _fontSize = value;
        });
      }
    });
  }

  void showFont() async 
  {
    showDialog(context: context,
      builder: (_) 
      {
        return FittedBox(
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            backgroundColor: darkMode ? ColorsRes.appColor : ColorsRes.grey,
            insetPadding:
                const EdgeInsets.symmetric(horizontal: 70, vertical: 300),
            content: StatefulBuilder(
              builder: (context, state) => FittedBox(
                child: Column(
                  children: [
                    Text(
                      DemoLocalization.of(context).translate("Change font Size"),
                      style: TextStyle(
                        color: ColorsRes.white,fontFamily: "Poppins",
                        fontSize: 20,
                      ),
                    ),
                    Slider(
                      label: (_fontSize).toStringAsFixed(0),
                      value: _fontSize,
                      activeColor: ColorsRes.white,
                      min: 15,
                      max: 40,
                      divisions: 10,
                      inactiveColor: ColorsRes.white,
                      onChanged: (value) 
                      {
                        state(() 
                          {
                            setState(() 
                              {
                                _fontSize = value;
                                fontSizeForReadAlong = _fontSize;
                                setFontSlider();
                              },
                            );
                          },
                        );
                      },
                    ),
                    ElevatedButton(
                      onPressed: () 
                      {
                        setFontSlider();
                        Navigator.of(context).pop();
                      },
                      style: const ButtonStyle(),
                      child: Text(
                        DemoLocalization.of(context).translate("Done"),
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
  }
  
// --------------------------- TEXT ALIGNMENT ----------------------------------

  int textAlign = 3;

  setAlignment() async 
  {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt('TEXT ALIGN', textAlign);
  }

  getAlignment() async
  {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getInt('TEXT ALIGN');
  }

  alignment() async
  {
    getAlignment().then((value)
    {
      setState(()
      {
        textAlign = value ?? 3;
      });
    });
  }

  void showTextAlignment() async
  {
    showDialog(
      context: context,
      builder: (_)
      {
        return FittedBox(
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            backgroundColor: darkMode ? ColorsRes.appColor : ColorsRes.grey,
            insetPadding: const EdgeInsets.symmetric(horizontal: 70, vertical: 300),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DemoLocalization.of(context).translate("Change TextAlignment"),
                        style: TextStyle(
                          fontSize: 40,
                          color: ColorsRes.white,fontFamily: "Poppins",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: ()
                    {
                      setState(()
                      {
                        textAlign = 0;
                        setAlignment();
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 50,
                        ),
                        Image.asset(
                          "assets/images/center_align.png",
                          fit: BoxFit.cover,
                          height: 25,
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        Text(
                          DemoLocalization.of(context)
                              .translate("Alignment Center"),
                          style: TextStyle(
                            fontSize: 40,
                            color: ColorsRes.white,fontFamily: "Poppins",
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: ()
                    {
                      setState(()
                      {
                        textAlign = 1;
                        setAlignment();
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 50,
                        ),
                        Image.asset(
                          "assets/images/right_align.png",
                          fit: BoxFit.cover,
                          height: 25,
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        Text(
                          DemoLocalization.of(context).translate("Alignment Right"),
                          style: TextStyle(
                            fontSize: 40,
                            color: ColorsRes.white,fontFamily: "Poppins",
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: ()
                    {
                      setState(()
                      {
                        textAlign = 2;
                        setAlignment();
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 50,
                        ),
                        Image.asset(
                          "assets/images/left_align.png",
                          fit: BoxFit.cover,
                          height: 25,
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        Text(
                          DemoLocalization.of(context).translate("Alignment left"),
                          style: TextStyle(
                            fontSize: 40,
                            color: ColorsRes.white,fontFamily: "Poppins",
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: ()
                    {
                      setState(()
                      {
                        textAlign = 3;
                        setAlignment();
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 50,
                        ),
                        Image.asset(
                          "assets/images/justify_align.png",
                          fit: BoxFit.cover,
                          height: 25,
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        Text(
                          DemoLocalization.of(context).translate("Alignment Justify"),
                          style: TextStyle(
                            fontSize: 40,
                            color: ColorsRes.white,fontFamily: "Poppins",
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


// --------------------------- LINE & LETTER SPACING ---------------------------

  double _lineSpacing = 1;

  //LineSpacing

  setLineSpacingSlider() async
  {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setDouble('LINE SPACING', _lineSpacing);
  }

  getLineSpacingSlider() async
  {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getDouble('LINE SPACING');
  }

  lineSpacingFunction() async
  {
    getLineSpacingSlider().then((value)
    {
      setState(()
      {
        _lineSpacing = value ?? 1;
        lineSpacingForReadAlong = _lineSpacing;
      });
    });
  }

  double letterSpacing = 1;

  setLatterSpacingSlider() async
  {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setDouble('LINE SPACING', letterSpacing);
  }

  getLatterSpacingSlider() async
  {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getDouble('LINE SPACING');
  }

  letterSpacingFunction() async
  {
    getLatterSpacingSlider().then((value)
    {
      setState(()
      {
        letterSpacing = value ?? 1;
      });
    });
  }

  Future lineSpacing() async
  {
    return showDialog<void>(context: context,
      builder: (_)
      {
        return FittedBox(
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            backgroundColor: darkMode ? ColorsRes.appColor : ColorsRes.grey,
            insetPadding:
                const EdgeInsets.symmetric(horizontal: 70, vertical: 350),
            content: StatefulBuilder(
              builder: (context, state) => FittedBox(
                child: Column(
                  children: [
                    Text(
                      DemoLocalization.of(context).translate("Line Spacing"),
                      style: TextStyle(
                        fontSize: 25,
                        color: ColorsRes.white,fontFamily: "Poppins",
                      ),
                    ),
                    const Divider(
                      height: 10,
                    ),
                    Slider(
                      value: _lineSpacing,
                      min: 1,
                      max: 5,
                      inactiveColor: ColorsRes.white,
                      activeColor: ColorsRes.white,
                      onChanged: (double b)
                      {
                        state(()
                        {
                          setState(()
                          {
                            _lineSpacing = b;
                            lineSpacingForReadAlong = _lineSpacing;
                            setLineSpacingSlider();
                          });
                        });
                      }),
                    const Divider(
                      height: 10,
                    ),
                    Text(
                      DemoLocalization.of(context).translate("Letter Spacing"),
                      style: TextStyle(
                        fontSize: 25,
                        color: ColorsRes.white,fontFamily: "Poppins",
                      ),
                    ),
                    const Divider(
                      height: 10,
                    ),
                    Slider(
                      value: letterSpacing,
                      min: 0,
                      max: 4,
                      inactiveColor: ColorsRes.white,
                      activeColor: ColorsRes.white,
                      onChanged: (double b)
                      {
                        state(()
                        {
                          setState(()
                          {
                            letterSpacing = b;
                            letterSpacingForReadAlong = letterSpacing;
                            setLatterSpacingSlider();
                          });
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }


// --------------------------- AUTO SCROLL -------------------------------------

  bool isVisible = false;
  final ScrollController _scrollController = ScrollController();
  double speedFactor = 15;
  bool scrollText = true, scroll = false;
  bool navbarVisible = false;


  _scroll()
  {
    double maxExtent = _scrollController.position.maxScrollExtent;
    double distanceDifference = maxExtent - _scrollController.offset;
    double durationDouble = distanceDifference / speedFactor;

    _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: Duration(seconds: durationDouble.toInt()), curve: Curves.linear);
  }

  _toggleScrolling()
  {
    setState(()
    {
      scroll = !scroll;
    });

    if (scroll)
    {
      _scroll();
    }
    else
    {
      _scrollController.animateTo(_scrollController.offset, duration: const Duration(seconds: 10), curve: Curves.linear);
    }
  }


// --------------------------- TEXT TO SPEECH ----------------------------------

  final FlutterTts flutterTextToSpeech = FlutterTts();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async
  {
    super.didChangeAppLifecycleState(state);
    switch (state)
    {
      case AppLifecycleState.inactive:
        await flutterTextToSpeech.stop();
        setState(()
        {
          play = false;
        });
        break;
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;
  bool play = false;

  Future textToSpeech() async
  {
    return showDialog<void>(
      context: context,
      builder: (_)
      {
        return FittedBox(
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            backgroundColor: darkMode ? ColorsRes.appColor : ColorsRes.grey,
            insetPadding: const EdgeInsets.symmetric(horizontal: 70, vertical: 350),
            content: StatefulBuilder(
              builder: (context, state) => FittedBox(
                child: Column(
                  children: [
                    Text(
                      "Volume",
                      style: TextStyle(
                        fontSize: 25,
                        color: ColorsRes.white,fontFamily: "Poppins",
                      ),
                    ),
                    const Divider(
                      height: 10,
                    ),
                    Slider(
                      value: volume,
                      min: 0.0,
                      max: 1.0,
                      inactiveColor: ColorsRes.white,
                      activeColor: ColorsRes.white,
                      onChanged: (double newVolume)
                      {
                        state(()
                        {
                          setState(()
                          {
                            volume = newVolume;
                          });
                        });
                      }),
                    const Divider(
                      height: 10,
                    ),
                    Text(
                      "Pitch",
                      style: TextStyle(
                        fontSize: 25,
                        color: ColorsRes.white,fontFamily: "Poppins",
                      ),
                    ),
                    const Divider(
                      height: 10,
                    ),
                    Slider(
                      value: pitch,
                      min: 0.5,
                      max: 2.0,
                      inactiveColor: ColorsRes.white,
                      activeColor: ColorsRes.white,
                      onChanged: (double changePitch)
                      {
                        state(()
                        {
                          setState(()
                          {
                            pitch = changePitch;
                          });
                        });
                      }),
                    Text(
                      "Rate",
                      style: TextStyle(
                        fontSize: 25,
                        color: ColorsRes.white,fontFamily: "Poppins",
                      ),
                    ),
                    const Divider(
                      height: 10,
                    ),
                    Slider(
                      value: rate,
                      min: 0.0,
                      max: 1.0,
                      inactiveColor: ColorsRes.white,
                      activeColor: ColorsRes.white,
                      onChanged: (double changeRate)
                      {
                        state(()
                        {
                          setState(()
                          {
                            rate = changeRate;
                          });
                        });
                      }),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

// --------------------------- READ ALONG WITH TEXT ----------------------------

  bool readAlongTextOn = false;
  int currentLine = -1;
  List<LineMetrics> lineMetrics = [];
  final List<TextSpan> children = [];
  Timer? timer;
  List<AnimationController> animationControllers = [];
  int milliseconds = 5000;

  void getLineMatrix()
  {
    final textPainter = TextPainter(
        text: TextSpan(
          text: detailText,
          style: TextStyle(
            fontSize: fontSizeForReadAlong,
            color: Colors.black,fontFamily: "Poppins",
            letterSpacing: letterSpacingForReadAlong,
            height: lineSpacingForReadAlong,
          ),
        ),
        textDirection: TextDirection.ltr);
    textPainter.layout(maxWidth: MediaQuery.of(context).size.width);
    setState(()
    {
      lineMetrics = textPainter.computeLineMetrics();
      currentLine = 0;
      for (int i = 0; i > lineMetrics.length; i++)
      {
        animationControllers.add(AnimationController(vsync: this, duration: Duration(milliseconds: milliseconds)));
      }
    });
    animationControllers.first.forward();
    timer = Timer.periodic(Duration(milliseconds: milliseconds + 150), (timer)
    {
      if (currentLine == (lineMetrics.length - 1))
      {
        timer.cancel();
      }
      else
      {
        currentLine++;
        animationControllers[currentLine].forward();
      }
    });
  }

  @override
  void dispose()
  {
    timer?.cancel();
    for (var element in animationControllers)
    {
      element.dispose();
    }
    super.dispose();
    flutterTextToSpeech.stop();
  }

  Widget _buildBackgroundHighlightContainers()
  {
    return currentLine == -1
        ? Container()
        : Positioned(
            left: 0.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: lineMetrics.map((e)
              {
                  return AnimatedBuilder(
                    animation: animationControllers[e.lineNumber],
                    builder: (context, child)
                    {
                      return Container(
                        height: e.height,
                        width: width! * animationControllers[e.lineNumber].value,
                        color: darkMode ? ColorsRes.textColor : ColorsRes.appColor,
                      );
                    });
                },
              ).toList(),
            ),
          );
  }

  void readAlongWithText() async
  {
    showDialog(
      context: context,
      builder: (_)
      {
        return FittedBox(
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            backgroundColor: darkMode ? ColorsRes.appColor : ColorsRes.grey,
            insetPadding: const EdgeInsets.symmetric(horizontal: 70, vertical: 300),
            content: StatefulBuilder(
              builder: (context, state) => FittedBox(
                child: Column(
                  children: [
                    Text(
                      DemoLocalization.of(context).translate("Adjust Speed"),
                      style: TextStyle(color: ColorsRes.white,fontFamily: "Poppins", fontSize: 20),
                    ),
                    const SizedBox(height: 20),
                    Slider(
                      label: DemoLocalization.of(context).translate("Decrement ->"),
                      value: (milliseconds).toDouble(),
                      activeColor: ColorsRes.white,
                      min: 2000,
                      max: 8000,
                      divisions: 7,
                      inactiveColor: ColorsRes.white,
                      onChanged: (value)
                      {
                        state(()
                        {
                          setState(()
                          {
                            milliseconds = (value).toInt();
                          });
                        });
                      }),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: ()
                      {
                        readAlongTextOn = true;
                        Navigator.of(context).pop();
                        getLineMatrix();
                      },
                      style: const ButtonStyle(),
                      child: Text(DemoLocalization.of(context).translate("Start")),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

// --------------------------- RESET -------------------------------------------

  resets() async
  {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove('COLOR');
    await preferences.remove('FONT');
    await preferences.remove('BRIGHTNESS');
    await preferences.remove('LINE SPACING');
    await preferences.remove('LETTER SPACING');
    setState(()
    {
      _mainColor = darkMode ? ColorsRes.black : Colors.white; //Colors.black;
      _fontSize = 18;
      FlutterScreenWake.setBrightness(0.03);
      _lineSpacing = 1;
      letterSpacing = 1;
      textAlign = 3;
      navbarVisible = false;
      pitch = 1.0;
      volume = 0.5;
      rate = 0.5;
      play = false;
      currentLine = -1;
      milliseconds = 5000;
      flutterTextToSpeech.stop();
    });
  }

  void reset() async
  {
    showDialog(
      context: context,
      builder: (_)
      {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          backgroundColor: darkMode ? ColorsRes.appColor : ColorsRes.grey,
          insetPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 100),
          title: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: DemoLocalization.of(context).translate("Conform Reset operations"),
              style: TextStyle(
                color: ColorsRes.white,fontFamily: "Poppins",
                fontSize: 20,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: DemoLocalization.of(context).translate("Are you sure"),
                  style: TextStyle(
                    color: ColorsRes.white,fontFamily: "Poppins",
                    fontSize: 18,
                  ),
                )
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: Text(
                DemoLocalization.of(context).translate("No"),
                style: TextStyle(fontFamily: "Poppins",
                  color: ColorsRes.white,
                  fontSize: 18,
                ),
              ),
            ),
            TextButton(
              child: Text(
                DemoLocalization.of(context).translate("Yes"),
                style: TextStyle(
                  color: ColorsRes.white,fontFamily: "Poppins",
                  fontSize: 18,
                ),
              ),
              onPressed: ()
              {
                Navigator.of(context).pop();
                resets();
              },
            ),
          ],
        );
      },
    );
  }

// --------------------------- SEARCH LOGIC ------------------------------------

  TextEditingController textController = TextEditingController();
  bool typing = false;
  String? source, query;

  List<TextSpan> highlightOccurrences(source, query)
  {
    if (query == null || query.isEmpty)
    {
      return [TextSpan(text: source)];
    }

    var matches = <Match>[];
    for (final token in query.trim().toLowerCase().split(' '))
    {
      matches.addAll(token.allMatches(source.toLowerCase(),),);
    }
    if (matches.isEmpty)
    {
      return [TextSpan(text: source),];
    }
    matches.sort((a, b) => a.start.compareTo(b.start),);
    int lastMatchEnd = 0;
    final List<TextSpan> children = [];
    for (final match in matches)
    {
      if (match.end <= lastMatchEnd)
      {

      }
      else if (match.start <= lastMatchEnd)
      {
        children.add(TextSpan(text: source.substring(lastMatchEnd, match.end,), style: TextStyle(backgroundColor: ColorsRes.appColor,fontFamily: "Poppins", color: Colors.white,),),);
      }
      else if (match.start > lastMatchEnd)
      {
        children.add(TextSpan(text: source.substring(lastMatchEnd, match.start,),),);

        children.add(TextSpan(text: source.substring(match.start, match.end), style: TextStyle(backgroundColor: ColorsRes.appColor,fontFamily: "Poppins", color: Colors.white,),),);
      }

      if (lastMatchEnd < match.end)
      {
        lastMatchEnd = match.end;
      }
    }
    if (lastMatchEnd < source.length)
    {
      children.add(TextSpan(text: source.substring(lastMatchEnd, source.length,),),);
    }
    return children;
  }

// --------------------------------- MAIN CODE STARTED -------------------------

  @override
  initState()
  {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    brightnessSet();
    setDataIndic();
    setState(()
    {
      instance.getChapterDescription(widget.chapterID!).then((value)
      {
        bookDetail = value;
      });
    });

    setState(()
    {
      instance.getBook(bookDetail!.bookID!).then((value)
      {
        books = value;
      });
    });
    setDataBookmark();
    setDataBookmark1();
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    getBrightnessSlider();
    colorPicker();
    fontSize();
    alignment();
    lineSpacingFunction();
    letterSpacingFunction();
    
    _scrollController.addListener(()
    {
      setState(()
      {
        isVisible = _scrollController.position.userScrollDirection == ScrollDirection.forward;
      });
    });
  }

  @override
  Widget build(BuildContext context)
  {

// --------------------- TEXT TO AUDIO ---------------------------------

    speak(String description) async {
      await flutterTextToSpeech.setVolume(volume);
      await flutterTextToSpeech.setSpeechRate(rate);
      await flutterTextToSpeech.setPitch(pitch);
      await flutterTextToSpeech.getLanguages;
      await flutterTextToSpeech.setLanguage(()

      {
        if (languageFlag == "hi")
        {
          return "hi-IN";
        }
        else if (languageFlag == "en")
        {
          return "en-IN";
        }
        else
        {
          return "en-US";
        }
      }());
      int length = description.length;
      if (length < 4000)
      {
        await flutterTextToSpeech.awaitSpeakCompletion(true);
        await flutterTextToSpeech.speak(description);
        flutterTextToSpeech.setCompletionHandler(()
        {
          flutterTextToSpeech.stop();
          play = false;
        });
      }
      else if (length < 8000)
      {
        String temp1 = description.substring(0, length ~/ 2);
        await flutterTextToSpeech.awaitSpeakCompletion(true);
        await flutterTextToSpeech.speak(temp1);
        flutterTextToSpeech.setCompletionHandler(() {});
        String temp2 = description.substring(temp1.length, description.length);
        await flutterTextToSpeech.speak(temp2);flutterTextToSpeech.setCompletionHandler(() {play = false;});
      }
      else if (length < 12000)
      {
        String temp1 = description.substring(0, 3999);
        await flutterTextToSpeech.awaitSpeakCompletion(true);
        await flutterTextToSpeech.speak(temp1);
        flutterTextToSpeech.setCompletionHandler(() {});
        String temp2 = description.substring(temp1.length, 7999);
        await flutterTextToSpeech.speak(temp2);
        flutterTextToSpeech.setCompletionHandler(() {});
        String temp3 = description.substring(temp2.length, description.length);
        await flutterTextToSpeech.speak(temp3);
        flutterTextToSpeech.setCompletionHandler(()
        {
          play = false;
        });
      }
    }

    stop() async
    {
      await flutterTextToSpeech.stop();
    }

// --------------------- BODY PART STARTS HERE ---------------------------------

    return Scaffold(
      key: key,
      backgroundColor: ColorsRes.white,
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
                              const SizedBox(width: 10),
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
                            setState(() {Share.share('https://play.google.com/store/apps/details? id=$packageName');});
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
                              const SizedBox(width: 10,),
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
              duration: const Duration(milliseconds: 250),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              transform: Matrix4.translationValues(xOffset, yOffset, 0)..scale(scaleFactor)..rotateY(isDrawerOpen ? -0.5 : 0),
              decoration: BoxDecoration(
                color: darkMode ? Colors.grey[100] : ColorsRes.grey, //grey1
                boxShadow: [
                  BoxShadow(
                    blurRadius: 60,
                    color: ColorsRes.appColor.withOpacity(0.9),
                    offset: const Offset(1, 3),
                  ),
                ], //
                borderRadius: BorderRadius.circular(isDrawerOpen ? 40 : 0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(isDrawerOpen ? 40 : 0),
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
                                                  icon: Image.asset(
                                                    "assets/images/menu_icon.png",
                                                  ),
                                                  onPressed: ()
                                                  {
                                                    setState(()
                                                    {
                                                      xOffset = 0;
                                                      yOffset = 0;
                                                      scaleFactor = 1;
                                                      isDrawerOpen = false;
                                                    });
                                                  },
                                                )
                                              : IconButton(
                                                  icon: Image.asset("assets/images/menu_icon.png",),
                                                  onPressed: ()
                                                  {
                                                    setState(()
                                                    {
                                                      xOffset = width! * 0.8;
                                                      yOffset = height! * 0.1;
                                                      scaleFactor = 0.8;
                                                      isDrawerOpen = true;
                                                      navbarVisible = false;
                                                    });
                                                  },
                                                ),
                                          typing
                                              ? Container(
                                                  height: height! * 0.055,
                                                  width: width! * 0.5,
                                                  margin: const EdgeInsets.only(top: 5),
                                                  child: Center(
                                                    child: TextField(
                                                      style: TextStyle(color: darkMode ? ColorsRes.appColor : ColorsRes.white,fontFamily: "Poppins", fontSize: 18),
                                                      cursorColor: ColorsRes.appColor,
                                                      autofocus: true,
                                                      controller: textController,
                                                      decoration: InputDecoration(
                                                        border: InputBorder.none,
                                                        hintText: DemoLocalization.of(context).translate("Search"),
                                                        hintStyle: TextStyle(color: ColorsRes.appColor,fontFamily: "Poppins", fontSize: 18),
                                                      ),
                                                      onChanged: (text)
                                                      {
                                                        text = text.toLowerCase();
                                                        setState(()
                                                        {
                                                          query = text;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                )
                                              : Text(
                                                  DemoLocalization.of(context).translate("appName"),
                                                  style: TextStyle(
                                                      fontSize: 25,
                                                      color: ColorsRes.appColor,
                                                      fontFamily: "Poppins",
                                                      fontWeight: FontWeight.w500),
                                                ),
                                          IconButton(
                                            icon: typing ? Icon(Icons.clear, color: ColorsRes.appColor) : Image.asset("assets/images/search_icon.png"),
                                            onPressed: ()
                                            {
                                              textController.clear();
                                              query = "";
                                              setState(()
                                              {
                                                typing = !typing;
                                              });
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
                                              return bookDetail!.bookTitle ?? "";
                                            }
                                            else if (languageFlag == "hi")
                                            {
                                              return bookDetail!.hindiBookTitle ?? "";
                                            }
                                            else
                                            {
                                              return bookDetail!.bookTitle ?? "";
                                            }
                                          }(),
                                          maxLines: 1,
                                          style: TextStyle(
                                            color: ColorsRes.appColor,
                                            fontSize: 20,
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
                                              return "Srila Prabhupada";
                                            }
                                            else if (languageFlag == "hi")
                                            {
                                              return "श्रील प्रभुपाद";
                                            }
                                            else
                                            {
                                              return "Srila Prabhupada";
                                            }
                                          }(),
                                          style: TextStyle(color: darkMode ? ColorsRes.appColor : ColorsRes.white, fontFamily: "Poppins"),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 12.0,
                                          right: 12.0,
                                        ),
                                        child: Text(
                                          "${bookDetail!.totalChapters} ${DemoLocalization.of(context).translate("Chapters")}",
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
                            top: height! * 0.128,
                            start: width! * 0.675,
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: Image.asset(
                                    "assets/book_images/${books!.bookImage}",
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
                            top: width! * 0.54,
                            start: width! * 0.02,
                            child: LanguageWidget(
                              update: update,
                              fromHome: false,
                            ),
                          ),
                          Positioned.directional(
                            textDirection: Directionality.of(context),
                            top: width! * 0.54,
                            start: width! * 0.235,
                            child: GestureDetector(
                              onTap: ()
                              {
                                if (bookMarkId == widget.chapterID)
                                {
                                  if (bookmark)
                                  {
                                    bookmark = false;
                                    setBookmarkId();
                                    _bookmark();
                                    setIconBookmark();
                                    instance1.bookMarkBook(widget.chapterID!);
                                  }
                                  else
                                  {
                                    bookmark = true;
                                    _bookmark();
                                    setBookmarkId();
                                    setIconBookmark();

                                    instance1.deleteBookFromBookMark(widget.chapterID!);
                                  }
                                }
                              },
                              child: Container(
                                height: height! * 0.055,
                                width: width! * 0.20,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: ColorsRes.appColor,
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 10,
                                        right: 4,
                                      ),
                                      child: Image.asset(
                                        "assets/images/$bookmarkIcon.png",
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        DemoLocalization.of(context).translate("bookMark"),
                                        style: Theme.of(context).textTheme.labelLarge!.merge(
                                              TextStyle(
                                                color: ColorsRes.textColor,
                                                fontSize: 8,
                                                fontFamily: "Poppins-ExtraLight",
                                              ),
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
                            top: width! * 0.54,
                            start: width! * 0.45,
                            child: GestureDetector(
                              onTap: ()
                              {
                                if (categoryId == widget.chapterID)
                                {
                                  setIndicator();
                                  setIconIndic();
                                  setCategory(catId);
                                  setTitle(bookDetail!.bookTitle!);
                                  if (mounted)
                                  {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        margin: EdgeInsets.all(70),
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(50),
                                          ),
                                        ),
                                        duration: Duration(seconds: 1),
                                        content: Text(
                                          "Indicator set Successful !",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontFamily: 'Times new Roman'),
                                        ),
                                      ),
                                    );
                                  }
                                }
                                else
                                {
                                  setIndicator();
                                  setState(()
                                    {
                                      getIndicator();
                                      setIconIndic();
                                    },
                                  );
                                  if (mounted)
                                  {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        margin: EdgeInsets.all(70),
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
                                        duration: Duration(seconds: 1),
                                        content: Text(
                                          "Remove  Successful !",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontFamily: 'Times new Roman'),
                                        ),
                                      ),
                                    );
                                  }
                                }
                              },
                              child: Container(
                                height: height! * 0.055,
                                width: width! * 0.20,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: ColorsRes.appColor,
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 10,
                                        right: 4,
                                      ),
                                      child: Image.asset(
                                        "assets/images/$pinnedIcon.png",
                                      ),
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
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: bookNotComplete
                            ? FutureBuilder(
                                future: instance.getChapterDescription(widget.chapterID!),
                                builder: (BuildContext context, AsyncSnapshot snapshot)
                                {
                                  if (snapshot.hasData)
                                  {
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      itemCount: snapshot.data.length,
                                      itemBuilder:(BuildContext context, int index)
                                    {
                                        bookDetail = snapshot.data[index];
                                        catId = bookDetail!.bookID!;
                                        categoryId = bookDetail!.id!;
                                        bookMarkId = bookDetail!.id!;
                                        return Column(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius: const BorderRadius.only(
                                                  topRight: Radius.circular(30.0),
                                                  topLeft: Radius.circular(30.0),
                                                  bottomLeft: Radius.circular(30.0),
                                                  bottomRight: Radius.circular(30.0),
                                                ),
                                                color: darkMode ? ColorsRes.white : ColorsRes.grey1, //for detail
                                              ),
                                              child: ListTile(
                                                title: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Column(
                                                      children:
                                                      [
                                                        const SizedBox(height: 20),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Expanded(
                                                              child: Text(()
                                                              {
                                                                  if (languageFlag == "en")
                                                                  {
                                                                    return bookDetail!.chapterName!;
                                                                  }
                                                                  else if (languageFlag == "hi")
                                                                  {
                                                                    return bookDetail!.hindiChapterName!;
                                                                  }
                                                                  else
                                                                  {
                                                                    return bookDetail!.chapterName!;
                                                                  }
                                                                }(),
                                                                style: TextStyle(
                                                                  fontSize: 16,
                                                                  color: ColorsRes.appColor,
                                                                  fontFamily: 'Poppins',
                                                                  fontWeight: FontWeight.w500,
                                                                ),
                                                              ),
                                                            ),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                              children: [
                                                                GestureDetector(
                                                                  child: Image.asset("assets/images/setting_icon.png"),
                                                                  onTap: ()
                                                                  {
                                                                    if (readAlongTextOn == true)
                                                                    {
                                                                      setState(()
                                                                      {
                                                                          readAlongTextOn = false;
                                                                          timer?.cancel();
                                                                          for (var element in animationControllers)
                                                                          {
                                                                            element.reset();
                                                                          }
                                                                        },
                                                                      );
                                                                    }
                                                                    showMenu<String>(
                                                                      color: darkMode ? ColorsRes.appColor : ColorsRes.grey,
                                                                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
                                                                      context: context,
                                                                      position: RelativeRect.fromLTRB(width!, width!, 0.0, 0.0),
                                                                      items: [
                                                                        PopupMenuItem<String>(
                                                                            value: '0',
                                                                            child: Row(
                                                                              children: [
                                                                                Image.asset("assets/images/brightness_icon.png"),
                                                                                const SizedBox(width: 35,),
                                                                                Expanded(
                                                                                  child: Text(
                                                                                    DemoLocalization.of(context).translate("Brightness"),
                                                                                    style: const TextStyle(color: Colors.white, fontFamily: "Poppins"),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            )
                                                                        ),
                                                                        PopupMenuItem<String>(
                                                                            value: '1',
                                                                            child: Row(
                                                                              children:
                                                                              [
                                                                                Image.asset("assets/images/font_color_icon.png"),
                                                                                const SizedBox(width: 35,),
                                                                                Expanded(
                                                                                  child: Text(
                                                                                    DemoLocalization.of(context).translate("Font color"),
                                                                                    style: const TextStyle(color: Colors.white, fontFamily: "Poppins"),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            )
                                                                        ),
                                                                        PopupMenuItem<String>(
                                                                            value: '2',
                                                                            child: Row(
                                                                              children: [
                                                                                Image.asset("assets/images/text_size_icon.png"),
                                                                                const SizedBox(width: 35,),
                                                                                Expanded(
                                                                                  child: Text(
                                                                                    DemoLocalization.of(context).translate("Text Size"),
                                                                                    style: const TextStyle(color: Colors.white, fontFamily: "Poppins"),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            )
                                                                        ),
                                                                        PopupMenuItem<String>(
                                                                            value: '3',
                                                                            child: Row(
                                                                              children: [
                                                                                Image.asset("assets/images/text_alignment_icon.png"),
                                                                                const SizedBox(width: 35,),
                                                                                Expanded(
                                                                                  child: Text(
                                                                                    DemoLocalization.of(context).translate("Text Alignment"),
                                                                                    style: const TextStyle(color: Colors.white, fontFamily: "Poppins"),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            )
                                                                        ),
                                                                        PopupMenuItem<String>(
                                                                            value: '4',
                                                                            child: Row(
                                                                              children: [
                                                                                Image.asset("assets/images/loose_icon.png"),
                                                                                const SizedBox(width: 35,),
                                                                                Expanded(
                                                                                  child: Text(
                                                                                    DemoLocalization.of(context).translate("Line Spacing"),
                                                                                    style: const TextStyle(color: Colors.white, fontFamily: "Poppins"),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            )
                                                                        ),
                                                                        PopupMenuItem<String>(
                                                                            value: '5',
                                                                            child: Row(
                                                                              children: [
                                                                                Image.asset("assets/images/scroll_icon.png"),
                                                                                const SizedBox(width: 35,),
                                                                                Expanded(
                                                                                  child: Text(
                                                                                    DemoLocalization.of(context).translate("Auto Scroll"),
                                                                                    style: const TextStyle(color: Colors.white, fontFamily: "Poppins"),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            )
                                                                        ),
                                                                        PopupMenuItem<String>(
                                                                            value: '6',
                                                                            child: Row(
                                                                              children: [
                                                                                Image.asset("assets/images/text_speech_icon.png"),
                                                                                const SizedBox(width: 35,),
                                                                                Expanded(
                                                                                  child: Text(
                                                                                    DemoLocalization.of(context).translate("Text To Speech"),
                                                                                    style: const TextStyle(color: Colors.white, fontFamily: "Poppins"),
                                                                                  ),
                                                                                ),
                                                                                play
                                                                                    ? AbsorbPointer(
                                                                                        absorbing: false,
                                                                                        child: GestureDetector(
                                                                                          child: Image.asset("assets/images/toggle_on.png",),
                                                                                          onTap: ()
                                                                                          {
                                                                                            setState(()
                                                                                            {
                                                                                              play = false;
                                                                                              stop();
                                                                                              Navigator.pop(context);
                                                                                            });
                                                                                          },
                                                                                        ),
                                                                                      )
                                                                                    : AbsorbPointer(
                                                                                        absorbing: false,
                                                                                        child: GestureDetector(
                                                                                          child: Image.asset("assets/images/toggle_off.png",),
                                                                                          onTap: ()
                                                                                          {
                                                                                            setState(()
                                                                                              {
                                                                                                speak(()
                                                                                                {
                                                                                                  if (languageFlag == "en")
                                                                                                  {
                                                                                                    return bookDetail!.description!;
                                                                                                  }
                                                                                                  else if (languageFlag == "hi")
                                                                                                  {
                                                                                                    return bookDetail!.hindiDescription!;
                                                                                                  }
                                                                                                  else
                                                                                                  {
                                                                                                    return bookDetail!.description!;
                                                                                                  }
                                                                                                }());
                                                                                                play = true;
                                                                                                Navigator.pop(context);
                                                                                              },
                                                                                            );
                                                                                          },
                                                                                        ),
                                                                                      ),
                                                                              ],
                                                                            )
                                                                        ),
                                                                        PopupMenuItem<String>(
                                                                            value: '7',
                                                                            child: Row(
                                                                              children: [
                                                                                Image.asset("assets/images/read_along_icon.png"),
                                                                                const SizedBox(width: 35),
                                                                                Expanded(
                                                                                  child: Text(
                                                                                    DemoLocalization.of(context).translate("Read Along Text"),
                                                                                    style: const TextStyle(color: Colors.white, fontFamily: "Poppins"),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            )
                                                                        ),
                                                                        PopupMenuItem<String>(
                                                                          value: '8',
                                                                          child: Row(
                                                                            children: [
                                                                              const Icon(
                                                                                Icons.settings,
                                                                                color: Colors.white,
                                                                                size: 22,
                                                                              ),
                                                                              const SizedBox(width: 35),
                                                                              Expanded(
                                                                                child: Text(
                                                                                  DemoLocalization.of(context).translate("Reset"),
                                                                                  style: const TextStyle(color: Colors.white, fontFamily: "Poppins"),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                      elevation: 7.0,
                                                                    ).then<void>((String?itemSelected)
                                                                    {
                                                                        if (itemSelected == null)
                                                                        {
                                                                          return;
                                                                        }
                                                                        if (itemSelected == "0")
                                                                        {
                                                                          showBrightness();
                                                                        }
                                                                        else if (itemSelected == "1")
                                                                        {
                                                                          _fontDialog();
                                                                          setState(() {});
                                                                        }
                                                                        else if (itemSelected == "2")
                                                                        {
                                                                          showFont();
                                                                        }
                                                                        else if (itemSelected == "3")
                                                                        {
                                                                          showTextAlignment();
                                                                        }
                                                                        else if (itemSelected == "4")
                                                                        {
                                                                          lineSpacing();
                                                                        }
                                                                        else if (itemSelected == "5")
                                                                        {
                                                                          setState(()
                                                                          {
                                                                              currentLine = -1;
                                                                              if (navbarVisible)
                                                                              {
                                                                                setState(()
                                                                                {
                                                                                  navbarVisible = false;
                                                                                });
                                                                              }
                                                                              else
                                                                              {
                                                                                setState(()
                                                                                {
                                                                                  navbarVisible = true;
                                                                                });
                                                                              }
                                                                            },
                                                                          );
                                                                        }
                                                                        else if (itemSelected == "6")
                                                                        {
                                                                          textToSpeech();
                                                                        }
                                                                        else if (itemSelected == "7")
                                                                        {
                                                                          setState(()
                                                                          {
                                                                            textAlign = 3;
                                                                          });
                                                                          setState(() {});
                                                                          readAlongWithText();
                                                                        }
                                                                        else if (itemSelected == "8")
                                                                        {
                                                                          reset();
                                                                        }
                                                                      },
                                                                    );
                                                                  },
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                        const SizedBox(height: 20,),
                                                        Stack(
                                                          children: [
                                                            _buildBackgroundHighlightContainers(),
                                                            RichText(
                                                              textAlign: (()
                                                              {
                                                                if (textAlign == 0)
                                                                {
                                                                  return TextAlign.center;
                                                                }
                                                                else if (textAlign == 1)
                                                                {
                                                                  return TextAlign.right;
                                                                }
                                                                else if (textAlign == 2)
                                                                {
                                                                  return TextAlign.left;
                                                                }
                                                                else if (textAlign == 3)
                                                                {
                                                                  return TextAlign.justify;
                                                                }
                                                                else
                                                                {
                                                                  return TextAlign.justify;
                                                                }
                                                              }()),
                                                              text: TextSpan(
                                                                children: highlightOccurrences(()
                                                                {
                                                                  if (languageFlag == "en")
                                                                  {
                                                                    detailText = bookDetail!.description!;
                                                                    return bookDetail!.description!;
                                                                  }
                                                                  else if (languageFlag == "hi")
                                                                  {
                                                                    detailText = bookDetail!.hindiDescription!;
                                                                    return bookDetail!.hindiDescription!;
                                                                  }
                                                                  else
                                                                  {
                                                                    detailText = bookDetail!.description!;
                                                                    return bookDetail!.description!;
                                                                  }
                                                                }(), query),
                                                                style: TextStyle(
                                                                  fontSize: _fontSize,
                                                                  color: _mainColor ?? Colors.black, fontFamily: "Poppins",
                                                                  height: _lineSpacing,
                                                                  letterSpacing: letterSpacing,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: GestureDetector(
                                                onTap: () 
                                                {
                                                  if (bookDetail!.totalChapters! < bookDetail!.totalChapters!)
                                                  {
                                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DetailPage(chapterID: (bookDetail!.id!) + 1, /* title: bookDetail!.chapterName!, */),),).then((value) {
                                                      setState(()
                                                      {
                                                        bookNotComplete = false;
                                                      });
                                                    });
                                                  }
                                                  else
                                                  {
                                                    setState(()
                                                    {
                                                      bookNotComplete = false;
                                                    });
                                                  }
                                                },
                                                child: Container(
                                                  width: width! * 0.7,
                                                  height: width! * 0.15,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                    color: ColorsRes.appColor,
                                                  ),
                                                  child: Center(
                                                    child: Text(DemoLocalization.of(context).translate("Next Chapter >>>"),
                                                      style: TextStyle(
                                                        fontSize: width! * 0.06,
                                                        fontWeight: FontWeight.bold,fontFamily: "Poppins",
                                                        color: ColorsRes.textColor,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                  else
                                  {
                                    return const Center(child: CircularProgressIndicator());
                                  }
                                },
                              )
                            : Column(
                                children: [
                                  Center(
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(child: Lottie.asset("assets/images/clapping_animation.json")),
                                            Text(
                                              DemoLocalization.of(context).translate("Congratulation!!!"),
                                              style: TextStyle(
                                                fontSize: 25,
                                                color: ColorsRes.appColor,
                                                fontWeight: FontWeight.w700,fontFamily: "Poppins",
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            Expanded(child: Lottie.asset("assets/images/clapping_animation.json")),
                                          ],
                                        ),
                                        Text(
                                          DemoLocalization.of(context).translate("You Have Complete this book. "),
                                          style: TextStyle(fontSize: 14,fontFamily: "Poppins", color: darkMode ? Colors.grey[600] : ColorsRes.white),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: height! * 0.40,
                                    width: width,
                                    child: Lottie.asset("assets/images/online_class_animation.json",),
                                  ),
                                  Text(
                                    DemoLocalization.of(context).translate("Now Time To Explore Other Book's"),
                                    style: TextStyle(
                                      fontSize: 14, fontFamily: "Poppins",
                                      color: darkMode ? Colors.grey[600] : ColorsRes.white,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: ()
                                    {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.all(10),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10,),
                                        color: ColorsRes.appColor,
                                      ),
                                      child: Text(
                                        DemoLocalization.of(context).translate("Explore Now"),
                                        style: TextStyle(color: ColorsRes.textColor,fontFamily: "Poppins"),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            isDrawerOpen
                ? Positioned.directional(
                    textDirection: Directionality.of(context),
                    top: height! * 0.0,
                    start: width! * 0.75,
                    child: Container(width: width! * 0.25, height: height, color: Colors.white.withOpacity(0.3)),
                  )
                : Container(),
            isDrawerOpen
                ? Positioned.directional(
                    textDirection: Directionality.of(context),
                    top: height! * 0.1,
                    start: width! * 0.8,
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: readAlongTextOn
          ? FloatingActionButton(
              isExtended: true,
              backgroundColor: ColorsRes.appColor,
              onPressed: ()
              {
                setState(()
                {
                  readAlongTextOn = false;
                  timer?.cancel();
                  for (var element in animationControllers)
                  {
                    element.reset();
                  }
                });
              },
              child: const Text("STOP"),
            )
          : Container(),
      bottomNavigationBar: navbarVisible
          ? Container(
              color: darkMode ? ColorsRes.white : ColorsRes.grey1,
              child: Container(
                width: width,
                height: height! * 0.11,
                decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 15.0,
                        spreadRadius: -5,
                      ),
                    ],
                    color: darkMode ? ColorsRes.white : ColorsRes.grey,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    )),
                child: Row(
                  children: [
                    SizedBox(width: width! * 0.04,),
                    GestureDetector(
                      onTap: ()
                      {
                        setState(()
                        {
                          _toggleScrolling();
                          if (scrollText)
                          {
                            scrollText = false;
                          }
                          else
                          {
                            scrollText = true;
                          }
                        },
                        );
                      },
                      child: scrollText ? Image.asset("assets/images/play_icon.png") : Image.asset("assets/images/pause_icon.png"),
                    ),
                    SizedBox(
                      width: width! * 0.87,
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: ColorsRes.appColor,
                          inactiveTrackColor: ColorsRes.appColor,
                          trackShape: const RectangularSliderTrackShape(),
                          trackHeight: 4.0,
                          thumbColor: ColorsRes.appColor,
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.0),
                          overlayColor: ColorsRes.appColor,
                          overlayShape: const RoundSliderOverlayShape(overlayRadius: 28.0),
                        ),
                        child: Slider(
                          inactiveColor: ColorsRes.textColor,
                          value: speedFactor,
                          min: 15,
                          max: 40,
                          activeColor: ColorsRes.appColor,
                          onChanged: (double value)
                          {
                            setState(()
                            {
                              speedFactor = value;
                            });
                            _toggleScrolling();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : const SizedBox(height: 0, width: 0,),
    );
  }

  setDarkMode(bool darkMode) async
  {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setBool("DARK MODE", darkMode);
  }
}
