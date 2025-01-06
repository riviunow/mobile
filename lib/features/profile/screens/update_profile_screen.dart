import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:udetxen/features/profile/bloc/profile_bloc.dart';
import 'package:udetxen/features/profile/models/update_profile.dart';
import 'package:udetxen/shared/config/theme/colors.dart';
import 'package:udetxen/shared/constants/urls.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  static route() {
    return MaterialPageRoute<void>(
      builder: (_) => const UpdateProfileScreen(),
    );
  }

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? userPhotoUrl;
  final _userNameController = TextEditingController();
  final _userNameFocusNode = FocusNode();
  XFile? _image;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final profileBloc = context.read<ProfileBloc>();
    final state = profileBloc.state;
    if (state is ProfileLoaded) {
      _userNameController.text = state.user.userName;
      userPhotoUrl = state.user.photoUrl;
    }
    _userNameFocusNode.requestFocus();
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedFile;
    });
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final request = UpdateProfileRequest(
        userName: _userNameController.text,
        photo: _image,
      );
      context.read<ProfileBloc>().add(UpdateProfile(request));
    }
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _userNameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Profile'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdated) {
            setState(() {
              _isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile updated successfully')),
            );
            Navigator.of(context).pop();
          } else if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.messages.join(', '))),
            );
          } else if (state is ProfileLoading) {
            setState(() {
              _isLoading = true;
            });
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: _image != null
                            ? FileImage(File(_image!.path))
                            : (userPhotoUrl != null
                                ? NetworkImage(
                                    "${Urls.mediaUrl}/${userPhotoUrl!}")
                                : const AssetImage(
                                        'assets/images/default_avatar.png')
                                    as ImageProvider),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt),
                          onPressed: _pickImage,
                        ),
                      ),
                      if (_image != null)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.secondary,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'New',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _userNameController,
                  focusNode: _userNameFocusNode,
                  decoration: const InputDecoration(labelText: 'Username'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(14),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text('Update Profile'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
