import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../widgets/common_widgets.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String selectedFilter = 'All';

  final List<Map<String, dynamic>> scanHistory = [
    {
      'disease': 'Newcastle Disease',
      'confidence': '91%',
      'date': 'May 25, 2025 - 9:41 AM',
      'imagePath': '',
      'status': 'disease',
    },
    {
      'disease': 'Coccidiosis',
      'confidence': '78%',
      'date': 'May 18, 2025 - 3:25 PM',
      'imagePath': '',
      'status': 'warning',
    },
    {
      'disease': 'Healthy',
      'confidence': '95%',
      'date': 'May 10, 2025 - 11:30 AM',
      'imagePath': '',
      'status': 'healthy',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan History'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
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
                    child: _StatCard(title: 'Total Scans', value: '12'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(title: 'Diseases Found', value: '3'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(title: 'Success Rate', value: '92%'),
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
              ...scanHistory.asMap().entries.map((entry) {
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
