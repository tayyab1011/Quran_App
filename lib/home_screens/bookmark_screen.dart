import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_app/helper/base_url.dart';
import 'package:quran_app/models/all_bookMarks.dart';

import 'package:quran_app/models/remove_bookMark_model.dart';

import 'package:quran_app/widgets/custom_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../helper/global_variables.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  AllBookMarkModels allBookMarkModels = AllBookMarkModels();
  RemoveBookMarkModels removeBookMarkModels = RemoveBookMarkModels();
  bool isLoading = false; // Add this line inside _BookmarkScreenState class

  //Api call to get bookmarks
  getAllBookMarks() async {
    print("Running: Get All Bookmarsks");
    setState(() {
      isLoading = true;
    });
    var headersList = {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };
    var url = Uri.parse('https://mecca.eigix.net/api/all_bookmarked_books');
    var sharedPreferences = await SharedPreferences.getInstance();
    var userId = sharedPreferences.getString('userId');

    var body = {"users_customers_id": userId.toString()};

    var req = http.Request('POST', url);
    req.headers.addAll(headersList);
    req.body = json.encode(body);

    var res = await req.send();
    final resBody = await res.stream.bytesToString();

    if (res.statusCode == 200) {
      allBookMarkModels = allBookMarkModelsFromJson(resBody);
      print(resBody);
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      allBookMarkModels = allBookMarkModelsFromJson(resBody);
      print(res.reasonPhrase);
    }
  }

  String? bookId;

  //Api call to remove bookmakrs
  removeBookMark() async {
    var headersList = {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };
    var url = Uri.parse('https://mecca.eigix.net/api/remove_book_bookmark');
    var sharedPreferences = await SharedPreferences.getInstance();
    var userId = sharedPreferences.getString('userId');

    var body = {"users_customers_id": userId, "books_id": bookId};

    var req = http.Request('POST', url);
    req.headers.addAll(headersList);
    req.body = json.encode(body);

    var res = await req.send();
    final resBody = await res.stream.bytesToString();

    if (res.statusCode == 200) {
      removeBookMarkModels = removeBookMarkModelsFromJson(resBody);
      if (mounted) {
        setState(() {});
      }
      print(resBody);
    } else {
      removeBookMarkModels = removeBookMarkModelsFromJson(resBody);
      print(res.reasonPhrase);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => ferctData());
  }

  Future<void> ferctData() async {
    getAllBookMarks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(170.0),
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
                      horizontal: 18.0, vertical: 50.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          const SizedBox(
                            width: 83,
                          ),
                          Text(
                            'Bookmark',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w500,
                                color: GlobalVariables.textColor,
                              ),
                            ),
                          ),
                          const Spacer(),
                          SvgPicture.asset(
                            'assets/images/logout.svg',
                            height: 24,
                            width: 24,
                          )
                        ],
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 15),
                  child: Row(
                    children: [
                      Flexible(
                        child: TextFormField(
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
                                  borderSide: BorderSide(color: Colors.white)),
                              enabledBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  borderSide: BorderSide(color: Colors.white))),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: GlobalVariables.textColor,
            ))
          : allBookMarkModels.data != null && allBookMarkModels.data!.isNotEmpty
              ? SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 23.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: GridView.builder(
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 16.0,
                              crossAxisSpacing: 16.0,
                              childAspectRatio:
                                  0.6, // Adjust as needed for your design
                            ),
                            itemCount: allBookMarkModels.data!.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: [
                                        Image.network(
                                          "$baseImageURL${allBookMarkModels.data![index].cover}",
                                          height: 156,
                                          width: 146,
                                        ),
                                        Positioned(
                                          left: 105,
                                          child: GestureDetector(
                                            onTap: () async {
                                              setState(() {
                                                bookId = allBookMarkModels
                                                    .data![index].booksId
                                                    .toString();
                                              });
                                              print(bookId);
                                              await removeBookMark();
                                              if (removeBookMarkModels.status ==
                                                  'success') {
                                                CustomToast.showToast(
                                                    message:
                                                        'Bookmark removed successfully');
                                                await getAllBookMarks();
                                              } else {
                                                CustomToast.showToast(
                                                    message:
                                                        removeBookMarkModels
                                                            .message
                                                            .toString());
                                              }
                                            },
                                            child: SvgPicture.asset(
                                              'assets/images/white_bookmark.svg',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 146,
                                      child: Text(
                                        allBookMarkModels.data![index].title,
                                        style: GoogleFonts.poppins(
                                            textStyle: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400)),
                                      ),
                                    ),
                                    Text(
                                      'Author',
                                      style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                              color: Colors.lightBlueAccent,
                                              fontSize: 8,
                                              fontWeight: FontWeight.w400)),
                                    ),
                                    SizedBox(
                                      width: 146,
                                      child: Text(
                                        allBookMarkModels
                                            .data![index].author.name,
                                        style: GoogleFonts.poppins(
                                            textStyle: const TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w400)),
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
                                              fontWeight: FontWeight.w400)),
                                    ),
                                    Text(
                                      allBookMarkModels
                                          .data![index].category.name,
                                      style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w400)),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Center(
                  child: Text(
                    'No Bookmark added',
                    style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400)),
                  ),
                ),
    );
  }
}
