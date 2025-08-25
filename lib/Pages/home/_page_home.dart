import 'package:flutter/material.dart';
import '../../widgets/_buildFunctionIcon.dart';
import '../../widgets/add_new_dialog.dart';

class HomePageContent extends StatelessWidget {
  const HomePageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section
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
                    'Cập nhật các phòng chống cháy nổ, cập nhật xây dựng bảo mật thế giới và các hiểm họa cháy nổ có thể xảy ra',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
            
            // Content section
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
                    Text(
                      'Fr',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                //Padiing các chức năng
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FunctionIcon(
                        icon: Icons.home,
                        color: Colors.black,
                        tooltip: "Quản lý nhà",
                        label: "Nhà", 
                        onTap: () {
                          debugPrint("Home clicked!");
                        },
                      ),
                      FunctionIcon(
                        icon: Icons.flash_on,
                        color: Colors.yellow[700]!,
                        tooltip: "Điện năng",
                        label: "Điện", 
                        onTap: () {
                          debugPrint("Power clicked!");
                        },
                      ),
                      FunctionIcon(
                        icon: Icons.water,
                        color: Colors.blue[600]!,
                        tooltip: "Nước",
                        label: "Nước", 
                        onTap: () {
                          debugPrint("Water clicked!");
                        },
                      ),
                      FunctionIcon(
                        icon: Icons.add,
                        color: Colors.grey[600]!,
                        tooltip: "Thêm mới",
                        label: "Thêm", 
                        onTap: () {
                          AddNewDialog.show(context);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            //Biểu Đồ Sử Dụng Điện
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
          ],
        ),
      ),
    );
  }
}