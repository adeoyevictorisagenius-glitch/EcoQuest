import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

class CloudinaryService {
  static const String cloudName = "djgekwsnu";
  static const String uploadPreset = "UPLOAD_PRESET";

  static Future<String> uploadImage(Uint8List imageBytes) async {
    final url = Uri.parse(
      "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
    );

    final request = http.MultipartRequest(
      "POST",
      url,
    );

    request.fields["upload_preset"] = uploadPreset;

    request.files.add(
      http.MultipartFile.fromBytes(
        "file",
        imageBytes,
        filename: "ecoquest_image.jpg",
      ),
    );

    final streamedResponse = await request.send();

    final response = await http.Response.fromStream(
      streamedResponse,
    );

    print("Cloudinary Status: ${response.statusCode}");
    print("Cloudinary Response: ${response.body}");

    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(
        data["error"]?["message"] ?? response.body,
      );
    }
    print(data["secure_url"]);
    return data["secure_url"];
  }
}
