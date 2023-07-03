import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final box = GetStorage();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  File? _image;

  Future<void> _getImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  void _loadProfileData() {
    final name = box.read('name') as String?;
    final email = box.read('email') as String?;
    final phone = box.read('phone') as String?;
    final city = box.read('city') as String?;
    final address = box.read('address') as String?;

    _nameController.text = name ?? '';
    _emailController.text = email ?? '';
    _phoneController.text = phone ?? '';
    _cityController.text = city ?? '';
    _addressController.text = address ?? '';
  }

  void _saveProfileData() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final city = _cityController.text.trim();
    final address = _addressController.text.trim();

    if (_validateFields(name, email, phone, city, address)) {
      box.write('name', name);
      box.write('email', email);
      box.write('phone', phone);
      box.write('city', city);
      box.write('address', address);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile saved successfully')),
      );
    }
  }

  bool _validateFields(
    String name,
    String email,
    String phone,
    String city,
    String address,
  ) {
    if (name.isEmpty || email.isEmpty || phone.isEmpty || city.isEmpty || address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all the fields')),
      );
      return false;
    }

    if (!_isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid email')),
      );
      return false;
    }

    if (!_isValidPhoneNumber(phone)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid phone number')),
      );
      return false;
    }

    return true;
  }

  bool _isValidEmail(String email) {
    // Perform basic email validation
    // You can replace this with a more robust email validation logic
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegex.hasMatch(email);
  }

  bool _isValidPhoneNumber(String phone) {
    // Perform phone number validation
    // You can replace this with your preferred phone number validation logic
    final phoneRegex = RegExp(r'^[0-9]{10}$');
    return phoneRegex.hasMatch(phone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: () {
                  _getImageFromGallery();
                },
                child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _image == null
                        ? null
                        : Image.file(
                            File(_image!.path),
                            fit: BoxFit.cover,
                          ).image,
                    child: _image == null ? const Icon(Icons.person) : null),
              ),

              const SizedBox(height: 16),
              // Name text field
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 8.0),
              // Email text field
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 8.0),
              // Phone number text field
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
              ),
              const SizedBox(height: 8.0),
              // City text field
              TextField(
                controller: _cityController,
                decoration: const InputDecoration(labelText: 'City'),
              ),
              const SizedBox(height: 8.0),
              // Address text field
              TextField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
              ),
              const SizedBox(height: 16.0),
              // Save button
              ElevatedButton(
                onPressed: _saveProfileData,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
