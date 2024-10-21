import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class DownloadService {
  final Dio _dio;

  DownloadService(this._dio);

  Future<String?> downloadFile(String url, String filePath) async {
    try {
      // Download the file
      final response = await _dio.download(
        url,
        filePath,
        onReceiveProgress: (received, total) {
          // if (total != -1) {
          //   print('Downloading: ${(received / total * 100).toStringAsFixed(0)}%');
          // }
        },
      );

      if (response.statusCode == 200) {
        return filePath;
      } else {
        throw Exception('Failed to download file');
      }
    } catch (e) {
      throw Exception('Error downloading file: $e');
    }
  }
}
