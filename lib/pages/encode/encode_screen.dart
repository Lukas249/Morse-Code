import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:morse_code/pages/components/basic_chat.dart';

import 'package:morse_code/pages/components/message.dart';
import 'package:morse_code/pages/encode/sound/morse_code_sound_transmitter.dart';
import 'package:morse_code/pages/encode/sound/sound_manager.dart';

import 'package:morse_code/pages/encode/transmit_morse_code.dart';
import 'package:morse_code/pages/encode/vibrations/vibration_manager.dart';
import '../morse_code_text.dart';
import 'package:morse_code/pages/encode/flashlight/flashlight_manager.dart';
import 'package:morse_code/pages/encode/flashlight/morse_code_flashlight_transmitter.dart';
import 'vibrations/morse_code_vibration_transmitter.dart';
import 'package:morse_code/pages/settings/settings_screen.dart';

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

  final player = AudioPlayer();

  // managers
  final FlashlightManager flashlightManager = FlashlightManager();
  final VibrationManager vibrationManager = VibrationManager();
  late final SoundManager soundManager = SoundManager(player);

  // transmitters
  late final MorseCodeFlashlightTransmitter flashlightTransmitter = MorseCodeFlashlightTransmitter(
      flashlightManager);
  late final MorseCodeVibrationTransmitter vibrationTransmitter = MorseCodeVibrationTransmitter(
      vibrationManager);
  late final MorseCodeSoundTransmitter soundTransmitter = MorseCodeSoundTransmitter(
      soundManager);

  // transmit options
  late final Map<MorseCodeOptions,
      TransmitMorseCode> morseCodeTransmitOptions = {
    MorseCodeOptions.flashlight: flashlightTransmitter,
    MorseCodeOptions.vibrations: vibrationTransmitter,
    MorseCodeOptions.sound: soundTransmitter
  };

  bool isTransmitting = false;

  // currently selected option
  MorseCodeOptions morseCodeOption = MorseCodeOptions.chat;

  // messages history
  List<Message> messagesList = [];



  @override
  void initState() {
    super.initState();
    _tabController.addListener(onTabChange);
    initPlayer();
  }

  void initPlayer() async {
    await player.setPlayerMode(PlayerMode.lowLatency);
    await player.setReleaseMode(ReleaseMode.loop);
    await player.setVolume(1);
    await player.setSourceAsset("beep.mp3");
  }

  @override
  void dispose() {
    _tabController.dispose();
    player.dispose();
    super.dispose();
  }

  void onTabChange() {
    MorseCodeOptions selectedOption =
    MorseCodeOptions.values[_tabController.index];

    if (morseCodeOptionsAvailability[selectedOption] == false) {
      String tabName = tabsNames[_tabController.index];

      Fluttertoast.showToast(
          msg: "$tabName seems not available now.",
          toastLength: Toast.LENGTH_SHORT
      );

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
          toastLength: Toast.LENGTH_SHORT
      );

      return;
    }

    messagesList.add(Message(message: message, isMe: true));
    messagesList.add(Message(message: morseCode, isMe: false));

    startTransmittingMorseCode(morseCode,loop);
  }

  void startTransmittingMorseCode(morseCode, loop) async {
    if (!morseCodeTransmitOptions.containsKey(morseCodeOption)) {
      return;
    }

    setState(() {
      isTransmitting = true;
    });

    for (int i = 0; i < loop; i++) {
      await morseCodeTransmitOptions[morseCodeOption]?.transmit(morseCode);
      sleep(const Duration(seconds: 1));
    }

    setState(() {
      isTransmitting = false;
    });
  }

  void onTransmissionEnd() {
    morseCodeTransmitOptions[morseCodeOption]?.stopTransmission();
    setState(() {
      isTransmitting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // TabBar
        Container(
          child: TabBar(
            tabs: List.generate(
              tabsNames.length,
                  (index) =>
                  Tab(
                    text: tabsNames[index],
                    icon: Icon(
                      tabsIcons[index],
                    ),
                  ),
            ),
            controller: _tabController,
            dividerColor: Colors.transparent,
          ),
        ),
        Expanded(
          child: BasicChat(
              messagesList: messagesList,
              onSubmitMessage: onSubmitMessage,
              isTransmitting: isTransmitting,
              onTransmissionEnd: onTransmissionEnd
          ),
        ),
      ],
    );
  }
}