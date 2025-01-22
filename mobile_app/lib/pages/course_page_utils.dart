class ErrorUtils {

  /// Generates a specific error message based on the user's response.
  ///
  /// If the answer doesn't match with the expected one, we try to help the user.
  /// We check what is wrong and if we know we inform the user.
  /// Error handling :
  /// - Missing or Too many capital(s).
  /// - Missing a point at the end of the sentence.
  /// - Missing or Too many space(s).
  ///
  /// Returns :
  /// - An error message string.

  static String generateErrorMessage(String userResponse, String expectedResponse) {
    if (userResponse.isEmpty) {
      return 'Le champ de saisie est vide. Veuillez entrer une réponse.';
    }

    if (userResponse.toLowerCase() == expectedResponse.toLowerCase()) {
      return 'Vérifiez la majuscule: il pourrait y avoir des majuscules en trop ou manquants.';
    }

    if (userResponse.replaceAll(' ', '') ==
        expectedResponse.replaceAll(' ', '')) {
      return 'Vérifiez les espaces : il pourrait y avoir des espaces en trop ou manquants.';
    }

    if (!userResponse.endsWith('.') && expectedResponse.endsWith('.')) {
      return 'Votre réponse manque un point à la fin.';
    }

    return 'Votre réponse est incorrecte. Veuillez revoir l’instruction.';
  }
}