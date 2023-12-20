import 'package:flutter/material.dart';
import 'package:srila_prabhupada_books/model/detail.dart';

import '../helper/color_constants.dart';
import '../helper/strings.dart';
import '../database/database_helper.dart';
import '../localization/demo_localization.dart';
import 'chapter_details.dart';

class ListSearch extends StatefulWidget
{
  final int? id;
  const ListSearch({super.key, this.id});
  @override
  ListSearchState createState() => ListSearchState();
}

class ListSearchState extends State<ListSearch>
{
  List<BookDetail> item = [];
  List<BookDetail> _notesForDisplay = [];
  final TextEditingController _textController = TextEditingController();

  static final DatabaseHelper instance = DatabaseHelper.privateConstructor();
  bool typing = false;

  String? source, query;
  List<TextSpan> highlightOccurrences(source, query) {

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
            style: TextStyle(
              backgroundColor: ColorsRes.appColor,
              color: Colors.white,
            ),
          ),
        );
      }
      else if (match.start > lastMatchEnd)
      {
        children.add(TextSpan(text: source.substring(lastMatchEnd, match.start),),);
        children.add(TextSpan(text: source.substring(match.start, match.end), style: TextStyle(backgroundColor: ColorsRes.appColor, color: Colors.white),),);
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
      instance.getSearch().then((value)
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
        title: typing
            ? Text(DemoLocalization.of(context).translate("title"))
            : TextField(
                style: const TextStyle(color: Colors.white, fontSize: 18,),
                cursorColor: Colors.white,
                autofocus: true,
                controller: _textController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: DemoLocalization.of(context).translate("Search"),
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
                        var noteTitle = items.chapterName!.toLowerCase();
                        return noteTitle.contains(text);
                      },
                      ).toList();
                    },
                  );
                },
              ),
        actions: <Widget>
        [
          IconButton(
            icon: Icon(typing ? Icons.search : Icons.clear),
            onPressed: ()
            {
              setState(()
              {
                typing = !typing;
                _textController.clear();
                query = "";
                _notesForDisplay = item;
              },
              );
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: instance.getSearch(),
        builder: (context, index)
        {
          return ListView.separated(
            itemCount: _notesForDisplay.length,
            separatorBuilder: (BuildContext context, int index) => Divider(
              color: darkMode ? Colors.white : ColorsRes.black,
              height: 5,
              thickness: 8,
            ),
            itemBuilder: (context, index)
            {
              var item = _notesForDisplay[index];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0.0,
                  horizontal: 16.0,
                ),
                dense: true,
                tileColor: darkMode ? ColorsRes.backgroundColor : ColorsRes.grey,
                leading: Text(
                  '${item.id}.',
                  style: TextStyle(
                    fontSize: 20,
                    color: darkMode ? ColorsRes.black : Colors.white,
                  ),
                ),
                title: RichText(
                  text: TextSpan(
                    children: highlightOccurrences(()
                    {
                      if (languageFlag == "en")
                      {
                        return item.chapterName;
                      }
                      else if (languageFlag == "hi")
                      {
                        return item.hindiChapterName;
                      }
                      else
                      {
                        return item.chapterName;
                      }
                    }(), query),
                    style: TextStyle(fontSize: 20, color: darkMode ? Colors.black : ColorsRes.white,),
                  ),
                ),
                onTap: ()
                {
                  Navigator.push(context, MaterialPageRoute(settings: RouteSettings(arguments: item), builder: (context) => DetailPage(chapterID: item.id,)));
                },
              );
            },
          );
        },
      ),
    );
  }
}
