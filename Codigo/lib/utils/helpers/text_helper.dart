abstract class TextHelper {
  static String extrairNome(String texto) {
    RegExp exp = RegExp(r"VULT SE\s+(.*?)\s*\(");
    RegExpMatch? match = exp.firstMatch(texto);
    String nome = match != null ? match.group(1) ?? "" : "";
    return nome;
  }
}
