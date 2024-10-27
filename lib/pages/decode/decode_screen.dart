import 'package:flutter/material.dart';

import 'package:morse_code/pages/decode/flashlight/flashlight_screen.dart';
import 'package:morse_code/pages/decode/sound/sound_screen.dart';

import 'chat/chat_screen.dart';

enum MorseCodeOptions { chat, flashlight, sound }

class DecodeScreen extends StatefulWidget {
  const DecodeScreen({super.key});

  @override
  State<DecodeScreen> createState() {
    return DecodeHomeState();
  }
}

class DecodeHomeState extends State<DecodeScreen>
    with SingleTickerProviderStateMixin {
  // tabs
  List<String> tabsNames = ["Chat", "Flashlight", "Sound"];
  List<IconData> tabsIcons = [
    Icons.chat,
    Icons.flashlight_on,
    Icons.music_note
  ];

  // availability
  Map<MorseCodeOptions, bool> morseCodeOptionsAvailability = {
    MorseCodeOptions.chat: true,
    MorseCodeOptions.flashlight: true,
    MorseCodeOptions.sound: true
  };

  // receivers managers

  //

  MorseCodeOptions morseCodeOption = MorseCodeOptions.chat;

  late final TabController _tabController =
      TabController(length: tabsNames.length, vsync: this);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabsNames.length, // Number of tabs
      child: Column(
        children: [
          TabBar(
            tabs: List.generate(
              tabsNames.length,
              (index) => Tab(
                text: tabsNames[index],
                icon: Icon(tabsIcons[index], color: Colors.lightBlue),
              ),
            ),
            indicatorColor: Colors.lightBlue,
            labelColor: Colors.lightBlue,
            controller: _tabController,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                ChatScreen(),
                FlashlightScreen(),
                SoundScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
