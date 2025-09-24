import 'package:flutter/material.dart';
import '../../widgets/_buildFunctionIcon.dart';
import '../../widgets/add_new_dialog.dart';
import '../../model/function_item.dart';
import '../../widgets/electric_chart.dart';
import '../../widgets/water_chart.dart';

class HomePageContent extends StatefulWidget {
  const HomePageContent({super.key});

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  List<FunctionItem> functionItems = [];
  bool isEditMode = false;
  
  final Set<String> _protectedFunctions = {'home', 'electric', 'water'};

  @override
  void initState() {
    super.initState();
    _initializeDefaultFunctions();
  }

  void _initializeDefaultFunctions() {
    functionItems = [
      FunctionItem(
        id: 'home',
        icon: Icons.home,
        color: Colors.black,
        tooltip: "Quản lý nhà",
        label: "Nhà",
        onTap: () {
          debugPrint("Home clicked!");
          _showSnackBar("Đã nhấn vào Nhà");
        },
      ),
      FunctionItem(
        id: 'electric',
        icon: Icons.flash_on,
        color: Colors.yellow[700]!,
        tooltip: "Điện năng",
        label: "Điện",
        onTap: () {
          debugPrint("Power clicked!");
          _showSnackBar("Đã nhấn vào Điện");
        },
      ),
      FunctionItem(
        id: 'water',
        icon: Icons.water,
        color: Colors.blue[600]!,
        tooltip: "Nước",
        label: "Nước",
        onTap: () {
          debugPrint("Water clicked!");
          _showSnackBar("Đã nhấn vào Nước");
        },
      ),
    ];
  }

  void _addNewFunction(FunctionItem newFunction) {
    setState(() {
      functionItems.add(newFunction);
    });
  }

  void _removeFunction(String functionId) {
    setState(() {
      functionItems.removeWhere((item) => item.id == functionId);
      if (!_hasRemovableFunctions()) {
        isEditMode = false;
      }
    });
  }

  bool _hasRemovableFunctions() {
    return functionItems.any((item) => !_protectedFunctions.contains(item.id));
  }

  void _toggleEditMode() {
    if (!_hasRemovableFunctions()) {
      _showSnackBar("Không có chức năng nào có thể xóa");
      return;
    }
    
    setState(() {
      isEditMode = !isEditMode;
    });
    
    if (isEditMode) {
      _showSnackBar("Chế độ chỉnh sửa: Nhấn dấu - để xóa");
    } else {
      _showSnackBar("Đã thoát chế độ chỉnh sửa");
    }
  }

  Widget _buildFunctionGrid() {
    List<Widget> allButtons = [];

    for (int i = 0; i < functionItems.length; i++) {
      final item = functionItems[i];
      final isProtected = _protectedFunctions.contains(item.id);
      
      allButtons.add(
        Stack(
          children: [
            FunctionIcon(
              icon: item.icon,
              color: item.color,
              tooltip: item.tooltip,
              label: item.label,
              onTap: isEditMode ? null : item.onTap,
            ),
            
            if (isEditMode && !isProtected)
              Positioned(
                top:  -2,
                right: 20,
                child: GestureDetector(
                  onTap: () => _showDeleteDialog(item),
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.remove,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    }

    allButtons.add(
      FunctionIcon(
        icon: Icons.add,
        color: Colors.grey[600]!,
        tooltip: "Thêm mới",
        label: "Thêm",
        onTap: isEditMode ? null : () => _showAddNewDialog(),
      ),
    );

    List<Widget> rows = [];
    for (int i = 0; i < allButtons.length; i += 4) {
      List<Widget> rowButtons = [];
      for (int j = i; j < i + 4 && j < allButtons.length; j++) {
        rowButtons.add(Expanded(child: allButtons[j]));
      }
      while (rowButtons.length < 4) {
        rowButtons.add(const Expanded(child: SizedBox()));
      }

      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: rowButtons,
        ),
      );

      if (i + 4 < allButtons.length) {
        rows.add(const SizedBox(height: 16));
      }
    }

    return Column(children: rows);
  }

  void _showAddNewDialog() {
    AddNewDialog.show(
      context,
      onAddFunction: _addNewFunction,
      existingFunctions: functionItems,
    );
  }

  void _showDeleteDialog(FunctionItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa chức năng'),
        content: Text('Bạn có muốn xóa "${item.label}" không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _removeFunction(item.id);
              _showSnackBar('Đã xóa ${item.label}');
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cập nhật các phòng chống cháy nổ, cập nhật xây dựng bảo mật thế giới và các hiểm hóa cháy nổ có thể xảy ra',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Chức Năng',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        TextButton.icon(
                          onPressed: _toggleEditMode,
                          icon: Icon(
                            isEditMode ? Icons.check : Icons.edit,
                            size: 16,
                          ),
                          label: Text(
                            isEditMode ? 'Xong' : 'Sửa',
                            style: const TextStyle(fontSize: 12),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: isEditMode ? Colors.blue : Colors.grey[400],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8, 
                              vertical: 4
                            ),
                            minimumSize: Size.zero,
                          ),
                        ),
                        
                        const SizedBox(width: 8),
                        Icon(
                          Icons.info_outline,
                          size: 14,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isEditMode 
                            ? 'Nhấn dấu - để xóa'
                            : 'Nhấn "Sửa" để chỉnh sửa',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isEditMode ? Colors.red[50] : Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                    border: isEditMode 
                      ? Border.all(color: Colors.red[200]!, width: 2)
                      : null,
                  ),
                  child: _buildFunctionGrid(),
                ),
              ],
            ),

            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Biểu đồ sử dụng điện',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 12),
            const ElectricChart(),

            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Biểu đồ sử dụng nước',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 12),
            const WaterChart(),
            
          ],
        ),
      ),
    );
  }
}