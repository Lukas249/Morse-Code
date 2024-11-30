abstract class TransmitMorseCode {
  bool _isTransmitting = false;

  Future<void> transmit(String morseCode) async {
    _isTransmitting = true;

    List<String> morseCodeSplitByWords = morseCode.split(RegExp(r"\s{2,}"));

    for (int i = 0; i < morseCodeSplitByWords.length; i++) {
      if (!_isTransmitting) break;

      final word = morseCodeSplitByWords[i];
      List<String> morseCodeSplitByChars = word.split(RegExp(r"\s"));

      for (int j = 0; j < morseCodeSplitByChars.length; j++) {
        if (!_isTransmitting) break;

        String encodedChar = morseCodeSplitByChars[j];

        for (int k = 0; k < encodedChar.length; k++) {
          if (!_isTransmitting) break;

          String char = encodedChar[k];

          if (char == ".") {
            await transmitDot();
          } else if (char == "-") {
            await transmitDash();
          }

          if (!_isTransmitting) break;

          if (k < encodedChar.length - 1) {
            await waitTimeGapBetweenDotsAndDashes();
          }
        }

        if (!_isTransmitting) break;

        if (j < morseCodeSplitByChars.length - 1) {
          await waitTimeGapBetweenChars();
        }
      }

      if (!_isTransmitting) break;

      if (i < morseCodeSplitByWords.length - 1) {
        await waitTimeGapBetweenWords();
      }
    }

    _isTransmitting = false;
  }

  void stopTransmission() {
    _isTransmitting = false;
  }

  Future<void> transmitDot();

  Future<void> transmitDash();

  Future<void> waitTimeGapBetweenDotsAndDashes();

  Future<void> waitTimeGapBetweenChars();

  Future<void> waitTimeGapBetweenWords();
}
