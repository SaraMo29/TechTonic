import 'package:flutter/material.dart';

class CustomPassTextfield extends StatefulWidget {
      final TextEditingController textEditingController;

  const CustomPassTextfield({super.key, required this.textEditingController});


  @override
  _CustomPassTextfieldState createState() => _CustomPassTextfieldState();
}

class _CustomPassTextfieldState extends State<CustomPassTextfield> {
  bool _isObscure = true;
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.textEditingController,
      onTap: () {
        setState(() {
          _isFocused = true;
        });
      },
      onEditingComplete: () {
        setState(() {
          _isFocused = false;
        });
      },
      decoration: InputDecoration(
        labelText: 'Password',
        prefixIcon: Icon(
          Icons.lock,
          color: _isFocused ? Colors.blue : Colors.black,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _isObscure ? Icons.visibility_off : Icons.visibility,
            color: _isFocused ? Colors.blue : Colors.black,
          ),
          onPressed: () {
            setState(() {
              _isObscure = !_isObscure;
            });
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: _isFocused ? Colors.blue : Colors.black,
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Colors.blue,
            width: 2.0,
          ),
        ),
      ),
      obscureText: _isObscure,
    );
  }
}
