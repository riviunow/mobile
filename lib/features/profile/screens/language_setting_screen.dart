import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rvnow/shared/config/theme/colors.dart';
import 'package:rvnow/shared/services/translation_service.dart';

class LanguageSettingsScreen extends StatelessWidget {
  static route() {
    return MaterialPageRoute<void>(
      builder: (_) => getInstance(),
    );
  }

  static Widget getInstance() {
    return const LanguageSettingsScreen();
  }

  const LanguageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final translationService = Provider.of<TranslationService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('language_settings'.tr()),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Row(
              children: [
                Text('show_translations'.tr()),
                const SizedBox(width: 8),
                Switch(
                  value: translationService.showTranslation,
                  onChanged: (value) {
                    translationService.toggleShowTranslation();
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            FutureBuilder<(List<(String, String)>, List<(String, String)>)>(
              future: translationService.getModels(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox();
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                } else {
                  final (downloaded, notDownloaded) = snapshot.data!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...downloaded.map((model) => Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color:
                                      model.$2 == translationService.getUserLang
                                          ? AppColors.secondary
                                          : Theme.of(context).primaryColor),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              title: Text("${model.$2} - ${model.$1}"),
                              trailing: PopupMenuButton<String>(
                                onSelected: (String result) {
                                  if (result == 'set_as_default') {
                                    translationService.saveUserLang(
                                        context, model.$2);
                                  } else if (result == 'delete') {
                                    translationService.deleteModel(
                                        context, model.$2);
                                  }
                                },
                                itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry<String>>[
                                  PopupMenuItem<String>(
                                    value: 'set_as_default',
                                    enabled: model.$2 !=
                                        translationService.getUserLang,
                                    child: Text('set_as_default'.tr()),
                                  ),
                                  PopupMenuItem<String>(
                                    value: 'delete',
                                    child: Text('delete'.tr()),
                                  ),
                                ],
                              ),
                            ),
                          )),
                      const SizedBox(height: 16),
                      ...notDownloaded.map((model) => Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.hint),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              title: Text("${model.$2} - ${model.$1}"),
                              trailing: PopupMenuButton<String>(
                                onSelected: (String result) {
                                  if (result == 'download') {
                                    translationService.downloadModel(model.$2);
                                  }
                                },
                                itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry<String>>[
                                  PopupMenuItem<String>(
                                    value: 'set_as_default',
                                    enabled: false,
                                    child: Text('set_as_default'.tr()),
                                  ),
                                  PopupMenuItem<String>(
                                    value: 'download',
                                    child: Text('download'.tr()),
                                  ),
                                ],
                              ),
                            ),
                          )),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
