import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<String> categoriesList = [
    'All',
    'Books',
    'Author'

  ];
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(17.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Search By',
              style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500)),
            ),
            const SizedBox(height: 12,),
            SizedBox(

              height: 35,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categoriesList.length,
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
                          border: Border.all(
                            color: selectedIndex==index? Colors.green:Colors.transparent
                          ),
                            borderRadius: BorderRadius.circular(25),
                            ),
                        child: Center(
                          child: Text(
                            categoriesList[index],
                            style: GoogleFonts.poppins(
                                textStyle:  TextStyle(
                                  color: selectedIndex== index? Colors.green:Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400)),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      )),
    );
  }
}
