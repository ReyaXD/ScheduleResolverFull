import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/ai_schedule_service.dart';

class RecommendationScreen extends StatelessWidget {
  const RecommendationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // FIXED: Changed AiScheduleService to AiScheduleAnalysis to match the class definition
    final aiService = Provider.of<AiScheduleAnalysis>(context);
    final analysis = aiService.currentAnalysis;

    if (analysis == null) {
      return const Scaffold(
        body: Center(child: Text('No recommendations available yet.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Schedule Recommendation'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSection(
                context,
                'Detected Conflicts',
                analysis.conflicts,
                Colors.red.shade50,
                Icons.warning_amber_rounded,
                Colors.red.shade900
            ),
            const SizedBox(height: 16),
            _buildSection(
                context,
                'Ranked Tasks',
                analysis.rankedTasks,
                Colors.blue.shade50,
                Icons.format_list_numbered,
                Colors.blue.shade900
            ),
            const SizedBox(height: 16),
            _buildSection(
                context,
                'Recommended Schedule',
                analysis.recommendedSchedule,
                Colors.green.shade50,
                Icons.calendar_today,
                Colors.green.shade900
            ),
            const SizedBox(height: 16),
            _buildSection(
                context,
                'Explanation',
                analysis.explanation,
                Colors.orange.shade50,
                Icons.lightbulb_outline,
                Colors.orange.shade900
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
      BuildContext context,
      String title,
      String content,
      Color bgColor,
      IconData icon,
      Color iconColor
      ) {
    return Card(
      color: bgColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: iconColor.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 24, color: iconColor),
                const SizedBox(width: 12),
                Text(
                    title,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: iconColor
                    )
                ),
              ],
            ),
            const Divider(height: 24),
            Text(
                content.isEmpty ? "No data provided for this section." : content,
                style: const TextStyle(fontSize: 15, height: 1.6, color: Colors.black87)
            ),
          ],
        ),
      ),
    );
  }
}