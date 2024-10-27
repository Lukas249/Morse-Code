
class MorseCodeText  {
  static Map<String, String> charToMorseCodeMap = {
    'a': '.-',
    'b': '-...',
    'c': '-.-.',
    'd': '-..',
    'e': '.',
    'f': '..-.',
    'g': '--.',
    'h': '....',
    'i': '..',
    'j': '.---',
    'k': '-.-',
    'l': '.-..',
    'm': '--',
    'n': '-.',
    'o': '---',
    'p': '.--.',
    'q': '--.-',
    'r': '.-.',
    's': '...',
    't': '-',
    'u': '..-',
    'v': '...-',
    'w': '.--',
    'x': '-..-',
    'y': '-.--',
    'z': '--..',
    '1': '.----',
    '2': '..---',
    '3': '...--',
    '4': '....-',
    '5': '.....',
    '6': '-....',
    '7': '--...',
    '8': '---..',
    '9': '----.',
    '0': '-----',
    ' ': '',
  };

  static Map<String, String> morseCodeMap = {
    '.-': 'a',
    '-...': 'b',
    '-.-.': 'c',
    '-..': 'd',
    '.': 'e',
    '..-.': 'f',
    '--.': 'g',
    '....': 'h',
    '..': 'i',
    '.---': 'j',
    '-.-': 'k',
    '.-..': 'l',
    '--': 'm',
    '-.': 'n',
    '---': 'o',
    '.--.': 'p',
    '--.-': 'q',
    '.-.': 'r',
    '...': 's',
    '-': 't',
    '..-': 'u',
    '...-': 'v',
    '.--': 'w',
    '-..-': 'x',
    '-.--': 'y',
    '--..': 'z',
    '.----': '1',
    '..---': '2',
    '...--': '3',
    '....-': '4',
    '.....': '5',
    '-....': '6',
    '--...': '7',
    '---..': '8',
    '----.': '9',
    '-----': '0',
    ' ': '',
    '  ': ' ',
  };

  static String encode(String text) {
    List<String> morseCode = [];

    for (int i = 0; i < text.length; i++) {
      String char = text[i].toLowerCase();
      String? nextChar = i + 1 < text.length ? text[i + 1].toLowerCase() : "";

      bool charIsSpace = char == " " || charToMorseCodeMap[char] == null;
      bool nextCharIsSpace = nextChar == " " || charToMorseCodeMap[nextChar] == null;

      if (charIsSpace && nextCharIsSpace) {
        continue;
      }

      if (charIsSpace) {
        morseCode.add(charToMorseCodeMap[" "]!);
        continue;
      }

      morseCode.add(charToMorseCodeMap[char]!);
    }

    return morseCode.join(" ").trim();
  }

  static String decode(String morseCode) {
    String sentence = "";

    int i = 0;

    while(i < morseCode.length) {
      String char = "";

      // read char
      while(i < morseCode.length && morseCode[i] != " ") {
        char += morseCode[i];
        i++;
      }

      int spaceLength = 0;

      // count all spaces between chars/words
      while(i < morseCode.length && morseCode[i] == " ") {
        spaceLength++;
        i++;
      }

      sentence += morseCodeMap[char] ?? "";

      if(spaceLength <= 1) continue;

      sentence += " ";
    }

    return sentence.trim();
  }
}


