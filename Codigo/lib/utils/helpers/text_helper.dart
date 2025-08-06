abstract class TextHelper {
  static String extrairNome(String texto) {
    RegExp exp = RegExp(r"\((.*?)\)");
    RegExpMatch? match = exp.firstMatch(texto);
    return match != null ? match.group(1) ?? "" : "";
  }
}
