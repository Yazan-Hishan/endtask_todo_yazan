import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../models/todo.dart';
import '../controllers/todo_controller.dart';
import '../utils/theme_service.dart';

class TodoDetailScreen extends StatefulWidget {
  final Todo todo;

  const TodoDetailScreen({Key? key, required this.todo}) : super(key: key);

  @override
  State<TodoDetailScreen> createState() => _TodoDetailScreenState();
}

class _TodoDetailScreenState extends State<TodoDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _isCompleted = false;

  final TodoController _todoController = Get.find<TodoController>();
  final ThemeService _themeService = Get.find<ThemeService>();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todo.title);
    _descriptionController = TextEditingController(
      text: widget.todo.description ?? '',
    );
    _selectedDate = widget.todo.dueDate;
    _selectedTime =
        widget.todo.dueDate != null
            ? TimeOfDay.fromDateTime(widget.todo.dueDate!)
            : null;
    _isCompleted = widget.todo.isCompleted;
  }

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
      initialDate:
          _selectedDate?.subtract(
            Duration(
              hours: _selectedDate!.hour,
              minutes: _selectedDate!.minute,
            ),
          ) ??
          DateTime.now(),
      firstDate: DateTime(2020),
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
        _selectedTime = const TimeOfDay(hour: 12, minute: 0);
        _selectedDate = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          12,
          0,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDark = _themeService.rxIsDarkMode.value;

      return Scaffold(
        appBar: AppBar(
          title: const Text('تفاصيل المهمة'),
          centerTitle: true,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'حذف المهمة',
              onPressed: () {
                Get.defaultDialog(
                  title: 'تأكيد الحذف',
                  titleStyle: const TextStyle(fontWeight: FontWeight.bold),
                  middleText: 'هل أنت متأكد من حذف هذه المهمة؟',
                  textConfirm: 'حذف',
                  textCancel: 'إلغاء',
                  confirmTextColor: Colors.white,
                  cancelTextColor: Get.theme.colorScheme.primary,
                  buttonColor: Colors.red,
                  onConfirm: () async {
                    Get.back();
                    await _todoController.deleteTodo(widget.todo);
                    if (_todoController.error == null) {
                      Get.back();
                    }
                  },
                  onCancel: () {},
                );
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // حالة المهمة
                  Card(
                    elevation: 0,
                    color:
                        _isCompleted
                            ? Colors.green.withOpacity(isDark ? 0.2 : 0.1)
                            : _selectedDate != null &&
                                _selectedDate!.isBefore(DateTime.now())
                            ? Colors.red.withOpacity(isDark ? 0.2 : 0.1)
                            : Get.theme.colorScheme.primary.withOpacity(
                              isDark ? 0.3 : 0.1,
                            ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color:
                            _isCompleted
                                ? Colors.green
                                : _selectedDate != null &&
                                    _selectedDate!.isBefore(DateTime.now())
                                ? Colors.red
                                : Get.theme.colorScheme.primary,
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(
                            _isCompleted
                                ? Icons.task_alt
                                : _selectedDate != null &&
                                    _selectedDate!.isBefore(DateTime.now())
                                ? Icons.warning_amber
                                : Icons.pending_actions,
                            color:
                                _isCompleted
                                    ? Colors.green
                                    : _selectedDate != null &&
                                        _selectedDate!.isBefore(DateTime.now())
                                    ? Colors.red
                                    : Get.theme.colorScheme.primary,
                            size: 30,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _isCompleted
                                      ? 'تم إكمال المهمة'
                                      : _selectedDate != null &&
                                          _selectedDate!.isBefore(
                                            DateTime.now(),
                                          )
                                      ? 'المهمة متأخرة'
                                      : 'المهمة قيد التنفيذ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color:
                                        isDark ? Colors.white : Colors.black87,
                                  ),
                                ),
                                if (_selectedDate != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      'موعد الاستحقاق: ${DateFormat('yyyy/MM/dd - HH:mm').format(_selectedDate!)}',
                                      style: TextStyle(
                                        color:
                                            _isCompleted
                                                ? isDark
                                                    ? Colors.green.shade300
                                                    : Colors.green.shade700
                                                : _selectedDate!.isBefore(
                                                  DateTime.now(),
                                                )
                                                ? isDark
                                                    ? Colors.red.shade300
                                                    : Colors.red.shade700
                                                : Get.theme.colorScheme.primary,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Switch(
                            value: _isCompleted,
                            onChanged: (value) {
                              setState(() {
                                _isCompleted = value;
                              });
                            },
                            activeColor: Colors.green,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // حقل عنوان المهمة
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'عنوان المهمة*',
                      prefixIcon: Icon(Icons.title),
                      hintText: 'أدخل عنوان المهمة',
                      hintStyle: TextStyle(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black87,
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
                    decoration: InputDecoration(
                      labelText: 'وصف المهمة (اختياري)',
                      prefixIcon: Icon(Icons.description),
                      hintText: 'أدخل وصف المهمة',
                      hintStyle: TextStyle(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black87,
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
                      color: isDark ? Color(0xFF2A2A2A) : Colors.transparent,
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
                                  icon: Icon(
                                    Icons.clear,
                                    color: isDark ? Colors.white70 : null,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _selectedDate = null;
                                    });
                                  },
                                  tooltip: 'مسح التاريخ',
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
                                  final updatedTodo = Todo(
                                    id: widget.todo.id,
                                    title: _titleController.text.trim(),
                                    description:
                                        _descriptionController.text
                                                .trim()
                                                .isNotEmpty
                                            ? _descriptionController.text.trim()
                                            : null,
                                    dueDate: _selectedDate,
                                    isCompleted: _isCompleted,
                                    createdAt: widget.todo.createdAt,
                                  );

                                  await _todoController.updateTodo(updatedTodo);

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
                                'حفظ التغييرات',
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
    });
  }
}
