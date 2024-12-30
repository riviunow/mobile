import 'package:flutter/material.dart';
import 'package:udetxen/features/creating/knowledge/models/create.dart';
import 'package:udetxen/shared/models/enums/material_type.dart' as enums;

class AddMaterialDialog extends StatefulWidget {
  final ValueChanged<MaterialParams> onAddMaterial;

  const AddMaterialDialog({super.key, required this.onAddMaterial});

  @override
  State<AddMaterialDialog> createState() => _AddMaterialDialogState();
}

class _AddMaterialDialogState extends State<AddMaterialDialog> {
  final _formKey = GlobalKey<FormState>();
  final _contentController = TextEditingController();
  enums.MaterialType _selectedType = enums.MaterialType.textSmall;
  final List<MaterialParams> _children = [];

  void _addChild(MaterialParams child) {
    setState(() {
      _children.add(child);
    });
  }

  void _removeChild(MaterialParams child) {
    setState(() {
      _children.remove(child);
    });
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final material = MaterialParams(
        type: _selectedType,
        content: _contentController.text,
        children: _children,
      );
      widget.onAddMaterial(material);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Material'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(labelText: 'Content'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter content';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<enums.MaterialType>(
                value: _selectedType,
                decoration: const InputDecoration(labelText: 'Type'),
                items: enums.MaterialType.values.map((enums.MaterialType type) {
                  return DropdownMenuItem<enums.MaterialType>(
                    value: type,
                    child: Text(type.toJson()),
                  );
                }).toList(),
                onChanged: (enums.MaterialType? newValue) {
                  setState(() {
                    _selectedType = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildChildrenSection(),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Add'),
        ),
      ],
    );
  }

  Widget _buildChildrenSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Children',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ..._children.map((child) => _buildChildItem(child)),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () => _showAddChildDialog(),
          child: const Text('Add Child'),
        ),
      ],
    );
  }

  Widget _buildChildItem(MaterialParams child) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        title: Text(child.content),
        subtitle: Text(child.type.toJson()),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => _removeChild(child),
        ),
      ),
    );
  }

  void _showAddChildDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AddMaterialDialog(
          onAddMaterial: _addChild,
        );
      },
    );
  }
}
