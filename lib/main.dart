import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:web_pageview/model/globals.dart';
import 'package:web_pageview/screens/bookmark.dart';

void main() {
  runApp(const MywebApp());
}

class MywebApp extends StatefulWidget {
  const MywebApp({Key? key}) : super(key: key);

  @override
  State<MywebApp> createState() => _MywebAppState();
}

class _MywebAppState extends State<MywebApp> {
  late InAppWebViewController mywebcontroller;
  String data = '';

  bool cangoback = false;
  String currenturl = '';
  String myurl =
      'https://www.google.com/search?q=flutter&rlz=1C1ONGR_enIN986IN986&oq=flutter&aqs=chrome..69i57j0i131i433i512l4j69i60l3.3745j0j7&sourceid=chrome&ie=UTF-8';
  bool cangoforward = false;
  late PullToRefreshController pullToRefreshController;
  double progress = 0;
  @override
  void initState() {
    super.initState();
    myurl =
        "https://www.google.com/search?q=$data&rlz=1C1ONGR_enIN986IN986&oq=$data&aqs=chrome..69i57j0i131i433i512l4j69i60l3.3745j0j7&sourceid=chrome&ie=UTF-8";
    pullToRefreshController = PullToRefreshController(
      onRefresh: () {
        setState(() {
          pullToRefreshController.endRefreshing();
        });
      },
      options: PullToRefreshOptions(
        enabled: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WillPopScope(
        onWillPop: () async {
          if (await mywebcontroller.canGoBack()) {
            mywebcontroller.goBack();
            return false;
          } else {
            return true;
          }
        },
        child: Builder(builder: (context) {
          return Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                  onPressed: () async {
                    setState(() {
                      Global.bookmark.contains(currenturl)
                          ? Global.bookmark.remove(currenturl)
                          : Global.bookmark.add(currenturl);
                    });
                  },
                  icon: Icon((Global.bookmark.contains(currenturl)
                      ? Icons.bookmark
                      : Icons.bookmark_border_outlined)),
                ),
                IconButton(
                  onPressed: () {
                    mywebcontroller.goBack();
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: cangoback ? Colors.white : Colors.grey,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    mywebcontroller.reload();
                  },
                  icon: const Icon(Icons.refresh),
                ),
                IconButton(
                  onPressed: () {
                    mywebcontroller.goForward();
                  },
                  icon: Icon(
                    Icons.arrow_forward_ios_sharp,
                    color: cangoforward ? Colors.white : Colors.grey,
                  ),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
              child: Column(
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Transform.scale(
                      scale: 2,
                      child: Visibility(
                        visible: (progress < 1),
                        child: LinearProgressIndicator(
                          value: progress,
                        ),
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    flex: 1,
                    child: TextField(
                      decoration:
                          const InputDecoration(border: OutlineInputBorder()),
                      onChanged: (val) {
                        setState(() {
                          data = val;
                        });
                      },
                      onSubmitted: (v) {
                        myurl =
                            "https://www.google.com/search?q=$data&rlz=1C1ONGR_enIN986IN986&oq=$data&aqs=chrome..69i57j0i131i433i512l4j69i60l3.3745j0j7&sourceid=chrome&ie=UTF-8";
                        mywebcontroller.loadUrl(
                            urlRequest: URLRequest(url: Uri.parse(myurl)));
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    flex: 13,
                    child: InAppWebView(
                      onWebViewCreated: (controller) {
                        mywebcontroller = controller;
                      },
                      onProgressChanged: (controller, p) {
                        setState(() {
                          progress = p.toDouble();
                        });
                      },
                      pullToRefreshController: pullToRefreshController,
                      onLoadStart: (con, c) async {
                        Uri? dummy = await mywebcontroller.getUrl();
                        currenturl = dummy!.scheme;
                        this.currenturl = c.toString();
                        cangoback = await mywebcontroller.canGoBack();
                        cangoforward = await mywebcontroller.canGoForward();
                        setState(() {});
                      },
                      onLoadStop:
                          (InAppWebViewController controller, Uri? url) {
                        this.currenturl = url.toString();
                        pullToRefreshController.endRefreshing();
                      },
                      initialUrlRequest: URLRequest(url: Uri.parse(myurl)),
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => BookMark_Page()));
                },
                child: Icon(Icons.bookmark_add)),
          );
        }),
      ),
    );
  }
}
