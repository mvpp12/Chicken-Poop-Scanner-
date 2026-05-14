import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../widgets/common_widgets.dart';
import '../services/history_store.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String selectedFilter = 'All';

  List<Map<String, dynamic>> _filteredHistory(
    List<Map<String, dynamic>> history,
  ) {
    if (selectedFilter == 'All') return history;
    final key = selectedFilter.toLowerCase();
    return history.where((item) => item['status'] == key).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan History')),
      body: ValueListenableBuilder<List<Map<String, dynamic>>>(
        valueListenable: HistoryStore.instance.items,
        builder: (context, history, _) {
          final filteredHistory = _filteredHistory(history);
          final totalScans = history.length;
          final diseaseCount = history
              .where((item) => item['status'] == 'disease')
              .length;
          final healthyCount = history
              .where((item) => item['status'] == 'healthy')
              .length;
          final successRate = totalScans == 0
              ? 0
              : ((healthyCount / totalScans) * 100).round();

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Filter Tabs
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _FilterChip(
                          label: 'All',
                          isSelected: selectedFilter == 'All',
                          onTap: () {
                            setState(() => selectedFilter = 'All');
                          },
                        ),
                        const SizedBox(width: 8),
                        _FilterChip(
                          label: 'Healthy',
                          isSelected: selectedFilter == 'Healthy',
                          onTap: () {
                            setState(() => selectedFilter = 'Healthy');
                          },
                        ),
                        const SizedBox(width: 8),
                        _FilterChip(
                          label: 'Warning',
                          isSelected: selectedFilter == 'Warning',
                          onTap: () {
                            setState(() => selectedFilter = 'Warning');
                          },
                        ),
                        const SizedBox(width: 8),
                        _FilterChip(
                          label: 'Disease',
                          isSelected: selectedFilter == 'Disease',
                          onTap: () {
                            setState(() => selectedFilter = 'Disease');
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Statistics
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          title: 'Total Scans',
                          value: totalScans.toString(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          title: 'Diseases Found',
                          value: diseaseCount.toString(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          title: 'Success Rate',
                          value: '$successRate%',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Scan History List
                  Text(
                    'Recent Scans',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  if (filteredHistory.isEmpty)
                    const _EmptyState()
                  else
                    ...filteredHistory.asMap().entries.map((entry) {
                      int index = entry.key;
                      Map<String, dynamic> item = entry.value;
                      return HistoryCard(
                        disease: item['disease'],
                        confidence: item['confidence'],
                        date: item['date'],
                        imagePath: item['imagePath'],
                        status: item['status'],
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            '/detail',
                            arguments: {'index': index, 'item': item},
                          );
                        },
                      );
                    }).toList(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.lightGray,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? AppColors.white : AppColors.charcoal,
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;

  const _StatCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: AppColors.gray),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray.withOpacity(0.2), width: 1),
      ),
      child: Column(
        children: [
          const Icon(Icons.history_toggle_off, size: 40, color: AppColors.gray),
          const SizedBox(height: 12),
          Text(
            'No scans yet',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: AppColors.charcoal),
          ),
          const SizedBox(height: 6),
          const Text(
            'Run your first scan to see results here.',
            style: TextStyle(fontSize: 13, color: AppColors.gray),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
