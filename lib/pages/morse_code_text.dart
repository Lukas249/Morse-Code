
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
  };

  static String MORSE_CODE_CHAR_SEPARATOR = " ";
  static String MORSE_CODE_WORD_SEPARATOR = "   ";

  static String TEXT_WORD_SEPARATOR = " ";

  static String encode(String text) {
    List<List<String>> morseCodeSplitByWordsAndChars = [[]];

    for (int i = 0; i < text.length; i++) {
      String char = text[i].toLowerCase();
      String? nextChar = i + 1 < text.length ? text[i + 1].toLowerCase() : "";

      bool charIsAlphanumerical = charToMorseCodeMap[char] != null;
      bool nextCharIsAlphanumerical = charToMorseCodeMap[nextChar] != null;

      if (!charIsAlphanumerical && nextCharIsAlphanumerical) {
        // action should be taken only for the last character that is not alphanumerical in the sequence
        // add next word
        morseCodeSplitByWordsAndChars.add([]);
      } else if(charIsAlphanumerical) {
        // add next encoded char
        morseCodeSplitByWordsAndChars.last.add(charToMorseCodeMap[char]!);
      }
    }

    List<String> morseCodeSplitByWords = morseCodeSplitByWordsAndChars.map(
            (List<String> encodedChars) {
              return encodedChars.join(MORSE_CODE_CHAR_SEPARATOR).trim();
            }
    ).toList();

    return morseCodeSplitByWords.join(MORSE_CODE_WORD_SEPARATOR).trim();
  }

  static String decode(String morseCode) {
    List<String> morseCodeSplitByWords = morseCode.split(MORSE_CODE_WORD_SEPARATOR);

    List<List<String>> morseCodeSplitByWordsAndChars = morseCodeSplitByWords.map(
            (String encodedChars) {
          return encodedChars.split(MORSE_CODE_CHAR_SEPARATOR);
        }
    ).toList();

    String text = "";

    for(List<String> words in morseCodeSplitByWordsAndChars) {
      String word = "";

      for(String encodedChar in words) {
        word += morseCodeMap[encodedChar] ?? "";
      }

      text += word;

      if(word != "") {
        text += TEXT_WORD_SEPARATOR;
      }
    }

    return text.trim();
  }

  static bool isValidMorseCode(String morseCode) {

    for(int i = 0; i < morseCode.length; i++) {
      if(morseCode[i] != "." && morseCode[i] != "-" && morseCode[i] != " ") return false;
    }

    return true;
  }
}


