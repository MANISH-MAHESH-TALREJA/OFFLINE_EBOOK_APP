import 'package:srila_prabhupada_books/database/bookmark_database_helper.dart';
import 'package:flutter/material.dart';
import '../helper/color_constants.dart';
import '../helper/strings.dart';
import '../model/bookmark.dart';
import '../database/database_helper.dart';
import '../localization/demo_localization.dart';
import '../model/detail.dart';
import 'chapter_details.dart';

// ignore: must_be_immutable
class BookmarkList extends StatefulWidget
{
  int? id;
  BookmarkList({super.key, this.id,});

  @override
  BookMarkClass createState() => BookMarkClass();
}

class BookMarkClass extends State<BookmarkList>
{
  static final BookmarkHelper bookmarkInstance = BookmarkHelper.privateConstructor();
  static final DatabaseHelper databaseInstance = DatabaseHelper.privateConstructor();

  TextEditingController textController = TextEditingController();

  List<Bookmark> item = [];
  List<Bookmark> _notesForDisplay = [];
  Bookmark? it;
  bool typing = false;
  String? query;

  List<TextSpan> highlightOccurrences(source, query)
  {
    if (query == null || query.isEmpty)
    {
      return [TextSpan(text: source,),];
    }

    var matches = <Match>[];
    for (final token in query.trim().toLowerCase().split(' '))
    {
      matches.addAll(token.allMatches(source.toLowerCase(),),);
    }

    if (matches.isEmpty)
    {
      return [TextSpan(text: source,),];
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
        children.add(TextSpan(text: source.substring(lastMatchEnd, match.end,), style: TextStyle(backgroundColor: ColorsRes.appColor, color: Colors.white,),),);
      }
      else if (match.start > lastMatchEnd)
      {
        children.add(TextSpan(text: source.substring(lastMatchEnd, match.start,),),);
        children.add(TextSpan(text: source.substring(match.start, match.end), style: TextStyle(backgroundColor: ColorsRes.appColor, color: Colors.white,),),);
      }

      if (lastMatchEnd < match.end)
      {
        lastMatchEnd = match.end;
      }
    }
    if (lastMatchEnd < source.length)
    {
      children.add(TextSpan(text: source.substring(lastMatchEnd, source.length),),);
    }
    return children;
  }

  @override
  void initState()
  {
    super.initState();
    setState(()
    {
      bookmarkInstance.getBookmarks().then((value)
      {
        item.addAll(value);
        _notesForDisplay = item;
      });
    });

  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: darkMode ? ColorsRes.white : ColorsRes.black,
      appBar: AppBar(
        backgroundColor: ColorsRes.appColor,
        title: typing ? TextField(
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
          cursorColor: Colors.white,
          autofocus: true,
          controller: textController,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: DemoLocalization.of(context).translate(
              "Search",
            ),
            hintStyle: const TextStyle(
              color: Colors.white60,
              fontSize: 18,
            ),
          ),
          onChanged: (text)
          {
            text = text.toLowerCase();
            setState(()
            {
              query = text;
              _notesForDisplay = item.where((items)
              {
                var noteTitle = items.bookMarkId.toString().toLowerCase();
                return noteTitle.contains(text);
              }).toList();
            },
            );
          },
        ) : Text(DemoLocalization.of(context).translate("Bookmark List",), style: const TextStyle(color: Colors.white)),
        actions: <Widget>
        [
          IconButton(
            icon: Icon(
              typing ? Icons.clear : Icons.search,
            ),
            onPressed: ()
            {
              setState(()
              {
                typing = !typing;
                textController.clear();
                query = "";
                _notesForDisplay = item;
              });
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: bookmarkInstance.getBookmarks(),
        builder: (BuildContext context, AsyncSnapshot snapshot)
        {
          if (snapshot.hasData)
          {
            if (_notesForDisplay.isEmpty)
            {
              return const Center(child: Text("No Bookmark Found ..."),);
            }
            return ListView.separated(
              shrinkWrap: true,
              itemCount: _notesForDisplay.length,
              separatorBuilder: (BuildContext context, int index) => Divider(
                color: darkMode ? Colors.white : ColorsRes.black,
                height: 5,
                thickness: 8,
              ),
              itemBuilder: (context, index)
              {
                it = _notesForDisplay[index++];
                return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 0.0,
                      horizontal: 16.0,
                    ),
                    dense: true,
                    tileColor: darkMode ? ColorsRes.backgroundColor : ColorsRes.grey,
                    leading: RichText(
                      text: TextSpan(
                        children: highlightOccurrences(
                          "$index.",
                          query,
                        ),
                        style: TextStyle(
                          fontSize: 20,
                          color: darkMode ? Colors.black : ColorsRes.white,
                        ),
                      ),
                    ),
                    title: BookmarkTitle(bookmarkID: it!.bookMarkId,)
                    );
              },
            );
          }
          else
          {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

class BookmarkTitle extends StatefulWidget
{
  final int? bookmarkID;
  const BookmarkTitle({super.key, this.bookmarkID});
  @override
  BookmarkTitleState createState() => BookmarkTitleState();
}

class BookmarkTitleState extends State<BookmarkTitle>
{
  static final DatabaseHelper instance = DatabaseHelper.privateConstructor();
  List<BookDetail> item = [];
  List<BookDetail> _notesForDisplay = [];

  @override
  void initState()
  {
    super.initState();
    setState(()
    {
      instance.getChapterDescriptions(widget.bookmarkID!).then((value)
      {
        item.addAll(value);
        _notesForDisplay = item;
      });
    });
  }

  @override
  Widget build(BuildContext context)
  {
    return FutureBuilder(
      future: instance.getChapterDescriptions(widget.bookmarkID!),
      builder: (BuildContext context, AsyncSnapshot snapshot)
      {
        if (snapshot.hasData) {
          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _notesForDisplay.length,
            itemBuilder: (context, index)
            {
              var item = _notesForDisplay[index];
              return ListTile(
                tileColor: darkMode ? ColorsRes.backgroundColor : ColorsRes.grey,
                title: Text(
                  ()
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
                  }(), style: TextStyle(fontSize: 20, color: darkMode ? ColorsRes.black : ColorsRes.white,),
                ),
                onTap: ()
                {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DetailPage(chapterID: widget.bookmarkID!)));
                },
              );
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
