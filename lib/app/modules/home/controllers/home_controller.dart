import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

enum MQTTAppConnectionState { connected, disconnected, connecting }

class HomeController extends GetxController {
  MQTTAppConnectionState currentState = MQTTAppConnectionState.disconnected;
  MqttServerClient? client;
  final String identifier = Platform.localHostname;
  String host = "";
  final String topic = "";

  void initializeMQTTClient() {
    client = MqttServerClient(host, identifier);
    client!.port = 1883;
    client!.keepAlivePeriod = 20;
    client!.onDisconnected = onDisconnected;
    client!.secure = false;
    client!.logging(on: true);

    /// Add the successful connection callback
    client!.onConnected = onConnected;
    client!.onSubscribed = onSubscribed;

    final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier(identifier)
        .withWillTopic(
            'willtopic') // If you set this you must set a will message
        .withWillMessage('My Will message')
        .startClean() // Non persistent session for testing
        .withWillQos(MqttQos.atLeastOnce);
    client!.connectionMessage = connMess;
  }

  // Connect to the host
  void connect() async {
    host = hostTextController.text;
    initializeMQTTClient();
    assert(client != null);
    try {
      print('EXAMPLE::Mosquitto start client connecting....');
      setAppConnectionState(MQTTAppConnectionState.connecting);
      setStateText(currentState);
      await client!.connect();
      Get.rawSnackbar(
          padding: const EdgeInsets.all(20),
          message: "Successfully connected to broker : $host",
          backgroundColor: Colors.green);
    } on Exception catch (e) {
      print('EXAMPLE::client exception - $e');
      disconnect();
    }
  }

  void setAppConnectionState(MQTTAppConnectionState state) {
    currentState = state;
  }

  void disconnect() {
    if (client != null) {
      print('Disconnected');
      client!.disconnect();
      Get.rawSnackbar(
          padding: const EdgeInsets.all(20),
          message: "Disconnected!",
          backgroundColor: Colors.red);
    } else {
      Get.rawSnackbar(
          padding: const EdgeInsets.all(20),
          message: "You are not connected to any broker yet!",
          backgroundColor: Colors.red);
    }
  }

  void publish(String message, String topic) {
    if (client != null) {
      final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
      builder.addString(message);
      client!.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
      Get.rawSnackbar(
          padding: const EdgeInsets.all(20),
          message: "Message has been published successfully",
          backgroundColor: Colors.green);
    } else {
      Get.rawSnackbar(
          padding: const EdgeInsets.all(20),
          message: "You must connect to a broker in order to publish messages!",
          backgroundColor: Colors.red);
    }
  }

  /// The subscribed callback
  void onSubscribed(String topic) {
    print('EXAMPLE::Subscription confirmed for topic $topic');
  }

  /// The unsolicited disconnect callback
  void onDisconnected() {
    if (client!.connectionStatus!.returnCode ==
        MqttConnectReturnCode.noneSpecified) {}
    setAppConnectionState(MQTTAppConnectionState.disconnected);
    setStateText(currentState);
  }

  /// The successful connect callback
  void onConnected() {
    setAppConnectionState(MQTTAppConnectionState.connected);
    setStateText(currentState);
    print(' client connected....');

    client!.updates!.listen(onData);
  }

  final TextEditingController hostTextController = TextEditingController();
  final TextEditingController messageTextController = TextEditingController();
  final TextEditingController topicTextController = TextEditingController();
  final TextEditingController messageTopicTextController =
      TextEditingController();

  late String messagePrefix = "Message from $identifier : ";
  String receivedText = "";
  String historyText = '';
  String stateText = "";
  MQTTAppConnectionState appConnectionState =
      MQTTAppConnectionState.disconnected;

  void setReceivedText(String text) {
    receivedText = messagePrefix + text;
    historyText = '$historyText\n$receivedText';
  }

  onData(List<MqttReceivedMessage<MqttMessage?>>? c) {
    final MqttPublishMessage recMess = c![0].payload as MqttPublishMessage;

    final String pt =
        MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
    setReceivedText(pt);
    // historyText += "\n$receivedText";
    update();
  }

  @override
  void onInit() {
    setStateText(currentState);
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  subscribeToTopic(String topic) {
    if (client != null) {
      client!.subscribe(topic, MqttQos.atLeastOnce);
      Get.rawSnackbar(
          padding: const EdgeInsets.all(20),
          message: "Successfully subscribed to topic : $topic",
          backgroundColor: Colors.green);
      update();
    } else {
      Get.rawSnackbar(
          padding: const EdgeInsets.all(20),
          message: "Please connect to a broker in order to subscribe to topics",
          backgroundColor: Colors.red);
    }
  }

  unSubscribeToTopic(String topic) {
    if (client != null) {
      client!.unsubscribe(topic);
      client!.connect();
      Get.rawSnackbar(
          padding: const EdgeInsets.all(20),
          message: "Unsubscribed from topic : $topic",
          backgroundColor: Colors.red);
      update();
    } else {
      Get.rawSnackbar(
          padding: const EdgeInsets.all(20),
          message: "You are not connected to any broker yet!",
          backgroundColor: Colors.red);
    }
  }

  publishMessage(String message, String topic) {
    publish(message, topic);
    update();
  }

  @override
  void onClose() {
    super.onClose();
  }

  setStateText(MQTTAppConnectionState state) {
    switch (state) {
      case MQTTAppConnectionState.connected:
        stateText = 'Connected';
      case MQTTAppConnectionState.connecting:
        stateText = 'Connecting';
      case MQTTAppConnectionState.disconnected:
        stateText = 'Disconnected';
    }
    update();
  }
}
