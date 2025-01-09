import 'package:flutter/material.dart';
import 'package:udetxen/shared/config/theme/colors.dart';
import 'package:udetxen/shared/models/enums/material_type.dart';
import 'package:udetxen/shared/models/index.dart' as models;
import 'package:udetxen/shared/services/translation_service.dart';
import 'package:udetxen/shared/widgets/loader.dart';

class KnowledgeMaterialList extends StatelessWidget {
  final List<models.Material> materials;
  final bool isFirstLayer;
  final bool? showTranslation;
  final TranslationService? translationService;

  const KnowledgeMaterialList(
      {super.key,
      required this.materials,
      this.isFirstLayer = false,
      this.showTranslation,
      this.translationService});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: materials
          .map((material) => _buildMaterialItem(
              context, material, showTranslation, translationService))
          .toList(),
    );
  }

  Widget _buildMaterialItem(BuildContext context, models.Material material,
      bool? showTranslation, TranslationService? translationService) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: !isFirstLayer
              ? Border(
                  left: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 1.0,
                  ),
                  bottom: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 1.0,
                  ),
                )
              : null,
        ),
        child: Padding(
          padding: isFirstLayer
              ? const EdgeInsets.only(left: 2, top: 4)
              : const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                material.content,
                style:
                    MaterialTypeExtension.getTextStyle(material.type, context),
              ),
              if (showTranslation == true)
                FutureBuilder<String>(
                  future: translationService?.translate(material.content),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Loading();
                    } else if (snapshot.hasError) {
                      return const SizedBox();
                    } else {
                      return Text(
                        snapshot.data ?? '',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: AppColors.hint),
                      );
                    }
                  },
                ),
              if (material.children.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: KnowledgeMaterialList(
                    materials: material.children,
                    showTranslation: showTranslation,
                    translationService: translationService,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
