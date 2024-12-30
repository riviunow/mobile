import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udetxen/shared/models/index.dart';
import 'package:udetxen/shared/widgets/loader.dart';

import '../blocs/knowledge_detail_bloc.dart';
import '../widgets/knowledge.media_widget.dart';
import '../widgets/knowledge.material_list.dart';
import '../widgets/knowledge.tags_widget.dart';

class KnowledgeDetailScreen extends StatefulWidget {
  final Knowledge knowledge;

  static route({required Knowledge knowledge}) {
    return MaterialPageRoute<void>(
      builder: (_) => KnowledgeDetailScreen(knowledge: knowledge),
    );
  }

  const KnowledgeDetailScreen({super.key, required this.knowledge});

  @override
  State<KnowledgeDetailScreen> createState() => _KnowledgeDetailScreenState();
}

class _KnowledgeDetailScreenState extends State<KnowledgeDetailScreen> {
  @override
  void initState() {
    super.initState();
    context
        .read<KnowledgeDetailBloc>()
        .add(GetKnowledgeDetail(widget.knowledge.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          SingleChildScrollView(
            child: BlocBuilder<KnowledgeDetailBloc, KnowledgeDetailState>(
              builder: (context, state) {
                if (state is KnowledgeDetailLoading) {
                  return const Center(child: Loading());
                } else if (state is KnowledgeDetailLoaded) {
                  final knowledge = state.knowledge;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      KnowledgeMediaWidget(knowledge: knowledge),
                      KnowledgeMaterialList(
                          materials: knowledge.restMaterials,
                          isFirstLayer: true),
                      const SizedBox(height: 16),
                      KnowledgeTagsWidget(knowledge: knowledge),
                    ],
                  );
                } else if (state is KnowledgeDetailError) {
                  return Center(
                      child: Text('Error: ${state.messages.join('\n')}'));
                } else {
                  return const Center(child: Text('No data available'));
                }
              },
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: IconButton(
              icon: Icon(Icons.arrow_back,
                  size: 32, color: Theme.of(context).primaryColor),
              onPressed: () {
                Navigator.pop(context);
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                    Theme.of(context).scaffoldBackgroundColor),
                elevation: WidgetStateProperty.all(4),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
