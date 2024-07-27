import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_app/helper/base_url.dart';
import 'package:quran_app/home_screens/book_details.dart';
import 'package:quran_app/home_screens/search_page.dart';
import 'package:quran_app/models/books_models.dart';
import 'package:http/http.dart' as http;
import '../helper/global_variables.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  List<String> categoriesList = ['All', 'Quran', 'Hadith', 'Tafsir'];
  int selectedIndex = 0;
  BooksModels booksModels = BooksModels();
  TextEditingController searchController = TextEditingController();

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
      if(mounted){
        setState(() {});
      }
    } else {
      booksModels = booksModelsFromJson(resBody);
      print(res.reasonPhrase);
    }
  }

  @override
  void initState() {
    super.initState();
    getBooks();
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
                            width: 100,
                          ),
                          Text(
                            'Browse',
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
                  padding: const EdgeInsets.only(
                    left: 14.0,
                  ),
                  child: Row(
                    children: [
                      Flexible(
                        child: TextFormField(
                          controller: searchController,
                          onChanged: (val) {
                            setState(() {});
                          },
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
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SearchPage()));
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
      body: booksModels.data != null
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
                        itemCount: booksModels.data!.length,
                        itemBuilder: (context, index) {
                          String items = booksModels.data![index].title;
                          if (searchController.text.isEmpty) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => BookDetails(
                                          image:
                                              "$baseImageURL${booksModels.data![index].cover}",
                                          title: booksModels.data![index].title,
                                          author: booksModels
                                              .data![index].author.name,
                                          pages: booksModels.data![index].pages
                                              .toString(),
                                          bookId: booksModels
                                              .data![index].booksId
                                              .toString(),
                                          bookUrl: booksModels
                                              .data![index].bookUrl
                                              .toString(),
                                        )));
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: [
                                        Image.network(
                                          "$baseImageURL${booksModels.data![index].cover}",
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
                                        booksModels.data![index].title,
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
                                        booksModels.data![index].author.name,
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
                                      booksModels.data![index].category.name,
                                      style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w400)),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else if (items
                              .toLowerCase()
                              .contains(searchController.text)) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => BookDetails(
                                          image:
                                              "$baseImageURL${booksModels.data![index].cover}",
                                          title: booksModels.data![index].title,
                                          author: booksModels
                                              .data![index].author.name,
                                          pages: booksModels.data![index].pages
                                              .toString(),
                                        )));
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: [
                                        Image.network(
                                          "$baseImageURL${booksModels.data![index].cover}",
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
                                        booksModels.data![index].title,
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
                                        booksModels.data![index].author.name,
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
                                      booksModels.data![index].category.name,
                                      style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w400)),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(
                color: GlobalVariables.textColor,
              ),
            ),
    );
  }
}
