import 'package:flutter/material.dart';
import 'package:farmalog/pages/searchTab/searchTabBlogs.dart';
import 'package:farmalog/pages/searchTab/searchTabEvents.dart';
import 'package:farmalog/pages/searchTab/searchTabQuestions.dart';
import 'package:farmalog/Database_helper/languages.dart';

class SearchBarPage extends StatefulWidget {
  const SearchBarPage({super.key});

  @override
  State<SearchBarPage> createState() => _SearchBarPageState();
}

class _SearchBarPageState extends State<SearchBarPage> {

  Language language = Language();
  final TextEditingController _searchBar = TextEditingController();


  showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  getLanguageForText()async
  {
    await language.getLanguage();
    setState(() {
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLanguageForText();
  }

  @override
  void dispose() {
    _searchBar.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
        setState(() {});
      },
      child: Scaffold(
        backgroundColor: Color(0xffe4e2e5),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                        child: SearchBar(
                          controller: _searchBar,
                          hintText: language.setText("search blogs,events and questions..."),
                          elevation: MaterialStatePropertyAll(0),
                          shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15),),),),
                          onChanged: (value) {
                            setState(() {

                            });
                          },
                        ),
                      ),
                    ),
                    IconButton(onPressed: () {
                      setState(() {
                        
                      });
                    }, icon: Icon(Icons.search_rounded))
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                DefaultTabController(
                  length: 3,
                  initialIndex: 0,
                  child: Column(
                    children: [
                      TabBar(
                        labelColor: Color(0xFF333c3a),
                        tabs: [
                          Icon(Icons.image_rounded),
                          Icon(Icons.question_answer_rounded),
                          Icon(Icons.storefront_rounded)
                        ],
                      ),
                      Container(height: MediaQuery.of(context).size.height,
                        child: TabBarView(children: [SearchTabBlogs(query: _searchBar.text,),SearchTabQuestions(query: _searchBar.text),SearchTabEvents(query: _searchBar.text,),],),)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
