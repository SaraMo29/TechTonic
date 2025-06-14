import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graduation_project/components/ValidatedTextFormField.dart';
import 'package:graduation_project/components/custom_dropdown_formField.dart';
import 'package:graduation_project/controllers/regestration_controller.dart';

class InstructorExtraInfoScreen extends StatefulWidget {
  final String name;
  final String email;
  final String password;

  InstructorExtraInfoScreen({
    Key? key,
    required this.name,
    required this.email,
    required this.password,
  }) : super(key: key);

  @override
  State<InstructorExtraInfoScreen> createState() =>
      _InstructorExtraInfoScreenState();
}

class _InstructorExtraInfoScreenState extends State<InstructorExtraInfoScreen> {
  final RegistrationController controller = Get.find<RegistrationController>();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    controller.nameController.text = widget.name;
    controller.emailController.text = widget.email;
    controller.passwordController.text = widget.password;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Stack(
        children: [
          Scaffold(
            appBar: AppBar(title: const Text("Instructor Extra Info")),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    ValidatedTextFormField(
                      textEditingController: controller.jobTitleController,
                      label: 'Job Title',
                      icon: Icons.work,
                    ),
                    const SizedBox(height: 10),
                    ValidatedTextFormField(
                      textEditingController: controller.jobDescriptionController,
                      label: 'Job Description',
                      icon: Icons.description,
                    ),
                    const SizedBox(height: 10),
                    Obx(() => CustomDropdownFormField(
                          value: controller.selectedGender.value.isNotEmpty
                              ? controller.selectedGender.value
                              : 'male',
                          items: const ['male', 'female'],
                          label: 'Gender',
                          icon: Icons.person,
                          onChanged: (value) {
                            if (value != null) {
                              controller.selectedGender.value = value;
                            }
                          },
                        )),
                    const SizedBox(height: 10),
                    ValidatedTextFormField(
                      textEditingController: controller.linkedinUrlController,
                      label: 'LinkedIn URL',
                      icon: Icons.link,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if (controller.selectedGender.value.isEmpty) {
                            Get.snackbar(
                              'Validation Error',
                              'Please select your gender',
                              snackPosition: SnackPosition.TOP,
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                            return;
                          }
                          await controller.registerWithEmail("instructor");
                        }
                      },
                      child: const Text("Sign Up as Instructor"),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (controller.isLoading.value)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      );
    });
  }
}
