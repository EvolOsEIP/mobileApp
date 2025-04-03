import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile_app/utils/fetchData.dart';

class ModuleService {

  Future<List<dynamic>> fetchModules() async {
    try {
      List<dynamic> mod = await fetchFromApi(
        '/api/modules', headers: {'Authorization': dotenv.env['API_KEY'].toString()},
      );
      if (mod.isEmpty) {
        return fetchFromJson('assets/json/offline_modules.json');
      }
      return mod;
    } catch (e) {
      print("Error fetching from API, loading local JSON: $e");
      return fetchFromJson('assets/json/offline_modules.json');
    }
  }
}