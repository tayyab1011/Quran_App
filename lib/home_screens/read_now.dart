import 'package:flutter/material.dart';
import 'package:quran_app/helper/base_url.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class ReadNow extends StatefulWidget {
  final String? bookId;
  final String? bookUrl;

  const ReadNow({super.key, this.bookId, this.bookUrl});

  @override
  State<ReadNow> createState() => _ReadNowState();
}

class _ReadNowState extends State<ReadNow> {
  PdfViewerController _pdfViewerController = PdfViewerController();
  int _currentPageNumber = 1;
  int _totalPageCount = 0;

  @override
  void initState() {
    super.initState();
    _pdfViewerController.addListener(_pageChangedListener);
  }

  @override
  void dispose() {
    _pdfViewerController.removeListener(_pageChangedListener);
    _pdfViewerController.dispose();
    super.dispose();
  }

  void _pageChangedListener() {
    setState(() {
      _currentPageNumber = _pdfViewerController.pageNumber;
    });
  }

  void _onDocumentLoaded(PdfDocumentLoadedDetails details) {
    setState(() {
      _totalPageCount = details.document.pages.count;
      _currentPageNumber = _pdfViewerController.pageNumber;
    });
  }

  Future<void> _downloadPdf() async {
    // Request storage permission
    final status = await Permission.storage.request();
    if (status.isGranted) {
      final directory = await getExternalStorageDirectory();
      if (directory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to get directory')),
        );
        return;
      }

      final fileName = Uri.parse(widget.bookUrl!).pathSegments.last;
      final filePath = '${directory.path}/$fileName';
      final url = Uri.parse('$baseURL${widget.bookUrl}');
      print("Download URL: $url");
      print("Save Path: $filePath");

      try {
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final file = File(filePath);
          await file.writeAsBytes(response.bodyBytes);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Download complete: $filePath')),
          );
        } else {
          print("Error: ${response.statusCode}");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('Failed to download file: ${response.statusCode}')),
          );
        }
      } catch (e) {
        print("Exception: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Download failed: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Storage permission denied')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: AppBar(
          flexibleSpace: Container(
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
            child: Center(
              child: Text(
                '$_currentPageNumber/$_totalPageCount',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.download),
              onPressed: () async {
                print("Pressed");
                await _downloadPdf();
              },
            ),
          ],
        ),
      ),
      body: SfPdfViewer.network(
        "$baseImageURL${widget.bookUrl.toString()}",
        controller: _pdfViewerController,
        onDocumentLoaded: _onDocumentLoaded,
      ),
    );
  }
}
