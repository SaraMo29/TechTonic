// screens/otp_verification_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:graduation_project/controllers/login_controller.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  final LoginController loginController = Get.find();
  int _remainingTime = 55;
  late Timer _timer;
  bool _isResendAvailable = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() => _remainingTime--);
      } else {
        setState(() => _isResendAvailable = true);
        _timer.cancel();
      }
    });
  }

  void _resendCode() {
    setState(() {
      _remainingTime = 55;
      _isResendAvailable = false;
    });
    _startTimer();
    loginController.sendOtp();
  }

  @override
  void dispose() {
    _otpController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String email = Get.arguments['email'];
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forgot Password", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            const Text("Code has been sent to your email", style: TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 30),
            Pinput(
              length: 6, 
              controller: _otpController,
              keyboardType: TextInputType.number,
              defaultPinTheme: PinTheme(
                width: 50,
                height: 60,
                textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              focusedPinTheme: PinTheme(
                width: 50,
                height: 60,
                textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onCompleted: (pin) {
                print("Entered OTP: $pin");
              },
            ),
            const SizedBox(height: 20),
            _isResendAvailable
                ? GestureDetector(
                    onTap: _resendCode,
                    child: const Text("Resend Code", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                  )
                : Text("Resend code in $_remainingTime s", style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 30),
            Obx(() => SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: loginController.isLoading.value
                    ? null
                    : () => loginController.verifyOtp(email, _otpController.text),
                child: loginController.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Verify", style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            )),
          ],
        ),
      ),
    );
  }
}