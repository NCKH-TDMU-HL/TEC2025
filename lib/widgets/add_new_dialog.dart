import 'package:flutter/material.dart';
import '../../model/function_item.dart';

class AddNewDialog extends StatelessWidget {
  final void Function(FunctionItem) onAddFunction;
  final List<FunctionItem> existingFunctions;

  const AddNewDialog({
    super.key,
    required this.onAddFunction,
    required this.existingFunctions,
  });

  @override
  Widget build(BuildContext context) {
    final availableFunctions = _getAvailableFunctions();
    final screenHeight = MediaQuery.of(context).size.height;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: screenHeight * 0.75, // Giảm xuống 75% để tránh bị che
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header cố định
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Thêm Chức Năng',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                    iconSize: 24,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            
            // Nội dung có thể cuộn
            Flexible(
              child: availableFunctions.isEmpty
                  ? Container(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 64,
                            color: Colors.green[400],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Tất cả chức năng đã được thêm!',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Không còn chức năng nào để thêm',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      itemCount: availableFunctions.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final functionData = availableFunctions[index];
                        return _buildFeatureItem(
                          context,
                          icon: functionData['icon'],
                          title: functionData['title'],
                          subtitle: functionData['subtitle'],
                          color: functionData['color'],
                          onTap: () {
                            Navigator.of(context).pop();
                            _addFunction(context, functionData);
                          },
                        );
                      },
                    ),
            ),
            
            // Footer cố định
            Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, -1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Text(
                    '${availableFunctions.length} chức năng có sẵn',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey[100],
                      foregroundColor: Colors.grey[700],
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20, 
                        vertical: 8
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Đóng',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getAvailableFunctions() {
    final allFunctions = [
      {
        'id': 'wifi',
        'icon': Icons.wifi,
        'title': 'WiFi',
        'subtitle': 'Quản lý kết nối WiFi',
        'color': Colors.purple[600]!,
      },
      {
        'id': 'security',
        'icon': Icons.security,
        'title': 'An Ninh',
        'subtitle': 'Hệ thống camera và báo động',
        'color': Colors.red[600]!,
      },
      {
        'id': 'temperature',
        'icon': Icons.thermostat,
        'title': 'Nhiệt Độ',
        'subtitle': 'Điều khiển nhiệt độ phòng',
        'color': Colors.orange[600]!,
      },
      {
        'id': 'lighting',
        'icon': Icons.lightbulb_outline,
        'title': 'Ánh Sáng',
        'subtitle': 'Điều khiển đèn thông minh',
        'color': Colors.yellow[600]!,
      },
      {
        'id': 'music',
        'icon': Icons.music_note,
        'title': 'Âm Nhạc',
        'subtitle': 'Hệ thống âm thanh',
        'color': Colors.green[600]!,
      },
      {
        'id': 'doorlock',
        'icon': Icons.lock,
        'title': 'Khóa Cửa',
        'subtitle': 'Khóa thông minh',
        'color': Colors.brown[600]!,
      },
      {
        'id': 'garage',
        'icon': Icons.garage,
        'title': 'Garage',
        'subtitle': 'Điều khiển cửa garage',
        'color': Colors.grey[700]!,
      },
      {
        'id': 'garden',
        'icon': Icons.local_florist,
        'title': 'Vườn',
        'subtitle': 'Hệ thống tưới cây',
        'color': Colors.teal[600]!,
      },
      {
        'id': 'vacuum',
        'icon': Icons.cleaning_services,
        'title': 'Robot Hút Bụi',
        'subtitle': 'Điều khiển robot dọn dẹp',
        'color': Colors.indigo[600]!,
      },
      {
        'id': 'curtain',
        'icon': Icons.curtains,
        'title': 'Rèm Cửa',
        'subtitle': 'Rèm cửa tự động',
        'color': Colors.pink[600]!,
      },
    ];

    final existingIds = existingFunctions.map((f) => f.id).toSet();
    return allFunctions.where((f) => !existingIds.contains(f['id'])).toList();
  }

  void _addFunction(BuildContext context, Map<String, dynamic> functionData) {
    final newFunction = FunctionItem(
      id: functionData['id'],
      icon: functionData['icon'],
      color: functionData['color'],
      tooltip: functionData['title'],
      label: functionData['title'],
      onTap: () {
        debugPrint("${functionData['title']} clicked!");
        _showSnackBar(context, "Đã nhấn vào ${functionData['title']}");
      },
    );

    onAddFunction(newFunction);
    _showSnackBar(context, '${functionData['title']} đã được thêm');
  }

  Widget _buildFeatureItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.add,
                  size: 20,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  static void show(
    BuildContext context, {
    required void Function(FunctionItem) onAddFunction,
    required List<FunctionItem> existingFunctions,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AddNewDialog(
        onAddFunction: onAddFunction,
        existingFunctions: existingFunctions,
      ),
    );
  }
}