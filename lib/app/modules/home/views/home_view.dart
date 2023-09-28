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

//////////////////////////////////////////////////////////////////////////////

// class MQTTView extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _MQTTViewState();
//   }
// }

// class _MQTTViewState extends State<MQTTView> {
//   final TextEditingController _hostTextController = TextEditingController();
//   final TextEditingController _messageTextController = TextEditingController();
//   final TextEditingController _topicTextController = TextEditingController();
//   late MQTTAppState currentAppState;
//   late MQTTManager manager;

//   @override
//   void initState() {
//     super.initState();

//     /*
//     _hostTextController.addListener(_printLatestValue);
//     _messageTextController.addListener(_printLatestValue);
//     _topicTextController.addListener(_printLatestValue);

//      */
//   }

//   @override
//   void dispose() {
//     _hostTextController.dispose();
//     _messageTextController.dispose();
//     _topicTextController.dispose();
//     super.dispose();
//   }

//   /*
//   _printLatestValue() {
//     print("Second text field: ${_hostTextController.text}");
//     print("Second text field: ${_messageTextController.text}");
//     print("Second text field: ${_topicTextController.text}");
//   }

//    */

//   @override
//   Widget build(BuildContext context) {
//     final MQTTAppState appState = Provider.of<MQTTAppState>(context);
//     // Keep a reference to the app state.
//     currentAppState = appState;
//     final Scaffold scaffold = Scaffold(body: _buildColumn());
//     return scaffold;
//   }

//   Widget _buildAppBar(BuildContext context) {
//     return AppBar(
//       title: const Text('MQTT'),
//       backgroundColor: Colors.greenAccent,
//     );
//   }

//   Widget _buildColumn() {
//     return Column(
//       children: <Widget>[
//         _buildConnectionStateText(
//             _prepareStateMessageFrom(currentAppState.getAppConnectionState)),
//         _buildEditableColumn(),
//         _buildScrollableTextWith(currentAppState.getHistoryText)
//       ],
//     );
//   }

//   Widget _buildEditableColumn() {
//     return Padding(
//       padding: const EdgeInsets.all(20.0),
//       child: Column(
//         children: <Widget>[
//           _buildTextFieldWith(_hostTextController, 'Enter broker address',
//               currentAppState.getAppConnectionState),
//           const SizedBox(height: 10),
//           _buildTextFieldWith(
//               _topicTextController,
//               'Enter a topic to subscribe or listen',
//               currentAppState.getAppConnectionState),
//           const SizedBox(height: 10),
//           _buildPublishMessageRow(),
//           const SizedBox(height: 10),
//           _buildConnecteButtonFrom(currentAppState.getAppConnectionState)
//         ],
//       ),
//     );
//   }

//   Widget _buildPublishMessageRow() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: <Widget>[
//         Expanded(
//           child: _buildTextFieldWith(_messageTextController, 'Enter a message',
//               currentAppState.getAppConnectionState),
//         ),
//         _buildSendButtonFrom(currentAppState.getAppConnectionState)
//       ],
//     );
//   }

//   Widget _buildConnectionStateText(String status) {
//     return Row(
//       children: <Widget>[
//         Expanded(
//           child: Container(
//               color: Colors.deepOrangeAccent,
//               child: Text(status, textAlign: TextAlign.center)),
//         ),
//       ],
//     );
//   }

//   Widget _buildTextFieldWith(TextEditingController controller, String hintText,
//       MQTTAppConnectionState state) {
//     bool shouldEnable = false;
//     if (controller == _messageTextController &&
//         state == MQTTAppConnectionState.connected) {
//       shouldEnable = true;
//     } else if ((controller == _hostTextController &&
//             state == MQTTAppConnectionState.disconnected) ||
//         (controller == _topicTextController &&
//             state == MQTTAppConnectionState.disconnected)) {
//       shouldEnable = true;
//     }
//     return TextField(
//         enabled: shouldEnable,
//         controller: controller,
//         decoration: InputDecoration(
//           contentPadding:
//               const EdgeInsets.only(left: 0, bottom: 0, top: 0, right: 0),
//           labelText: hintText,
//         ));
//   }

//   Widget _buildScrollableTextWith(String text) {
    // return Padding(
    //   padding: const EdgeInsets.all(20.0),
    //   child: Container(
    //     width: 400,
    //     height: 200,
    //     child: SingleChildScrollView(
    //       child: Text(text),
    //     ),
    //   ),
    // );
//   }

//   Widget _buildConnecteButtonFrom(MQTTAppConnectionState state) {
//     return Row(
//       children: <Widget>[
        // Expanded(
        //   // ignore: deprecated_member_use
        //   child: MaterialButton(
        //     color: Colors.lightBlueAccent,
        //     child: const Text('Connect'),
        //     onPressed: state == MQTTAppConnectionState.disconnected
        //         ? _configureAndConnect
        //         : null, //
        //   ),
        // ),
        // const SizedBox(width: 10),
        // Expanded(
        //   // ignore: deprecated_member_use
        //   child: MaterialButton(
        //     color: Colors.redAccent,
        //     child: const Text('Disconnect'),
        //     onPressed: state == MQTTAppConnectionState.connected
        //         ? _disconnect
        //         : null, //
        //   ),
        // ),
//       ],
//     );
//   }

//   Widget _buildSendButtonFrom(MQTTAppConnectionState state) {
//     // ignore: deprecated_member_use
//     return MaterialButton(
//       color: Colors.green,
//       child: const Text('Send'),
//       onPressed: state == MQTTAppConnectionState.connected
//           ? () {
//               _publishMessage(_messageTextController.text);
//             }
//           : null, //
//     );
//   }

//   // Utility functions
  // String _prepareStateMessageFrom(MQTTAppConnectionState state) {
  //   switch (state) {
  //     case MQTTAppConnectionState.connected:
  //       return 'Connected';
  //     case MQTTAppConnectionState.connecting:
  //       return 'Connecting';
  //     case MQTTAppConnectionState.disconnected:
  //       return 'Disconnected';
  //   }
  // }

  // void _configureAndConnect() {
  //   // ignore: flutter_style_todos
  //   // TODO: Use UUID
  //   String osPrefix = 'Flutter_iOS';
  //   if (Platform.isAndroid) {
  //     osPrefix = 'Flutter_Android';
  //   }
  //   manager = MQTTManager(
  //       host: _hostTextController.text,
  //       topic: _topicTextController.text,
  //       identifier: osPrefix,
  //       state: currentAppState);
  //   manager.initializeMQTTClient();
  //   manager.connect();
  // }

//   void _disconnect() {
//     manager.disconnect();
//   }

//   void _publishMessage(String text) {
//     String osPrefix = 'Flutter_iOS';
//     if (Platform.isAndroid) {
//       osPrefix = 'Flutter_Android';
//     }
//     final String message = osPrefix + ' says: ' + text;
//     manager.publish(message);
//     _messageTextController.clear();
//   }
// }
