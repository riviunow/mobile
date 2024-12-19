import 'package:flutter/material.dart';
import 'package:udetxen/shared/models/enums/material_type.dart';
import 'package:udetxen/shared/models/index.dart' as models;

class KnowledgeMaterialList extends StatelessWidget {
  final List<models.Material> materials;

  const KnowledgeMaterialList({super.key, required this.materials});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: materials
          .map((material) => _buildMaterialItem(context, material))
          .toList(),
    );
  }

  Widget _buildMaterialItem(BuildContext context, models.Material material) {
    return Card(
      color: Theme.of(context).primaryColor,
      shadowColor: Theme.of(context).scaffoldBackgroundColor,
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 6.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              material.content,
              style: TextStyle(
                fontSize: MaterialTypeExtension.getFontSize(material.type),
                color: Theme.of(context).scaffoldBackgroundColor,
                // fontWeight: FontWeight.bold,
              ),
            ),
            if (material.children.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: KnowledgeMaterialList(materials: material.children),
              ),
          ],
        ),
      ),
    );
  }
}
