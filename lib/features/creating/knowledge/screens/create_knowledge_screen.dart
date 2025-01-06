import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:udetxen/features/creating/knowledge/blocs/create_knowledge_bloc.dart';
import 'package:udetxen/features/creating/knowledge/models/create.dart';
import 'package:udetxen/features/exploring/knowledge/blocs/knowledge_topic_bloc.dart';
import 'package:udetxen/features/exploring/knowledge/blocs/knowledge_type_bloc.dart';
import 'package:udetxen/features/exploring/knowledge/models/knowledge_topic.dart';
import 'package:udetxen/features/exploring/knowledge/models/knowledge_type.dart';
import 'package:udetxen/features/exploring/knowledge/widgets/knowledge_type_filter.dart';
import 'package:udetxen/features/exploring/knowledge/widgets/knowledge_topic_filter.dart';
import 'package:udetxen/shared/models/enums/knowledge_level.dart';
import 'package:udetxen/shared/models/enums/material_type.dart' as enums;
import 'package:udetxen/shared/widgets/spaced_divider.dart';

import '../widgets/file_picker_section.dart';
import '../widgets/material_section.dart';
import '../widgets/navigation_buttons.dart';
import '../widgets/step_status_bar.dart';

class CreateKnowledgeScreen extends StatefulWidget {
  final String? title;

  static route({String? title}) {
    return MaterialPageRoute(
      builder: (context) => CreateKnowledgeScreen(title: title),
    );
  }

  const CreateKnowledgeScreen({super.key, this.title});

  @override
  State<CreateKnowledgeScreen> createState() => _CreateKnowledgeScreenState();
}

