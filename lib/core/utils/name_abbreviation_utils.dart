class NameAbbreviationUtils {
  static String abbreviateName(String inputString) {
    final words = inputString
        .split(' ')
        .where((word) => word.isNotEmpty && word.toLowerCase() != 'dan')
        .toList();

    if (words.length <= 2) {
      return words.map((w) => w[0].toUpperCase() + w.substring(1)).join(' ');
    }

    // Jika lebih dari 2 kata, ambil huruf awal tiap kata
    return words.map((word) => word[0].toUpperCase()).join();
  }
}
