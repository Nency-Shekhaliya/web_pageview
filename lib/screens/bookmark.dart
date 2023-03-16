import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:web_pageview/model/globals.dart';

class BookMark_Page extends StatefulWidget {
  BookMark_Page({
    Key? key,
  }) : super(key: key);

  @override
  State<BookMark_Page> createState() => _BookMark_PageState();
}

class _BookMark_PageState extends State<BookMark_Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: Global.bookmark
                .map((e) => Padding(
                      padding:
                          const EdgeInsets.only(left: 15, right: 15, top: 15),
                      child: AnyLinkPreview(
                        link: e,
                        displayDirection: UIDirection.uiDirectionHorizontal,
                        bodyMaxLines: 3,
                        showMultimedia: false,
                        bodyTextOverflow: TextOverflow.ellipsis,
                        backgroundColor: Colors.blue.shade50,
                      ),
                    ))
                .toList(),
          ),
        ));
  }
}
