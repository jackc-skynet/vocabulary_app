class WordModel {
  final String word;
  final String? phonetic;
  final List<Phonetic> phonetics;
  final List<Meaning> meanings;

  WordModel({
    required this.word,
    this.phonetic,
    required this.phonetics,
    required this.meanings,
  });

  factory WordModel.fromJson(Map<String, dynamic> json) {
    return WordModel(
      word: json['word'],
      phonetic: json['phonetic'],
      phonetics: (json['phonetics'] as List?)
              ?.map((e) => Phonetic.fromJson(e))
              .toList() ??
          [],
      meanings: (json['meanings'] as List?)
              ?.map((e) => Meaning.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class Phonetic {
  final String? text;
  final String? audio;

  Phonetic({this.text, this.audio});

  factory Phonetic.fromJson(Map<String, dynamic> json) {
    return Phonetic(
      text: json['text'],
      audio: json['audio'],
    );
  }
}

class Meaning {
  final String partOfSpeech;
  final List<Definition> definitions;

  Meaning({required this.partOfSpeech, required this.definitions});

  factory Meaning.fromJson(Map<String, dynamic> json) {
    return Meaning(
      partOfSpeech: json['partOfSpeech'],
      definitions: (json['definitions'] as List?)
              ?.map((e) => Definition.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class Definition {
  final String definition;
  final String? example;
  final List<String> synonyms;
  final List<String> antonyms;

  Definition({
    required this.definition,
    this.example,
    required this.synonyms,
    required this.antonyms,
  });

  factory Definition.fromJson(Map<String, dynamic> json) {
    return Definition(
      definition: json['definition'],
      example: json['example'],
      synonyms: (json['synonyms'] as List?)?.cast<String>() ?? [],
      antonyms: (json['antonyms'] as List?)?.cast<String>() ?? [],
    );
  }
}
