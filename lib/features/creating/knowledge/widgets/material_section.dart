import 'package:flutter/material.dart';
import 'package:udetxen/features/creating/knowledge/models/create.dart';
import 'package:udetxen/shared/models/enums/material_type.dart' as enums;

class MaterialSection extends StatelessWidget {
  final List<MaterialParams> materials;
  final ValueChanged<MaterialParams> onAddMaterial;
  final ValueChanged<int> onRemoveMaterial;
  final ValueChanged<MapEntry<int, MaterialParams>> onUpdateMaterial;

  const MaterialSection({
    super.key,
    required this.materials,
    required this.onAddMaterial,
    required this.onRemoveMaterial,
    required this.onUpdateMaterial,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Materials',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...materials.asMap().entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: MaterialInputField(
                  index: entry.key,
                  material: entry.value,
                  onRemove: (index) => onRemoveMaterial(index),
                  onUpdate: (entry) => onUpdateMaterial(entry),
                  level: 0,
                ),
              ),
            ),
        ElevatedButton.icon(
          onPressed: () => onAddMaterial(MaterialParams(
            type: enums.MaterialType.textMedium,
            content: '',
            children: [],
          )),
          icon: const Icon(Icons.add),
          label: const Text('Add Material'),
        ),
      ],
    );
  }
}

class MaterialInputField extends StatefulWidget {
  final int index;
  final MaterialParams material;
  final ValueChanged<int> onRemove;
  final ValueChanged<MapEntry<int, MaterialParams>> onUpdate;
  final int level;

  const MaterialInputField({
    super.key,
    required this.index,
    required this.material,
    required this.onRemove,
    required this.onUpdate,
    required this.level,
  });

  @override
  State<MaterialInputField> createState() => _MaterialInputFieldState();
}

class _MaterialInputFieldState extends State<MaterialInputField> {
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(text: widget.material.content);
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  void _addChild() {
    final updatedMaterial = MaterialParams(
      type: enums.MaterialType.textMedium,
      content: '',
      children: [],
    );
    final newMaterial = widget.material.copyWith(
      children: [...widget.material.children, updatedMaterial],
    );

    widget.onUpdate(MapEntry(widget.index, newMaterial));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Dismissible(
        key: ValueKey(widget.index),
        direction: DismissDirection.startToEnd,
        onDismissed: (direction) {
          widget.onRemove(widget.index);
        },
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        child: Container(
          decoration: BoxDecoration(
            border: widget.level == 0
                ? null
                : Border(
                    left: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 1.0,
                    ),
                  ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
                left: widget.level == 0 ? 2 : 8,
                top: widget.level == 0 ? 20 : 6,
                bottom: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: DropdownButtonFormField<enums.MaterialType>(
                        value: widget.material.type,
                        iconSize: 24 - widget.level * 3,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Type',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        selectedItemBuilder: (context) {
                          return enums.MaterialTypeExtension.nonRestValues()
                              .map((type) {
                            return Text(
                              type.getAcronym(),
                              overflow: TextOverflow.fade,
                            );
                          }).toList();
                        },
                        items: enums.MaterialTypeExtension.nonRestValues()
                            .map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    type.toJson(),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          if (newValue != null) {
                            final updatedMaterial =
                                widget.material.copyWith(type: newValue);
                            widget.onUpdate(
                                MapEntry(widget.index, updatedMaterial));
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      flex: 7,
                      child: TextField(
                        controller: _contentController,
                        onChanged: (value) {
                          final updatedMaterial =
                              widget.material.copyWith(content: value);
                          widget.onUpdate(
                              MapEntry(widget.index, updatedMaterial));
                        },
                        decoration: const InputDecoration(
                          labelText: 'Content',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                    ),
                    if (widget.level < 3)
                      IconButton(
                        icon: const Icon(Icons.add_circle, color: Colors.green),
                        tooltip: 'Add Child',
                        onPressed: _addChild,
                      ),
                  ],
                ),
                if (widget.material.children.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: widget.material.children.asMap().entries.map(
                        (entry) {
                          final childIndex = entry.key;
                          final childMaterial = entry.value;
                          return MaterialInputField(
                            key: ValueKey(childIndex),
                            index: childIndex,
                            material: childMaterial,
                            onRemove: (index) {
                              final updatedChildren = List<MaterialParams>.from(
                                  widget.material.children)
                                ..removeAt(index);
                              final updatedMaterial = widget.material
                                  .copyWith(children: updatedChildren);
                              widget.onUpdate(
                                  MapEntry(widget.index, updatedMaterial));
                            },
                            onUpdate: (entry) {
                              final updatedChildren = List<MaterialParams>.from(
                                  widget.material.children)
                                ..[entry.key] = entry.value;
                              final updatedMaterial = widget.material
                                  .copyWith(children: updatedChildren);
                              widget.onUpdate(
                                  MapEntry(widget.index, updatedMaterial));
                            },
                            level: widget.level + 1,
                          );
                        },
                      ).toList(),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
