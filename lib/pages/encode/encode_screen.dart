import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:morse_code/pages/components/basic_chat.dart';

import 'package:morse_code/pages/components/message.dart';

import 'package:morse_code/pages/encode/transmit_morse_code.dart';
import 'package:morse_code/pages/encode/vibrations/vibration_manager.dart';
import '../morse_code_text.dart';
import 'package:morse_code/pages/encode/flashlight/flashlight_manager.dart';
import 'package:morse_code/pages/encode/flashlight/morse_code_flashlight_transmitter.dart';
import 'vibrations/morse_code_vibration_transmitter.dart';



enum MorseCodeOptions { chat, flashlight, vibrations, sound }

class EncodeScreen extends StatefulWidget {
  const EncodeScreen({super.key});

  @override
  State<EncodeScreen> createState() {
    return EncodeScreenState();
  }
}

class EncodeScreenState extends State<EncodeScreen> with SingleTickerProviderStateMixin {
  // tabs
  List<String> tabsNames = ["Chat", "Flashlight", "Vibrations", "Sound"];
  List<IconData> tabsIcons = [
    Icons.chat,
    Icons.flashlight_on,
    Icons.vibration,
    Icons.music_note
  ];
  late final TabController _tabController =
  TabController(length: tabsNames.length, vsync: this);

  // availability
  Map<MorseCodeOptions, bool> morseCodeOptionsAvailability = {
    MorseCodeOptions.chat: true,
    MorseCodeOptions.flashlight: true,
    MorseCodeOptions.vibrations: true,
    MorseCodeOptions.sound: true,
  };

  // managers
  final FlashlightManager flashlightManager = FlashlightManager();
  final VibrationManager vibrationManager = VibrationManager();

  // transmitters
  late final MorseCodeFlashlightTransmitter flashlightTransmitter = MorseCodeFlashlightTransmitter(
      flashlightManager);
  late final MorseCodeVibrationTransmitter vibrationTransmitter = MorseCodeVibrationTransmitter(
      vibrationManager);

  // transmit options
  late final Map<MorseCodeOptions,
      TransmitMorseCode> morseCodeTransmitOptions = {
    MorseCodeOptions.flashlight: flashlightTransmitter,
    MorseCodeOptions.vibrations: vibrationTransmitter
  };

  // currently selected option
  MorseCodeOptions morseCodeOption = MorseCodeOptions.chat;

  // messages history
  List<Message> messagesList = [];

  @override
  void initState() {
    super.initState();
    _tabController.addListener(onTabChange);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void onTabChange() {
    MorseCodeOptions selectedOption =
    MorseCodeOptions.values[_tabController.index];

    if (morseCodeOptionsAvailability[selectedOption] == false) {
      String tabName = tabsNames[_tabController.index];

      Fluttertoast.showToast(
          msg: "$tabName seems not available now.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);

      _tabController.index = _tabController.previousIndex;

      return;
    }

    morseCodeOption = selectedOption;
  }

  void onSubmitMessage(String message) {
    String morseCode = MorseCodeText.encode(message);

    if (morseCode.trim() == "") {
      Fluttertoast.showToast(
          msg: "Message must contain alphanumerical characters",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);

      return;
    }

    messagesList.add(Message(message: message, isMe: true));
    messagesList.add(Message(message: morseCode, isMe: false));

    startTransmittingMorseCode(morseCode);
  }

  void startTransmittingMorseCode(morseCode) async {
    if (!morseCodeTransmitOptions.containsKey(morseCodeOption)) {
      return;
    }

    await morseCodeTransmitOptions[morseCodeOption]?.transmit(morseCode);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.blueGrey[300],
          child: TabBar(
            tabs: List.generate(
              tabsNames.length,
                  (index) =>
                  Tab(
                    text: tabsNames[index],
                    icon: Icon(tabsIcons[index], ),
                  ),
            ),
            indicatorColor:  Colors.blueGrey[900],
            labelColor:  Colors.blueGrey[900],
            unselectedLabelColor:  Colors.blueGrey[600],
            controller: _tabController,
          ),
        ),
        Expanded(
          child: BasicChat(
              messagesList: messagesList,
              onSubmitMessage: onSubmitMessage
          ),
        ),
      ],
    );
  }
}
