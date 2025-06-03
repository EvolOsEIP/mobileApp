import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:mobile_app/utils/fetchData.dart';
import 'package:mobile_app/services/dataCaching.dart';

class ModuleService {
  Future<List<dynamic>> fetchModules() async {
    try {
      final cachingService = CachingStorageService();
      final cachedModules = await cachingService.getFromCache("roadmap");
      final token = await cachingService.getFromCache("token");

      // if (cachedModules != null) {
      //   print("Loading modules from cache");
      //   return jsonDecode(cachedModules);
      // }

      print(token.toString());
      // Fetch modules from the API
      List<dynamic> mod = await fetchFromApi(
        '/api/roadmap',
        headers: {'Authorization': "Bearer " + token.toString()},
      );
      if (mod.isEmpty) {
        print("No modules found, loading local JSON");
        // If no modules are found, load the local JSON file
        return fetchFromJson('assets/json/offline_modules.json');
      }else {
        await cachingService.saveInCache(
          jsonEncode(mod),
          "roadmap",
        );
      }
      return mod;
    } catch (e) {
      print("Error fetching from API, loading local JSON: $e");
      return fetchFromJson('assets/json/offline_modules.json');
    }
  }
}
