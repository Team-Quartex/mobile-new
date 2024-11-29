import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:trova/class/search_class.dart';
import 'package:trova/class/user_class.dart';
import 'package:trova/widget/post_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  // List of predefined words for search
  List<Map<String, dynamic>>? wordList;

  List<Map<String, dynamic>> filteredWords = [];
  List<Map<String, dynamic>> suggestions = [];
  bool showBanner = false;
  final SearchClass _searchClass = SearchClass();
  int? userId;
  String? profilePic;
  UserClass? _userClass;

  @override
  void initState() {
    super.initState();
    _fetchSuggestions();
    _fetchSearchres("");
    _fetchUserDeails();
  }

  Future<void> _fetchSuggestions() async {
    wordList = await _searchClass.searchSuggetions();
    if (wordList != null) {
      setState(() {});
    }
  }

  Future<void> _fetchSearchres(String query) async {
    filteredWords = await _searchClass.filterSearch(query);
    setState(() {});
  }

  Future<void> _fetchUserDeails() async {
    _userClass = GetIt.instance.get<UserClass>();
    _userClass!.fetchUser();
    userId = _userClass!.userid;
    profilePic = _userClass!.profilepic;
    print(userId);
  }

  void _onSearchChanged(String query) {
    setState(() {
      // Show banner for a single character
      if (query.length == 1) {
        showBanner = true;
      } else {
        showBanner = false;
      }

      // If query is empty, clear suggestions
      if (query.isEmpty) {
        suggestions.clear();
        _fetchSearchres('');
      } else {
        // Filter words for suggestions (up to 4 matches)
        suggestions = wordList!
            .where((word) => word['name']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()))
            .take(4)
            .toList();

        // Filter words for the main display
        // filteredWords = wordList!
        //     .where((word) => word['name']
        //         .toString()
        //         .toLowerCase()
        //         .contains(query.toLowerCase()))
        //     .toList();
      }
    });
  }

  void _onSuggestionSelected(Map<String, dynamic> suggestion) {
    _searchController.text = suggestion['name'];
    _onSearchChanged(suggestion['name']);
    _fetchSearchres(suggestion['name']);
    suggestions.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   toolbarHeight: 50,
      // ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 8.0,
                          spreadRadius: 2.0,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: _onSearchChanged,
                      decoration: InputDecoration(
                        prefixIcon:
                            const Icon(Icons.search, color: Colors.black),
                        hintText: 'Search here...',
                        hintStyle: const TextStyle(color: Colors.grey),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  // Suggestions Box
                  if (suggestions.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(top: 5.0),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            blurRadius: 5.0,
                            spreadRadius: 1.0,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: suggestions.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                              suggestions[index]['name'],
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 126, 44, 44)),
                            ),
                            onTap: () {
                              _onSuggestionSelected(suggestions[index]);
                            },
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
            // Main Display
            Expanded(
              child: ListView.builder(
                itemCount: filteredWords.length,
                itemBuilder: (context, index) {
                  return PostCard(
                      post: filteredWords[index],
                      userId: userId!,
                      profilePic: profilePic!);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
