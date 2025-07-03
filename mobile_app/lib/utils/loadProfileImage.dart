import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_app/services/api_service.dart';
import 'package:mobile_app/services/dataCaching.dart';
import 'package:mobile_app/utils/colors.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile_app/utils/fetchData.dart';
import 'package:mobile_app/utils/fixPseudoJson.dart';

Future<String> loadProfileImage(BuildContext? context) async {
    final cachingService = CachingStorageService();
    final cachedProfile = await cachingService.getFromCache('profile');
    String profileImageUrl = "default.png";

    if (cachedProfile != null) {
      try {
        final profile = jsonDecode(cachedProfile);
          profileImageUrl = profile['profilepicurl'] ?? 'default.png';
      } catch (e) {
        print("Erreur décodage profil depuis le cache: $e");
      }
    } else {
      final token = await cachingService.getFromCache('token');
      if (token == null) {
        print("No token found, cannot fetch profile.");
        return profileImageUrl;
      }

      print("No profile in cache, fetching from API.");
      final response = await fetchFromApi(
        '/api/profile/me',
        headers: {
          'Authorization': "Bearer $token",
          'context': context.toString(),
        },
      );

      if (response != null) {
        profileImageUrl = response['profilepicurl'] ?? 'default.png';
        await cachingService.saveInCache(jsonEncode(response), 'profile');
        return profileImageUrl;
      }
    }
    return profileImageUrl;
  }