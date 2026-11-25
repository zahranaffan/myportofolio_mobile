import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/models/project.dart';

class ProjectDetailScreen extends StatelessWidget {
  const ProjectDetailScreen({required this.project, super.key});

  final Project project;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(project.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (project.projectImageUrl.isNotEmpty) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  project.projectImageUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    color: Colors.black12,
                    child: const Text('Unable to load project image.'),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            Text(
              project.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Text(
              project.techStack,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Text(project.description),
            const SizedBox(height: 16),
            Text('Project URL', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            SelectableText(project.projectUrl),
          ],
        ),
      ),
    );
  }
}
