import 'package:flutter/foundation.dart';
import 'package:mobile_app/utils/fetchData.dart';
import 'package:mobile_app/services/dataCaching.dart';

/// Service class responsible for fetching information from an API
class ApiService {
  /// Fetches the required data from the API.
  ///
  /// [endpoint] - The endpoint which should be retrieved.
  /// [jsonToLoad] - The local JSON file to load if the API call fails.
  /// Returns the required data in Json format.
  Future<List<dynamic>> fetch(String endpoint, String jsonToLoad) async {
    final cachingService = CachingStorageService();
    final token = await cachingService.getFromCache("token");

    if (token == null) {
      if (kDebugMode) {
        print("No token found, loading local JSON: $jsonToLoad");
      }
      return fetchFromJson(jsonToLoad);
    }

    try {
      dynamic data = await fetchFromApi(
          '/api/$endpoint',
          headers: {'Authorization': "Bearer " + token.toString()});

      if (data.isEmpty) {
        data = await fetchFromJson(jsonToLoad);
      }
      return data;
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching from API, loading local JSON: $e");
      }
      return fetchFromJson(jsonToLoad);
    }
  }

  Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    final cachingService = CachingStorageService();
    final token = await cachingService.getFromCache("token");
    print("################# PUTTING DATA #################");

    if (token == null) {
      if (kDebugMode) {
        print("No token found, cannot put data.");
      }
      return [];
    }

    try {
      print("Putting data to API at endpoint: $endpoint");
      dynamic response = await putToApi(
          '/api/$endpoint',
          data,
          headers: {'Authorization': "Bearer " + token.toString()});

      print("################# PUT RESPONSE #################");
      print("Response for /api/${endpoint}: ${response}");
      return response;
    } catch (e) {
      if (kDebugMode) {
        print("Error putting data to API: $e");
      }
      return [];
    }
  }

  Future<List<dynamic>> post(String endpoint, Map<String, dynamic> data, ) async {
    final cachingService = CachingStorageService();
    final token = await cachingService.getFromCache("token");
    print("################# POSTING DATA #################");

    if (token == null) {
      if (kDebugMode) {
        print("No token found, cannot post data.");
      }
      return [];
    }

    try {
      print("Posting data to API at endpoint: $endpoint");
      List<dynamic> response = await postToApi(
          '/api/$endpoint',
          data, {'Authorization': "Bearer " + token.toString()}
          );

      print("################# POST RESPONSE #################");
      print("Response for ${endpoint}: ${response}");
      return response;
    } catch (e) {
      if (kDebugMode) {
        print("Error posting data to API: $e");
      }
      return [];
    }
  }
  
}
