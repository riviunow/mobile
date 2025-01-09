import 'package:easy_localization/easy_localization.dart';
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
            SnackBar(
                content: Text('publication_request_deleted_successfully'.tr())),
          );
          Navigator.pop(context);
        } else if (state is DeletePublicationRequestError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.messages.join('\n')}')),
          );
        }
      },
      child: AlertDialog(
        title: Text('delete_publication_request'.tr()),
        content: Text('are_you_sure_to_delete_publication_request'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel'.tr()),
          ),
          ElevatedButton(
            onPressed: () {
              context
                  .read<DeletePublicationRequestBloc>()
                  .add(DeletePublicationRequest(request.id));
            },
            child: Text('delete'.tr()),
          ),
        ],
      ),
    );
  }
}
