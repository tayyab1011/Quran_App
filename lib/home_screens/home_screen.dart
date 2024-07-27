import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_app/helper/base_url.dart';
import 'package:quran_app/helper/global_variables.dart';
import 'package:quran_app/home_screens/search_page.dart';
import 'package:quran_app/models/add_bookMark_model.dart';
import 'package:quran_app/models/books_models.dart';
import 'package:quran_app/models/categories_model.dart';
import 'package:http/http.dart' as http;
import 'package:quran_app/models/top_book_model.dart';
import 'package:quran_app/widgets/custom_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? selectedIndex;
  BooksModels booksModels = BooksModels();
  TopBooksModels topBooksModels = TopBooksModels();
  TextEditingController searchController = TextEditingController();
  CategoriesModels categoriesModels = CategoriesModels();
  AddBookMarkModels addBookMarkModels = AddBookMarkModels();

//Api to add bookmark

  addBookMark() async {
    var headersList = {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };
    var url = Uri.parse('https://mecca.eigix.net/api/add_book_bookmark');
    var sharedPreferences = await SharedPreferences.getInstance();
    var userId = sharedPreferences.getString('userId');

    var body = {"users_customers_id": userId.toString(), "books_id": "$bookId"};

    var req = http.Request('POST', url);
    req.headers.addAll(headersList);
    req.body = json.encode(body);

    var res = await req.send();
    final resBody = await res.stream.bytesToString();

    if (res.statusCode == 200) {
      addBookMarkModels = addBookMarkModelsFromJson(resBody);
      print(resBody);
      if (mounted) {
        setState(() {});
      }
    } else {
      addBookMarkModels = addBookMarkModelsFromJson(resBody);
      print(res.reasonPhrase);
    }
  }

// Api call to get all books
  getBooks() async {
    var headersList = {
      'User-Agent': 'Thunder Client (https://www.thunderclient.com)',
      'Accept': 'application/json'
    };
    var url = Uri.parse('$baseURL/books');

    var req = http.Request('GET', url);
    req.headers.addAll(headersList);

    var res = await req.send();
    final resBody = await res.stream.bytesToString();

    if (res.statusCode == 200) {
      booksModels = booksModelsFromJson(resBody);
      print(resBody);
      if (mounted) {
        setState(() {});
      }
    } else {
      booksModels = booksModelsFromJson(resBody);
      print(res.reasonPhrase);
    }
  }

// Api call to get all Top books
  getTopBooks() async {
    var headersList = {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };
    var url = Uri.parse('https://mecca.eigix.net/api/popular_books');

    var sharedPreferences = await SharedPreferences.getInstance();
    var userId = sharedPreferences.getString('userId');

    var body = {"users_customers_id": userId};

    var req = http.Request('POST', url);
    req.headers.addAll(headersList);
    req.body = json.encode(body);

    var res = await req.send();
    final resBody = await res.stream.bytesToString();

    if (res.statusCode == 200) {
      topBooksModels = topBooksModelsFromJson(resBody);
      print(resBody);
      if (mounted) {
        setState(() {});
      }
    } else {
      topBooksModels = topBooksModelsFromJson(resBody);
      print(res.reasonPhrase);
    }
  }

  String? bookId;