class _CreateKnowledgeScreenState extends State<CreateKnowledgeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _subTitleControllers = <TextEditingController>[];
  KnowledgeLevel _selectedLevel = KnowledgeLevel.beginner;
  List<String> _selectedKnowledgeTypeIds = [];
  List<String> _selectedKnowledgeTopicIds = [];
  final List<MaterialParams> _materials = [];
  final List<XFile> _selectedAudios = [];
  final List<XFile> _selectedImages = [];
  final List<XFile> _selectedVideos = [];
  final ImagePicker _picker = ImagePicker();

  int _currentStep = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    if (widget.title != null) {
      _titleController.text = widget.title!;
    }
    var typeBloc = context.read<KnowledgeTypeBloc>();
    if (typeBloc.state is! KnowledgeTypeLoaded) {
      typeBloc.add(GetKnowledgeTypes(KnowledgeTypesRequest()));
    }
    var topicBloc = context.read<KnowledgeTopicBloc>();
    if (topicBloc.state is! KnowledgeTopicLoaded) {
      topicBloc.add(GetKnowledgeTopics(KnowledgeTopicsRequest()));
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final request = CreateKnowledgeRequest(
        title: _titleController.text,
        level: _selectedLevel,
        knowledgeTypeIds: _selectedKnowledgeTypeIds,
        knowledgeTopicIds: _selectedKnowledgeTopicIds,
        materials: [
          ..._subTitleControllers.map((controller) => MaterialParams(
              type: enums.MaterialType.subtitle, content: controller.text)),
          ..._materials.map((e) => e.setOrder()),
        ],
        audio: _selectedAudios.firstOrNull,
        image: _selectedImages.firstOrNull,
        video: _selectedVideos.firstOrNull,
      );
      context.read<CreateKnowledgeBloc>().add(CreateKnowledge(request));
    }
  }

  Future<void> _pickAudio() async {}

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImages.add(pickedFile);
      });
    }
  }

  Future<void> _pickVideo() async {
    final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedVideos.add(pickedFile);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Knowledge'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      resizeToAvoidBottomInset: true,
      body: BlocListener<CreateKnowledgeBloc, CreateKnowledgeState>(
        listener: (context, state) {
          if (!mounted) return;

          if (state is CreateKnowledgeSuccess) {
            Future.microtask(() {
              if (mounted) Navigator.pop(context);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Knowledge created successfully!')),
            );
          } else if (state is CreateKnowledgeError) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.messages.join(', ')}')),
              );
            }
          }
        },
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                StepStatusBar(
                  currentStep: _currentStep,
                  onStepTapped: (index) => setState(() {
                    _currentStep = index;
                    _pageController.jumpToPage(index);
                  }),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height - kToolbarHeight,
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentStep = index;
                      });
                    },
                    children: [
                      _buildStepTitle(),
                      _buildStepFilePicker(),
                      _buildStepMaterial(),
                      _buildStepKnowledgeTopic(),
                      _buildStepKnowledgeType(),
                    ],
                  ),
                ),
                NavigationButtons(
                  currentStep: _currentStep,
                  onBack: () => setState(() {
                    _currentStep--;
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }),
                  onNext: () => setState(() {
                    _currentStep++;
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }),
                  onSubmit: _currentStep == 4 ? _submit : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepTitle() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Title'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a title';
              }
              return null;
            },
          ),
          const SpacedDivider(spacing: 26),
          DropdownButtonFormField<KnowledgeLevel>(
            value: _selectedLevel,
            decoration: const InputDecoration(labelText: 'Level'),
            items: KnowledgeLevel.values.map((KnowledgeLevel level) {
              return DropdownMenuItem<KnowledgeLevel>(
                value: level,
                child: Text(level.toJson()),
              );
            }).toList(),
            onChanged: (KnowledgeLevel? newValue) {
              setState(() {
                _selectedLevel = newValue!;
              });
            },
          ),
          const SpacedDivider(spacing: 26),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Subtitles',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ..._subTitleControllers.asMap().entries.map((entry) {
                final index = entry.key;
                final controller = entry.value;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: controller,
                          decoration: InputDecoration(
                            labelText: 'Subtitle',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a subtitle';
                            }
                            return null;
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            _subTitleControllers.removeAt(index);
                          });
                        },
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 12),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _subTitleControllers.add(TextEditingController());
                    });
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Subtitle'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 12.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildNextButton(1),
        ],
      ),
    );
  }

  Widget _buildStepFilePicker() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FilePickerSection(
            onPickAudio: _pickAudio,
            onPickImage: _pickImage,
            onPickVideo: _pickVideo,
            selectedAudios: _selectedAudios,
            selectedImages: _selectedImages,
            selectedVideos: _selectedVideos,
          ),
          const SizedBox(height: 16),
          _buildNextButton(2), // Go to next step (Materials)
        ],
      ),
    );
  }

  Widget _buildStepMaterial() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MaterialSection(
              materials: _materials,
              onAddMaterial: (MaterialParams material) {
                setState(() {
                  _materials.add(material);
                });
              },
              onRemoveMaterial: (int index) {
                setState(() {
                  if (index >= 0 && index < _materials.length) {
                    _materials.removeAt(index);
                  } else {
                    debugPrint('Invalid index: $index');
                  }
                });
              },
              onUpdateMaterial: (entry) {
                setState(() {
                  if (entry.key >= 0 && entry.key < _materials.length) {
                    _materials[entry.key] = entry.value;
                  } else {
                    debugPrint('Invalid index: ${entry.key}');
                  }
                });
              }),
          const SizedBox(height: 16),
          _buildNextButton(3),
        ],
      ),
    );
  }

  Widget _buildStepKnowledgeTopic() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            KnowledgeTopicFilter(
              selectedIds: _selectedKnowledgeTopicIds,
              onRequestUpdated: (ids) {
                setState(() {
                  _selectedKnowledgeTopicIds = ids;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepKnowledgeType() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            KnowledgeTypeFilter(
              selectedIds: _selectedKnowledgeTypeIds,
              onRequestUpdated: (ids) {
                setState(() {
                  _selectedKnowledgeTypeIds = ids;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextButton(int nextStep) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _currentStep = nextStep;
            _pageController.jumpToPage(nextStep);
          });
        },
        child: const Text('Next'),
      ),
    );
  }
}
