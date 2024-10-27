abstract class TransmitMorseCode {
  Future<void> transmit(String morseCode);

  Future<void> transmitDot();

  Future<void> transmitDash();

  Future<void> waitTimeGapBetweenDotsAndDashes();

  Future<void> waitTimeGapBetweenChars();

  Future<void> waitTimeGapBetweenWords();
}