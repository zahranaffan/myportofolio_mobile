import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/widgets/gradient_app_bar.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

class ProjectFormPage extends StatefulWidget {
  const ProjectFormPage({super.key});

  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  final _formKey = GlobalKey<FormState>();

  String _title = '';
  String _description = '';
  String _techStack = '';
  String _projectUrl = '';
  String _projectImageUrl = '';
  bool _isSubmitting = false;

  String? _validateUrl(String? value, {required bool required}) {
    final url = value?.trim() ?? '';
    if (url.isEmpty) {
      return required ? 'URL cannot be empty!' : null;
    }

    final uri = Uri.tryParse(url);
    final validScheme =
        uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
    if (uri == null || !validScheme || uri.host.isEmpty) {
      return 'Enter a valid HTTP or HTTPS URL.';
    }
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final loggedIn = await ensureLoggedIn(context);
    if (!mounted || !loggedIn) return;

    final authState = context.read<AuthState>();
    final token = authState.token;
    if (token == null) return;

    setState(() {
      _isSubmitting = true;
    });

    final newProject = Project(
      title: _title.trim(),
      description: _description.trim(),
      techStack: _techStack.trim(),
      projectUrl: _projectUrl.trim(),
      projectImageUrl: _projectImageUrl.trim(),
    );

    try {
      final createdProject = await context.read<ApiClient>().createProject(
        newProject,
        token: token,
      );
      if (!mounted) return;

      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Project successfully added!'),
          content: Text('Created project: ${createdProject.title}'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      if (!mounted) return;
      _formKey.currentState?.reset();
      setState(() {
        _title = '';
        _description = '';
        _techStack = '';
        _projectUrl = '';
        _projectImageUrl = '';
      });
    } on ApiException catch (error) {
      if (!mounted) return;

      if (error.statusCode == 401) {
        await authState.logout();
        if (!mounted) return;
        await ensureLoggedIn(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create project (${error.statusCode}).'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(title: const Text('Add Project Form')),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => _title = value,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Title cannot be empty!';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => _description = value,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Description cannot be empty!';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Tech Stack',
                hintText: 'Flutter, Django, Figma',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => _techStack = value,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Tech Stack cannot be empty!';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(
                labelText: 'Project URL',
                hintText: 'https://example.com',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => _projectUrl = value,
              validator: (value) => _validateUrl(value, required: true),
            ),
            const SizedBox(height: 16),
            TextFormField(
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(
                labelText: 'Project Image URL (Optional)',
                hintText: 'https://example.com/image.png',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => _projectImageUrl = value,
              validator: (value) => _validateUrl(value, required: false),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submit,
              child: _isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
