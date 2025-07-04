String fixPseudoJson(String input) {
  // Étape 1 : Ajouter des guillemets aux clés
  String withQuotedKeys = input.replaceAllMapped(
    RegExp(r'(\w+):'),
    (match) => '"${match[1]}":',
  );

  // Étape 2 : Ajouter des guillemets aux valeurs texte, sauf si elles sont déjà valides JSON
  String fullyQuoted = withQuotedKeys.replaceAllMapped(
    RegExp(r':\s*([^"\[{,\]\}\s][^,\]\}\n]*)'),
    (match) {
      final rawValue = match[1]!.trim();

      // Si déjà entre guillemets, ne rien faire
      if (rawValue.startsWith('"') && rawValue.endsWith('"')) {
        return ': $rawValue';
      }

      // Si null, bool, nombre : ne rien faire
      if (rawValue == 'null' ||
          rawValue == 'true' ||
          rawValue == 'false' ||
          double.tryParse(rawValue) != null) {
        return ': $rawValue';
      }

      // Si date ISO (approximativement), ne rien faire
      if (RegExp(r'^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}').hasMatch(rawValue)) {
        return ': "$rawValue"';
      }

      // Sinon, c’est une string normale, on l’entoure de guillemets
      return ': "$rawValue"';
    },
  );

  return fullyQuoted;
}
