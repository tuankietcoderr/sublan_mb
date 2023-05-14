import 'package:flutter/material.dart';
import 'package:sublan/core/app_colors.dart';

Future<String?> showBottomModal(context,
    {required controller, double height = 1000}) {
  void submit() {
    Navigator.of(context).pop(controller.text);
  }

  return showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (builder) {
        return Container(
          height: height,
          color: Colors.transparent,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0, // has the effect of softening the shadow
                  spreadRadius: 0.0, // has the effect of extending the shadow
                )
              ],
            ),
            alignment: Alignment.topLeft,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(top: 5, left: 10),
                      child: const Text(
                        "Audio via Youtube URL",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: Colors.black87),
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 5, right: 5),
                        child: TextButton(
                          onPressed: () {
                            submit();
                          },
                          child: const Text(
                            "Submit",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        )),
                  ],
                ),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Color(0xfff8f8f8),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        autofocus: true,
                        keyboardType: TextInputType.url,
                        controller: controller,
                        decoration: InputDecoration(
                          hintText: "Enter Youtube URL",
                          hintStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff999999),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xff999999),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xff999999),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      });
}
