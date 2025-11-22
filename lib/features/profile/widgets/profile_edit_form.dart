import 'package:flutter/material.dart';

class ProfileEditForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController aboutController;
  final TextEditingController nip05Controller;

  const ProfileEditForm({
    super.key,
    required this.nameController,
    required this.aboutController,
    required this.nip05Controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Name',
            prefixIcon: Icon(Icons.badge),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: aboutController,
          decoration: const InputDecoration(
            labelText: 'About',
            prefixIcon: Icon(Icons.info),
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: nip05Controller,
          decoration: const InputDecoration(
            labelText: 'NIP-05',
            prefixIcon: Icon(Icons.verified),
            border: OutlineInputBorder(),
            hintText: 'name@domain.com',
          ),
        ),
      ],
    );
  }
}
