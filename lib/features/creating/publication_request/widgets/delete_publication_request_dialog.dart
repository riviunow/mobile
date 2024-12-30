import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udetxen/features/creating/publication_request/blocs/delete_publication_request_bloc.dart';
import 'package:udetxen/shared/models/index.dart';

class DeletePublicationRequestDialog extends StatelessWidget {
  final PublicationRequest request;

  const DeletePublicationRequestDialog({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeletePublicationRequestBloc,
        DeletePublicationRequestState>(
      listener: (context, state) {
        if (state is DeletePublicationRequestSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Publication request deleted successfully!')),
          );
          Navigator.pop(context);
        } else if (state is DeletePublicationRequestError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.messages.join('\n')}')),
          );
        }
      },
      child: AlertDialog(
        title: const Text('Delete Publication Request'),
        content: const Text(
            'Are you sure you want to delete this publication request?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context
                  .read<DeletePublicationRequestBloc>()
                  .add(DeletePublicationRequest(request.id));
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