// Api call to get all categories
  getCategories() async {
    var headersList = {'Accept': 'application/json'};
    var url = Uri.parse('https://mecca.eigix.net/api/categories');

    var req = http.Request('GET', url);
    req.headers.addAll(headersList);

    var res = await req.send();
    final resBody = await res.stream.bytesToString();

    if (res.statusCode == 200) {
      categoriesModels = categoriesModelsFromJson(resBody);
      print(resBody);
      if (mounted) {
        setState(() {
          selectedIndex = 0;
        });
      }
    } else {
      print(res.reasonPhrase);
      categoriesModels = categoriesModelsFromJson(resBody);
    }
  }

  @override
  void initState() {
    super.initState();
    getCategories();
    getBooks();
    getTopBooks();
    addBookMark();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Set status bar color to transparent
      statusBarIconBrightness: Brightness.dark, // Set status bar icon color
    ));

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(210.0),
          // Custom height for the AppBar
          child: Stack(
            children: [
              AppBar(
                automaticallyImplyLeading: false,
                flexibleSpace: Container(
                  margin: const EdgeInsets.only(bottom: 45),
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.topRight,
                      colors: [
                        Color(0xFFF7E683),
                        Color(0xFFE8B55B),
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Welcome to the',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: GlobalVariables.textColor,
                                ),
                              ),
                            ),
                            SvgPicture.asset(
                              'assets/images/logout.svg',
                              height: 24,
                              width: 24,
                            )
                          ],
                        ),
                        Text(
                          'Islamic Book Library',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w500,
                              color: GlobalVariables.textColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                elevation: 0,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 14.0,
                    ),
                    child: Row(
                      children: [
                        Flexible(
                          child: TextFormField(
                            onChanged: (val) {
                              setState(() {});
                            },
                            controller: searchController,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: GlobalVariables.iconColor,
                                ),
                                hintText: 'Search here',
                                hintStyle: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w300,
                                      color: GlobalVariables.labelColor),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                enabledBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    borderSide:
                                        BorderSide(color: Colors.white))),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const SearchPage()));
                          },
                          child: SvgPicture.asset(
                            'assets/images/hamburger.svg',
                            height: 87,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        body: categoriesModels.data != null
            ? SingleChildScrollView(
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 23.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Categories',
                          style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500)),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        categoriesModels.data != null
                            ? SizedBox(
                                height: 37,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: categoriesModels.data!.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedIndex = index;
                                          });
                                        },
                                        child: Container(
                                          width: 80,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              gradient: selectedIndex == index
                                                  ? const LinearGradient(
                                                      begin: Alignment.topLeft,
                                                      end: Alignment.topRight,
                                                      colors: [
                                                        Color(0xFFF7E683),
                                                        Color(0xFFF7E683),
                                                        Color(0xFFE8B55B),
                                                      ],
                                                      stops: [
                                                        0.0,
                                                        0.5,
                                                        1.0
                                                      ], // Adjust the stops if necessary
                                                    )
                                                  : null),
                                          child: Center(
                                            child: Text(
                                              categoriesModels
                                                  .data![index].name,
                                              style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              )
                            : Center(
                                child: CircularProgressIndicator(
                                  color: GlobalVariables.textColor,
                                ),
                              ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Featured Books',
                          style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500)),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        booksModels.data != null
                            ? SizedBox(
                                height: 270,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: booksModels.data!.length,
                                  itemBuilder: (context, index) {
                                    String items =
                                        booksModels.data![index].title;

                                    if (searchController.text.isEmpty) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 15.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Stack(
                                              children: [
                                                Image.network(
                                                  "$baseImageURL${booksModels.data![index].cover}",
                                                  width: 146,
                                                  height: 156,
                                                ),
                                                Positioned(
                                                  top: 10,
                                                  left: 100,
                                                  child: GestureDetector(
                                                      onTap: () async {
                                                        setState(() {
                                                          bookId = booksModels
                                                              .data![index]
                                                              .booksId
                                                              .toString();
                                                        });
                                                        print(bookId);
                                                        await addBookMark();
                                                        if (addBookMarkModels
                                                                .status ==
                                                            'success') {
                                                          CustomToast.showToast(
                                                              message:
                                                                  'Bookmark added');
                                                        } else {
                                                          CustomToast.showToast(
                                                              message:
                                                                  addBookMarkModels
                                                                      .message
                                                                      .toString());
                                                        }
                                                      },
                                                      child: const Icon(
                                                        Icons.bookmark,
                                                        color: Colors.grey,
                                                      )),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              width: 146,
                                              child: Text(
                                                booksModels.data![index].title,
                                                style: GoogleFonts.poppins(
                                                    textStyle: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400)),
                                              ),
                                            ),
                                            Text(
                                              'Author',
                                              style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                      color: Colors
                                                          .lightBlueAccent,
                                                      fontSize: 8,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                            ),
                                            SizedBox(
                                              width: 146,
                                              child: Text(
                                                maxLines: 2,
                                                booksModels
                                                    .data![index].author.name
                                                    .toString(),
                                                style: GoogleFonts.poppins(
                                                    textStyle: const TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w400)),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              'Category',
                                              style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                      color: Colors.lightGreen,
                                                      fontSize: 8,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                            ),
                                            Text(
                                              booksModels
                                                  .data![index].category.name,
                                              style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                            ),
                                          ],
                                        ),
                                      );
                                    } else if (items
                                        .toLowerCase()
                                        .contains(searchController.text)) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 15.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Stack(
                                              children: [
                                                Image.network(
                                                  "$baseImageURL${booksModels.data![index].cover}",
                                                  width: 146,
                                                  height: 156,
                                                ),
                                                Positioned(
                                                  top: 10,
                                                  left: 100,
                                                  child: GestureDetector(
                                                      onTap: () async {
                                                        setState(() {
                                                          bookId = booksModels
                                                              .data![index]
                                                              .booksId
                                                              .toString();
                                                        });
                                                        print(bookId);
                                                        await addBookMark();
                                                        if (addBookMarkModels
                                                                .status ==
                                                            'success') {
                                                          CustomToast.showToast(
                                                              message:
                                                                  'Bookmark added');
                                                        } else {
                                                          CustomToast.showToast(
                                                              message:
                                                                  addBookMarkModels
                                                                      .message
                                                                      .toString());
                                                        }
                                                      },
                                                      child: const Icon(
                                                        Icons.bookmark,
                                                        color: Colors.grey,
                                                      )),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              width: 146,
                                              child: Text(
                                                booksModels.data![index].title,
                                                style: GoogleFonts.poppins(
                                                    textStyle: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400)),
                                              ),
                                            ),
                                            Text(
                                              'Author',
                                              style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                      color: Colors
                                                          .lightBlueAccent,
                                                      fontSize: 8,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                            ),
                                            SizedBox(
                                              width: 146,
                                              child: Text(
                                                maxLines: 2,
                                                booksModels
                                                    .data![index].author.name
                                                    .toString(),
                                                style: GoogleFonts.poppins(
                                                    textStyle: const TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w400)),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              'Category',
                                              style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                      color: Colors.lightGreen,
                                                      fontSize: 8,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                            ),
                                            Text(
                                              booksModels
                                                  .data![index].category.name,
                                              style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      return Container();
                                    }
                                  },
                                ),
                              )
                            : Center(
                                child: CircularProgressIndicator(
                                  color: GlobalVariables.textColor,
                                ),
                              ),
                        Text(
                          'Top Books',
                          style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500)),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        topBooksModels.data != null
                            ? SizedBox(
                                height: 270,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: topBooksModels.data!.length,
                                  itemBuilder: (context, index) {
                                    String items1 =
                                        topBooksModels.data![index].title;
                                    if (searchController.text.isEmpty) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 15.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Stack(
                                              children: [
                                                Image.network(
                                                  "$baseImageURL${topBooksModels.data![index].cover}",
                                                  height: 156,
                                                  width: 146,
                                                ),
                                                Positioned(
                                                  left: 105,
                                                  child: SvgPicture.asset(
                                                    'assets/images/faded.svg',
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              width: 146,
                                              child: Text(
                                                maxLines: 2,
                                                topBooksModels
                                                    .data![index].title,
                                                style: GoogleFonts.poppins(
                                                    textStyle: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400)),
                                              ),
                                            ),
                                            Text(
                                              'Author',
                                              style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                      color: Colors
                                                          .lightBlueAccent,
                                                      fontSize: 8,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                            ),
                                            Text(
                                              maxLines: 2,
                                              topBooksModels
                                                  .data![index].author.name,
                                              style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              'Category',
                                              style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                      color: Colors.lightGreen,
                                                      fontSize: 8,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                            ),
                                            Text(
                                              topBooksModels
                                                  .data![index].category.name,
                                              style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                            ),
                                          ],
                                        ),
                                      );
                                    } else if (items1
                                        .toLowerCase()
                                        .contains(searchController.text)) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 15.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Stack(
                                              children: [
                                                Image.network(
                                                  "$baseImageURL${topBooksModels.data![index].cover}",
                                                  height: 156,
                                                  width: 146,
                                                ),
                                                Positioned(
                                                  left: 105,
                                                  child: SvgPicture.asset(
                                                    'assets/images/faded.svg',
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              width: 146,
                                              child: Text(
                                                maxLines: 2,
                                                topBooksModels
                                                    .data![index].title,
                                                style: GoogleFonts.poppins(
                                                    textStyle: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400)),
                                              ),
                                            ),
                                            Text(
                                              'Author',
                                              style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                      color: Colors
                                                          .lightBlueAccent,
                                                      fontSize: 8,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                            ),
                                            Text(
                                              maxLines: 2,
                                              topBooksModels
                                                  .data![index].author.name,
                                              style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              'Category',
                                              style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                      color: Colors.lightGreen,
                                                      fontSize: 8,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                            ),
                                            Text(
                                              topBooksModels
                                                  .data![index].category.name,
                                              style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      return Container();
                                    }
                                  },
                                ),
                              )
                            : Center(
                                child: CircularProgressIndicator(
                                  color: GlobalVariables.textColor,
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              )
            : Center(
                child: CircularProgressIndicator(
                  color: GlobalVariables.textColor,
                ),
              ));
  }
}
