import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        centerTitle: true,
      ),
      body: GetBuilder<HomeController>(builder: (controller) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          color: Colors.yellow,
                          child: Text(
                              controller.stateText == "Connected"
                                  ? "Connected to broker : ${controller.hostTextController.text}"
                                  : controller.stateText,
                              textAlign: TextAlign.center)),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 45,
                  child: TextFormField(
                    controller: controller.hostTextController,
                    decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        label: const Text("Broker"),
                        hintStyle: const TextStyle(height: 0.5),
                        hintText: "Enter broker address",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5))),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: MaterialButton(
                        color: Colors.lightBlueAccent,
                        onPressed: controller.currentState ==
                                MQTTAppConnectionState.disconnected
                            ? () {
                                controller.connect();
                              }
                            : () {},
                        child: const Text('Connect'), //
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      // ignore: deprecated_member_use
                      child: MaterialButton(
                        color: Colors.redAccent,
                        onPressed: () {
                          controller.disconnect();
                        },

                        child: const Text('Disconnect'), //
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 45,
                  child: TextFormField(
                    controller: controller.topicTextController,
                    decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        label: const Text("Topic"),
                        hintStyle: const TextStyle(height: 0.5),
                        hintText: "Enter a topic to subscribe or listen",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5))),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: MaterialButton(
                        color: Colors.lightBlueAccent,
                        onPressed: () {
                          controller.subscribeToTopic(
                              controller.topicTextController.text);
                        },
                        child: const Text('Subscribe'), //
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      // ignore: deprecated_member_use
                      child: MaterialButton(
                        color: Colors.redAccent,
                        onPressed: () {
                          controller.unSubscribeToTopic(
                              controller.topicTextController.text);
                        },
                        child: const Text('Unsubscribe'), //
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 45,
                      child: TextFormField(
                        controller: controller.messageTextController,
                        decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            label: const Text("Message"),
                            hintStyle: const TextStyle(height: 0.5),
                            hintText: "Type a message",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5))),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      height: 45,
                      child: TextFormField(
                        controller: controller.messageTopicTextController,
                        decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            label: const Text("Topic"),
                            hintStyle: const TextStyle(height: 0.5),
                            hintText: "Enter a topic",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5))),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    MaterialButton(
                      color: Colors.blue,
                      onPressed: () {
                        String message = controller.messageTextController.text;
                        controller.publish(
                            message, controller.topicTextController.text);
                        controller.messageTopicTextController.clear();
                      },
                      child: const Text("Publish"),
                      //tcp://broker.hivemq.com:1883
                    )
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                    width: 400,
                    height: 200,
                    child: SingleChildScrollView(
                      child: Text(controller.historyText),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}


