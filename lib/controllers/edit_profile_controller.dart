import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import 'login_controller.dart';

class EditProfileController extends GetxController {
  var name = ''.obs;
  var gender = ''.obs;
  var profileImageUrl = ''.obs;
  File? profileImageFile;

  static const String baseUrl = 'https://nafsi.onrender.com/api/v1';
  String? token;

  void setToken(String t) {
    token = t;
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImageFile = File(pickedFile.path);
      update();
    }
  }

  Future<void> updateProfile() async {
    if (token == null) {
      Get.snackbar('Error', 'No token found');
      return;
    }

    final url = Uri.parse('$baseUrl/users/updateMe');
    var request = http.MultipartRequest('PUT', url); // <-- Changed to PUT
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['name'] = name.value;
    request.fields['gender'] = gender.value;

    if (profileImageFile != null) {
      request.files.add(await http.MultipartFile.fromPath('profileImage', profileImageFile!.path));
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final jsonRes = jsonDecode(response.body);
      if (jsonRes['status'] == 'SUCCESS') {
        name.value = jsonRes['data']['name'];
        gender.value = jsonRes['data']['gender'];
        profileImageUrl.value = jsonRes['data']['profileImage'];
        Get.snackbar('Success', 'Profile updated successfully!');
        Get.find<LoginController>().fetchUserProfile();
      } else {
        Get.snackbar('Error', jsonRes['message'] ?? 'Failed to update profile');
      }
    } else {
      Get.snackbar('Error', 'Failed to update profile: ${response.statusCode}');
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    if (token == null) return;
    final url = Uri.parse('$baseUrl/users/getMe');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final jsonRes = jsonDecode(response.body);
      if (jsonRes['status'] == 'SUCCESS') {
        final data = jsonRes['data'];
        name.value = data['name'] ?? '';
        gender.value = data['gender'] ?? '';
        profileImageUrl.value = data['profileImage']?.trim() ?? '';
        // Optionally, set profileImageFile if you want to allow immediate editing
      }
    }
  }
}