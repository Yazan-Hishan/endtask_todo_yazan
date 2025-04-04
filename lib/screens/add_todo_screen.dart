import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../models/todo.dart';
import '../controllers/todo_controller.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({Key? key}) : super(key: key);

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  final TodoController _todoController = Get.find<TodoController>();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // دالة لاختيار التاريخ
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      locale: const Locale('ar', 'SA'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Get.theme.colorScheme.primary,
              onPrimary: Colors.white,
              surface: Get.theme.cardColor,
              onSurface: Get.theme.textTheme.bodyLarge!.color!,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      // بعد اختيار التاريخ، نفتح نافذة اختيار الوقت
      _selectTime(context, pickedDate);
    }
  }

  // دالة لاختيار الوقت
  Future<void> _selectTime(BuildContext context, DateTime pickedDate) async {
    final TimeOfDay initialTime = _selectedTime ?? TimeOfDay.now();

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Get.theme.colorScheme.primary,
              onPrimary: Colors.white,
              surface: Get.theme.cardColor,
              onSurface: Get.theme.textTheme.bodyLarge!.color!,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
        _selectedDate = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      });
    } else {
      // إذا لم يختر المستخدم وقتًا، نستخدم التاريخ فقط
      setState(() {
        _selectedTime = null;
        _selectedDate = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة مهمة جديدة'),
          centerTitle: true,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // أيقونة
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      color: Get.theme.colorScheme.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.assignment_add,
                      size: 48,
                      color: Get.theme.colorScheme.primary,
                    ),
                  ),

                  // حقل عنوان المهمة
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'عنوان المهمة*',
                      prefixIcon: Icon(Icons.title),
                      hintText: 'أدخل عنوان المهمة',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'يرجى إدخال عنوان المهمة';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // حقل وصف المهمة
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'وصف المهمة (اختياري)',
                      prefixIcon: Icon(Icons.description),
                      hintText: 'أدخل وصفاً للمهمة',
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),

                  // اختيار تاريخ المهمة
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Get.theme.colorScheme.primary.withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              right: 8,
                              top: 4,
                              bottom: 8,
                            ),
                            child: Text(
                              'موعد الاستحقاق',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Get.theme.colorScheme.primary,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  icon: const Icon(Icons.calendar_month),
                                  label: Text(
                                    _selectedDate == null
                                        ? 'اختر تاريخ ووقت الاستحقاق (اختياري)'
                                        : DateFormat(
                                          'yyyy/MM/dd - HH:mm',
                                        ).format(_selectedDate!),
                                  ),
                                  onPressed: () => _selectDate(context),
                                ),
                              ),
                              if (_selectedDate != null)
                                IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    setState(() {
                                      _selectedDate = null;
                                      _selectedTime = null;
                                    });
                                  },
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // زر الحفظ
                  Obx(
                    () => ElevatedButton.icon(
                      onPressed:
                          _todoController.isLoading
                              ? null
                              : () async {
                                if (_formKey.currentState!.validate()) {
                                  final newTodo = Todo(
                                    title: _titleController.text.trim(),
                                    description:
                                        _descriptionController.text
                                                .trim()
                                                .isNotEmpty
                                            ? _descriptionController.text.trim()
                                            : null,
                                    dueDate: _selectedDate,
                                  );

                                  await _todoController.addTodo(newTodo);

                                  if (_todoController.error == null) {
                                    Get.back();
                                  }
                                }
                              },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      icon:
                          _todoController.isLoading
                              ? const SizedBox.shrink()
                              : const Icon(Icons.save),
                      label:
                          _todoController.isLoading
                              ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Get.theme.colorScheme.onPrimary,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Text('جاري الحفظ...'),
                                ],
                              )
                              : const Text(
                                'حفظ المهمة',
                                style: TextStyle(fontSize: 16),
                              ),
                    ),
                  ),

                  // عرض رسائل الخطأ
                  Obx(() {
                    if (_todoController.error != null) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red.shade200),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Colors.red,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _todoController.error!,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                ],
              ),
            ),
          ),
        ),
      );
  }
}
