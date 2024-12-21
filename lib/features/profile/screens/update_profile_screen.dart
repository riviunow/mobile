import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:udetxen/features/profile/bloc/profile_bloc.dart';
import 'package:udetxen/features/profile/models/update_profile.dart';
import 'package:udetxen/shared/widgets/loader.dart';

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
  final _userNameController = TextEditingController();
  XFile? _image;

  @override
  void initState() {
    super.initState();
    final profileBloc = context.read<ProfileBloc>();
    final state = profileBloc.state;
    if (state is ProfileLoaded) {
      _userNameController.text = state.user.userName;
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    _image = pickedFile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdated) {
            Navigator.pop(context);
          }
        },
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: Loading());
            } else if (state is ProfileLoaded) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      if (_image != null)
                        Center(
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: FileImage(File(_image!.path)),
                          ),
                        ),
                      if (_image == null && state.user.photoUrl != null)
                        Center(
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(state.user.photoUrl!),
                          ),
                        ),
                      TextButton(
                        onPressed: _pickImage,
                        child: const Text('Change Photo'),
                      ),
                      TextFormField(
                        controller: _userNameController,
                        decoration:
                            const InputDecoration(labelText: 'Username'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your username';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final request = UpdateProfileRequest(
                              userName: _userNameController.text,
                              photo: _image,
                            );
                            context
                                .read<ProfileBloc>()
                                .add(UpdateProfile(request));
                          }
                        },
                        child: const Text('Update Profile'),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is ProfileError) {
              return Center(child: Text('Error: ${state.messages.join('\n')}'));
            } else {
              return const Center(child: Text('No data available'));
            }
          },
        ),
      ),
    );
  }
}
