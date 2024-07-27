import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:quran_app/helper/base_url.dart';
import 'package:quran_app/home_screens/read_now.dart';
import 'package:quran_app/models/book_download_model.dart';
import 'package:quran_app/models/related_books_model.dart';
import 'package:quran_app/widgets/custom_button.dart';
import 'package:quran_app/widgets/custom_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helper/global_variables.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';

// ignore: must_be_immutable
class BookDetails extends StatefulWidget {
  String? title;
  String? image;
  String? author;
  String? pages;
  String? bookId;
  String? bookUrl;
  BookDetails(
      {super.key,
      this.author,
      this.image,
      this.pages,
      this.title,
      this.bookId,
      this.bookUrl});

  @override
  State<BookDetails> createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookDetails> {
  RelatedBooksModels relatedBooksModels = RelatedBooksModels();
  BookDownloadModels bookDownloadModels = BookDownloadModels();

  getRelatedBooks() async {
    var headersList = {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };
    var url = Uri.parse('https://mecca.eigix.net/api/related_books');
    var sharedPreferences = await SharedPreferences.getInstance();
    var userId = sharedPreferences.getString('userId');

    var body = {"users_customers_id": userId.toString(), "books_id": "24"};

    var req = http.Request('POST', url);
    req.headers.addAll(headersList);
    req.body = json.encode(body);

    var res = await req.send();
    final resBody = await res.stream.bytesToString();

    if (res.statusCode == 200) {
      relatedBooksModels = relatedBooksModelsFromJson(resBody);
      print(resBody);
      if (mounted) {
        setState(() {});
      }
    } else {
      relatedBooksModels = relatedBooksModelsFromJson(resBody);
      print(res.reasonPhrase);
    }
  }

  double? progress;
  downloadBook() async {
    var headersList = {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };
    var url = Uri.parse('https://mecca.eigix.net/api/book_download');
    var sharedPreferences = await SharedPreferences.getInstance();
    var userId = sharedPreferences.getString('userId');

    var body = {"users_customers_id": userId, "books_id": "24"};

    var req = http.Request('POST', url);
    req.headers.addAll(headersList);
    req.body = json.encode(body);

    var res = await req.send();
    final resBody = await res.stream.bytesToString();

    if (res.statusCode >= 200 && res.statusCode < 300) {
      bookDownloadModels = bookDownloadModelsFromJson(resBody);
      if (mounted) {
        setState(() {});
      }
    } else {
      bookDownloadModels = bookDownloadModelsFromJson(resBody);
      print(res.reasonPhrase);
    }
  }


  @override
  void initState() {
    super.initState();
    getRelatedBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(130),
          child: AppBar(
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
                  ])),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 35.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        const SizedBox(
                          width: 100,
                        ),
                        Text(
                          'Book Details',
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
                  ],
                ),
              ),
            ),
            elevation: 0,
          )),
      body: Padding(
        padding: const EdgeInsets.only(left: 15.0, top: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      widget.image.toString(),
                      width: 134,
                      height: 213,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title.toString(),
                            style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 16)),
                          ),
                          const SizedBox(
                            height: 14,
                          ),
                          Row(
                            children: [
                              Text(
                                'Author',
                                style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12)),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                widget.author.toString(),
                                style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12)),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                'Pages',
                                style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12)),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                widget.pages.toString(),
                                style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12)),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              SvgPicture.asset(
                                'assets/images/dark_bookmark.svg',
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Bookmark',
                                style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12)),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () async {
                              await downloadBook();
                              FileDownloader.downloadFile(
                                onProgress: (fileName, progress) {
                                  setState(() {
                                    this.progress = progress;
                                  });
                                },
                                onDownloadCompleted: (value) {
                                  print("Value is path $value");
                                  setState(() {
                                    progress = null;
                                    CustomToast.showToast(message: "File Downloded");
                                  });
                                },
                                url: "$baseImageURL${widget.bookUrl}",
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                SvgPicture.asset(
                                    'assets/images/download.svg'),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Download',
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                if (progress != null) ...[
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    '${(progress! * 1.0).toStringAsFixed(0)}%',
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 23,
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ReadNow(
                                bookId: widget.bookId,
                                bookUrl: widget.bookUrl,
                              )));
                    },
                    child: const CustomButton(text: 'READ NOW')),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Related Books',
              style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500)),
            ),
            const SizedBox(
              height: 12,
            ),
            relatedBooksModels.data != null
                ? Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 8.0,
                      ),
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
                        itemCount: relatedBooksModels.data!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    Image.network(
                                      "$baseImageURL${relatedBooksModels.data![index].cover}",
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
                                    relatedBooksModels.data![index].title,
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
                                    relatedBooksModels.data![index].author.name,
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
                                  relatedBooksModels.data![index].category.name,
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
                  )
                : Center(
                    child: CircularProgressIndicator(
                      color: GlobalVariables.textColor,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
