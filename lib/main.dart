// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:sublan/core/app_colors.dart';
import 'package:sublan/core/app_typo.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:sublan/core/values/app_utils.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sublan/countries.dart';
import 'package:sublan/widget.dart' as wg;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SubLan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'SubLan'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String findNameByCode(String code) {
    try {
      final String foundName = _countries.firstWhere((country) {
        return country.langCode.toLowerCase() == code;
      }).langName;
      return foundName;
    } catch (e) {
      return "Unknown";
    }
  }

  late List<Country> _countries = [];
  bool downloading = false;
  String progressString = '';
  late PlatformFile file = PlatformFile(path: null, name: "", size: 0);
  late String url = "";
  late String rawText = "";
  late String transcriptText = "";
  late bool showAsRawText = true;
  late String language = "";
  Choice _selectedChoice = choices[0];
  late TextEditingController _controller;
  late String youtubeURL = "";
  final int _end = 600;

  Future<String> _chooseFile() async {
    onRefresh();
    final result = await FilePicker.platform.pickFiles(type: FileType.audio);

    if (result == null) return Future.error("No file selected");
    final path = result.files.single.path!;
    setState(() {
      file = result.files.single;
    });
    return path;
  }

  Future<void> uploadAudio() async {
    var uri = Uri.parse(
        '${AppUtils.downloadSubtitle}?model_type=${_selectedChoice.title.toLowerCase()}&file_name=subtitles&file_type=srt');
    var request = http.MultipartRequest("POST", uri);
    var path = await _chooseFile().catchError((e) {
      Fluttertoast.showToast(
          msg: "No file selected. Try again!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.orange[100],
          textColor: Colors.black,
          fontSize: 16.0);
      return null;
    });
    setState(() {
      downloading = true;
    });
    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        path,
      ),
    );
    request
        .send()
        .timeout(
          Duration(seconds: _end),
          onTimeout: () {
            request.finalize();
            Fluttertoast.showToast(
                msg: "Timeout. Try again!",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: AppColors.onPrimary,
                fontSize: 16.0);
            throw TimeoutException("Timeout");
          },
        )
        .then((response) async {
          if (response.statusCode == 200) {
            print("Uploaded!");
            var tmp = jsonDecode(await response.stream.bytesToString());
            String lang = tmp["language"];
            setState(() {
              rawText = tmp["text"];
              transcriptText = tmp["transcribe"];
              language = findNameByCode(lang);
            });
          } else {
            print("Upload Failed!");
          }
        })
        .catchError((e) {
          Fluttertoast.showToast(
              msg: "Error occured. Try again!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: AppColors.onPrimary,
              fontSize: 16.0);
          onRefresh();
        })
        .whenComplete(() => setState(() {
              downloading = false;
              FilePicker.platform.clearTemporaryFiles();
            }))
        .ignore();
  }

  Future<void> getSubtitleFromAudioUploadedByYoutube() async {
    var uri = Uri.parse(
        '${AppUtils.downloadSubtitleByYoutubeUrl}?model_type=${_selectedChoice.title.toLowerCase()}&file_name=subtitles&file_type=srt');
    var request = http.Request("GET", uri);
    request.send().timeout(
      Duration(seconds: _end),
      onTimeout: () {
        request.finalize();
        Fluttertoast.showToast(
            msg: "Timeout. Try again!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: AppColors.onPrimary,
            fontSize: 16.0);
        throw TimeoutException("Timeout");
      },
    ).then((response) async {
      if (response.statusCode == 200) {
        print("Uploaded!");
        var tmp = jsonDecode(await response.stream.bytesToString());
        setState(() {
          rawText = tmp["text"];
          transcriptText = tmp["transcribe"];
          print(tmp["language"]);
          language = findNameByCode(tmp["language"]);
        });
      } else {
        print("Upload Failed!");
      }
    }).catchError((e) {
      print(e);
      Fluttertoast.showToast(
          msg: "Error occured. Try again!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: AppColors.onPrimary,
          fontSize: 16.0);
      onRefresh();
    }).whenComplete(() => setState(() {
          downloading = false;
        }));
  }

  Future<void> uploadYoutubeByUrl() async {
    setState(() {
      downloading = true;
      rawText = "";
      transcriptText = "";
      language = "";
      file = PlatformFile(path: null, name: "", size: 0);
    });
    var youtubeUrlEncoded = Uri.encodeComponent(youtubeURL);
    var uri =
        Uri.parse('${AppUtils.youtubeToMp3}?youtube_url=$youtubeUrlEncoded');
    var request = http.Request("POST", uri);
    request.send().timeout(Duration(minutes: _end), onTimeout: () {
      request.finalize();
      Fluttertoast.showToast(
          msg: "Timeout. Try again!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: AppColors.onPrimary,
          fontSize: 16.0);
      throw TimeoutException("Timeout");
    }).then((response) async {
      if (response.statusCode == 200) {
        var tmp = jsonDecode(await response.stream.bytesToString());
        Fluttertoast.showToast(
            msg: tmp["message"],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: AppColors.success,
            textColor: AppColors.onSuccess,
            fontSize: 16.0);
      } else {
        print("Upload Failed!");
      }
    }).catchError((e) {
      Fluttertoast.showToast(
          msg: "Error occured. Try again!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: AppColors.onPrimary,
          fontSize: 16.0);
      onRefresh();
    }).then((value) async {
      Fluttertoast.showToast(
          msg: "Generating...",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: AppColors.primary,
          textColor: AppColors.onPrimary,
          fontSize: 16.0);
      await getSubtitleFromAudioUploadedByYoutube();
    });
  }

  Future<void> onCopy() async {
    if (rawText == "" && transcriptText == "") {
      Fluttertoast.showToast(
          msg: "No text to copy",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: AppColors.primary,
          textColor: AppColors.onPrimary,
          fontSize: 16.0);
      return;
    }
    await Clipboard.setData(
        ClipboardData(text: showAsRawText ? rawText : transcriptText));
    Fluttertoast.showToast(
        msg: "Copied to clipboard",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColors.primary,
        textColor: AppColors.onPrimary,
        fontSize: 16.0);
  }

  void onSwitch() {
    setState(() {
      showAsRawText = !showAsRawText;
    });
  }

  void onRefresh() async {
    bool canClearTemp =
        await FilePicker.platform.clearTemporaryFiles() ?? false;
    if (canClearTemp) {
      print("Temporary files cleared");
    }
    setState(() {
      rawText = "";
      transcriptText = "";
      file = PlatformFile(path: null, name: "", size: 0);
      downloading = false;
      youtubeURL = "";
      language = "";
    });
  }

  void _select(Choice choice) {
    setState(() {
      // Causes the app to rebuild with the new _selectedChoice.
      _selectedChoice = choice;
    });
    Fluttertoast.showToast(
        msg: "Accuracy changed to ${choice.accuracy}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColors.primary,
        textColor: AppColors.onPrimary,
        fontSize: 16.0);
  }

  Future<void> loadJson() async {
    await rootBundle
        .loadString('assets/countries.json')
        .then((json) => jsonDecode(json))
        .then((countries) => countries as List)
        .then((countries) => countries.map((e) => Country.fromJson(e)).toList())
        .then((countries) {
      setState(() {
        _countries = countries;
      });
    });
  }

  @override
  void initState() {
    _controller = TextEditingController();
    loadJson();
    super.initState();
  }

  void dispose() {
    FilePicker.platform.clearTemporaryFiles();
    _controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    bool isShow = rawText != "" || transcriptText != "";
    return Scaffold(
      appBar: AppBar(
          title: const Text("SubLan"),
          titleTextStyle: CustomTextStyle.custom(
              color: Colors.black, size: 30, fontWeight: FontWeight.w600),
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            isShow
                ? TextButton(
                    onPressed: onSwitch,
                    style: TextButton.styleFrom(
                      maximumSize: const Size(80, 50),
                    ),
                    child: Text(
                        "Change to ${showAsRawText ? "transcript" : "raw"}"),
                  )
                : Container(),
            isShow
                ? IconButton(
                    icon: const Icon(Icons.content_copy_outlined),
                    onPressed: onCopy,
                    color: Colors.black,
                    tooltip: "Copy to clipboard",
                  )
                : Container(),
            rawText != "" || transcriptText != ""
                ? IconButton(
                    icon: const Icon(Icons.refresh_outlined),
                    onPressed: onRefresh,
                    color: Colors.black,
                    tooltip: "Refresh",
                  )
                : Container(),
            !downloading && rawText == "" && transcriptText == ""
                ? PopupMenuButton<Choice>(
                    icon: const Icon(
                      Icons.percent_outlined,
                      color: Colors.black,
                    ),
                    tooltip: "Choose model",
                    onSelected: _select,
                    itemBuilder: (BuildContext context) {
                      return choices.map((Choice choice) {
                        bool isActive = _selectedChoice.title == choice.title;
                        return PopupMenuItem<Choice>(
                          value: choice,
                          child: Text(
                            choice.accuracy,
                            style: CustomTextStyle.custom(
                                color:
                                    isActive ? AppColors.primary : Colors.black,
                                fontWeight: isActive
                                    ? FontWeight.w900
                                    : FontWeight.w400,
                                size: isActive ? 18 : 16),
                          ),
                        );
                      }).toList();
                    },
                  )
                : Container(),
          ]),
      body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  file.path == null
                      ? Text(
                          "Upload your audio file or use Youtube URL to get subtitles",
                          style: CustomTextStyle.custom(
                              color: Colors.black, size: 30),
                        )
                      : Container(),
                  const SizedBox(
                    height: 20,
                  ),
                  file.path != null
                      ? Column(children: [
                          Text(
                            "File name: ${file.name}",
                            style: CustomTextStyle.normal(color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "File size: ${(file.size / 1048576).toStringAsFixed(2)} MB",
                            style: CustomTextStyle.normal(color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "File extension: ${file.extension}",
                            style: CustomTextStyle.normal(color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                        ])
                      : Container(),
                  const SizedBox(
                    height: 20,
                  ),
                  downloading
                      ? Column(children: [
                          const CircularProgressIndicator(),
                          Text(
                            "Please wait...We are generating subtitles for you",
                            style: CustomTextStyle.normal(color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "Accuracy: ${_selectedChoice.accuracy}",
                            style: CustomTextStyle.normal(color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            choices.indexOf(_selectedChoice) > 1
                                ? "Higher accuracy can take more time (up to 10 minutes) to generate subtitles. Let's wait for it and enjoy your coffee ☕😉"
                                : "",
                            style: CustomTextStyle.normal(color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ])
                      : const SizedBox(
                          height: 20,
                        ),
                  language != ""
                      ? Text(
                          "Language: ${language.toUpperCase()}",
                          style: CustomTextStyle.large(color: Colors.black),
                        )
                      : Container(),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    showAsRawText ? rawText : transcriptText,
                    style: CustomTextStyle.large(color: Colors.black),
                  ),
                ],
              ))),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AvatarGlow(
              endRadius: 75.0,
              glowColor: downloading ? AppColors.onInfo : AppColors.tertiary,
              child: FloatingActionButton(
                tooltip: "Upload from Youtube",
                onPressed: () async {
                  if (downloading) return;
                  final name = await wg.showBottomModal(context,
                      controller: _controller);
                  if (name == null) return;
                  setState(() {
                    youtubeURL = name;
                  });
                  await uploadYoutubeByUrl();
                },
                backgroundColor:
                    downloading ? AppColors.onInfo : AppColors.onPrimary,
                child: Icon(
                  Icons.link_outlined,
                  color: downloading ? AppColors.info : AppColors.primary,
                ),
              )),
          AvatarGlow(
              endRadius: 75.0,
              glowColor: downloading ? AppColors.onInfo : AppColors.primary,
              child: FloatingActionButton(
                tooltip: "Upload your audio file",
                onPressed: () async {
                  if (downloading) return;
                  await uploadAudio();
                },
                backgroundColor:
                    downloading ? AppColors.onInfo : AppColors.primary,
                child: Icon(
                  Icons.file_upload_outlined,
                  color: downloading ? AppColors.info : AppColors.onPrimary,
                ),
              ))
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation
          .centerDocked, // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class Choice {
  const Choice({required this.title, this.accuracy = "Low"});
  final String title;
  final String accuracy;
}

const List<Choice> choices = <Choice>[
  Choice(title: 'Tiny', accuracy: 'Low'),
  Choice(title: 'Base', accuracy: 'Normal'),
  Choice(title: 'Small', accuracy: "Medium"),
  Choice(title: 'Medium', accuracy: "High"),
  // Choice(title: 'Large'),
  // Choice(title: 'Large-v2'),
];

class ChoiceCard extends StatelessWidget {
  const ChoiceCard({Key? key, required this.choice}) : super(key: key);

  final Choice choice;

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = CustomTextStyle.medium(color: Colors.black);
    return Card(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(choice.title, style: textStyle),
          ],
        ),
      ),
    );
  }
}
