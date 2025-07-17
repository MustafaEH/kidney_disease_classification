import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class PredictionResult {
  final String disease;
  final double confidence;
  final String severity;
  final String message;
  final List<String> recommendations;
  final double timestamp;
  final bool validationError;

  PredictionResult({
    required this.disease,
    required this.confidence,
    required this.severity,
    required this.message,
    required this.recommendations,
    required this.timestamp,
    this.validationError = false,
  });

  factory PredictionResult.fromJson(Map<String, dynamic> json) {
    return PredictionResult(
      disease: json['disease'] ?? 'Unknown',
      confidence: (json['confidence'] ?? 0.0).toDouble(),
      severity: json['severity'] ?? 'Unknown',
      message: json['message'] ?? 'No message available',
      recommendations: List<String>.from(json['recommendations'] ?? []),
      timestamp: (json['timestamp'] ?? 0.0).toDouble(),
      validationError: json['validation_error'] ?? false,
    );
  }
}

class ApiService {
  // Try different URLs based on the platform
  static String get baseUrl {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000';
    } else if (Platform.isIOS) {
      // For iOS simulator
      return 'http://localhost:8000';
    } else {
      // For web or other platforms
      return 'http://localhost:8000';
    }
  }

  // Alternative URLs to try if the main one fails
  // For physical Android devices, we need the computer's IP address
  static List<String> get alternativeUrls => [
    // Your actual computer IP addresses
    'http://192.168.197.1:8000', // Your computer's IP address
    'http://192.168.116.1:8000', // Your computer's alternative IP
    // LDPlayer specific IPs
    'http://10.0.3.2:8000', // LDPlayer default
    'http://10.0.2.2:8000', // Standard Android emulator
    'http://10.0.2.15:8000', // Some LDPlayer versions
    'http://10.0.2.16:8000', // Alternative LDPlayer IP
    // Your actual computer IP address
    'http://192.168.1.4:8000', // Your computer's IP address
    'http://192.168.1.100:8000', // Alternative IP
    'http://192.168.0.100:8000', // Alternative IP
    'http://192.168.1.1:8000', // Router IP (usually doesn't work)
    'http://192.168.0.1:8000', // Alternative router IP
    'http://10.0.0.100:8000', // Some network setups
    'http://localhost:8000',
    'http://127.0.0.1:8000',
  ];

  static Future<PredictionResult> predictDisease(File imageFile) async {
    Exception? lastException;

    print('=== Starting API connection attempt ===');
    print('Platform: ${Platform.operatingSystem}');
    print('Base URL: $baseUrl');

    // Try the main URL first
    try {
      print('Trying main URL: $baseUrl');
      return await _makePredictionRequest(baseUrl, imageFile);
    } catch (e) {
      lastException = Exception('Main URL failed: $e');
      print('Main URL failed: $e');
    }

    // Try alternative URLs
    for (String url in alternativeUrls) {
      if (url == baseUrl) continue; // Skip the main URL we already tried

      try {
        print('Trying alternative URL: $url');
        return await _makePredictionRequest(url, imageFile);
      } catch (e) {
        lastException = Exception('URL $url failed: $e');
        print('URL $url failed: $e');
      }
    }

    print('=== All connection attempts failed ===');
    throw lastException ?? Exception('All connection attempts failed');
  }

  static Future<PredictionResult> _makePredictionRequest(
    String url,
    File imageFile,
  ) async {
    try {
      // Convert image to base64
      List<int> imageBytes = await imageFile.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      print('Sending request to: $url/predict-base64');

      // Prepare request
      final response = await http
          .post(
            Uri.parse('$url/predict-base64'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'image': base64Image}),
          )
          .timeout(const Duration(seconds: 30));

      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return PredictionResult.fromJson(data);
      } else {
        throw Exception(
          'Failed to predict disease: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error connecting to $url: $e');
    }
  }

  static Future<bool> isApiAvailable() async {
    print('=== Checking API availability ===');
    print('Platform: ${Platform.operatingSystem}');

    // Try the main URL first
    try {
      print('Checking main URL: $baseUrl/health');
      final response = await http
          .get(Uri.parse('$baseUrl/health'))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        print('✅ API available at: $baseUrl');
        return true;
      } else {
        print('❌ Main URL returned status: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Main URL health check failed: $e');
    }

    // Try alternative URLs
    for (String url in alternativeUrls) {
      if (url == baseUrl) continue;

      try {
        print('Checking alternative URL: $url/health');
        final response = await http
            .get(Uri.parse('$url/health'))
            .timeout(const Duration(seconds: 5));

        if (response.statusCode == 200) {
          print('✅ API available at: $url');
          return true;
        } else {
          print('❌ URL $url returned status: ${response.statusCode}');
        }
      } catch (e) {
        print('❌ Health check failed for $url: $e');
      }
    }

    print('❌ No API endpoints available');
    print('=== Troubleshooting tips for LDPlayer ===');
    print('1. Make sure your API server is running on port 8000');
    print('2. Try running find_ip.bat to get your computer\'s IP');
    print('3. Common LDPlayer IPs: 10.0.3.2, 10.0.2.2, 10.0.2.15');
    print('4. Check if Windows Firewall is blocking the connection');
    return false;
  }
}
