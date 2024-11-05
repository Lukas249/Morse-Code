abstract class TransmitMorseCode {

  Future<void> transmit(String morseCode) async {
    List<String> morseCodeSplitByWords = morseCode.split(RegExp(r"\s{2,}"));

    for(int i = 0; i < morseCodeSplitByWords.length; i++) {
      final word = morseCodeSplitByWords[i];

      List<String> morseCodeSplitByChars = word.split(RegExp(r"\s"));

      for(int j = 0; j < morseCodeSplitByChars.length; j++) {
        String encodedChar = morseCodeSplitByChars[j];

        for(int k = 0; k < encodedChar.length; k++) {
          String char = encodedChar[k];

          if(char == ".") {
            await transmitDot();
          } else if(char == "-") {
            await transmitDash();
          }

          if(k < encodedChar.length - 1) {
            await waitTimeGapBetweenDotsAndDashes();
          }
        }

        if(j < morseCodeSplitByChars.length - 1) {
          await waitTimeGapBetweenChars();
        }
      }

      if(i < morseCodeSplitByWords.length - 1) {
        await waitTimeGapBetweenWords();
      }
    }
  }

  Future<void> transmitDot();

  Future<void> transmitDash();

  Future<void> waitTimeGapBetweenDotsAndDashes();

  Future<void> waitTimeGapBetweenChars();

  Future<void> waitTimeGapBetweenWords();
}