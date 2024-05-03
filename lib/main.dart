import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import 'home_web_view_view.dart';

void main() {
  runApp(const MyApp());
}

var logger = Logger();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const HomeWebViewScreen(),
      home: const MyHomePage(
          title: "ANA-Web Flutter SDK", auth_code: "auth_code1"),
      getPages: [
        GetPage(
          name: '/',
          page: () => MyHomePage(
              title: "title", auth_code: Get.parameters["auth_code"]),
        ),
        GetPage(
            name: '/home_web_view_screen',
            page: () => const HomeWebViewScreen()),
      ],
      // home: const MyHomePage(title: "title"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, this.auth_code});

  final String title;
  final dynamic auth_code;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  _incrementCounter() async {
    // const HomeWebViewScreen();
    Get.toNamed("/home_web_view_screen");
  }

  late TextEditingController tc;

  @override
  Widget build(BuildContext context) {
    tc = TextEditingController();
    tc.value = TextEditingValue(text: widget.auth_code);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FilledButton(
                        onPressed: _incrementCounter,
                        child: const Text("Open Ana-Web")),
                  ],
                ),
                // const Row(
                //   children: [
                //     SizedBox(
                //       width: 16,
                //     ),
                //   ],
                // ),
                Row(
                  children: [
                    SizedBox(
                      height: Get.mediaQuery.size.height / 3,
                      width: Get.mediaQuery.size.width-32,
                      child: TextField(
                        controller: this.tc,
                        maxLines: 3,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        readOnly: true,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),

      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
