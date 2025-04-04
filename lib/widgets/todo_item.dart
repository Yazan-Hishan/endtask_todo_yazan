import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../models/todo.dart';
import '../utils/theme_service.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;
  final VoidCallback onTap;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const TodoItem({
    Key? key,
    required this.todo,
    required this.onTap,
    required this.onToggle,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();

    return Obx(() {
      final isDark = themeService.rxIsDarkMode.value;

      return Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: 0.25,
          children: [
            SlidableAction(
              onPressed: (_) => onDelete(),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete_rounded,
              label: 'حذف',
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
          ],
        ),
        child: Card(
          elevation: isDark ? 3 : 2,
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          color: isDark ? const Color(0xFF212121) : Colors.white,
          shadowColor: isDark ? Colors.black : Colors.grey.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(isDark ? 8 : 12),
            side: BorderSide(
              color:
                  todo.isCompleted
                      ? Colors.green.withOpacity(isDark ? 0.5 : 0.3)
                      : _isOverdue(todo.dueDate) && !todo.isCompleted
                      ? isDark
                          ? Colors.orange.withOpacity(0.7)
                          : Colors.orange.withOpacity(0.5)
                      : isDark
                      ? Colors.grey.withOpacity(0.3)
                      : Colors.transparent,
              width: isDark ? 1.0 : 1.5,
            ),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            splashColor:
                isDark
                    ? Get.theme.colorScheme.primary.withOpacity(0.3)
                    : Get.theme.colorScheme.primary.withOpacity(0.1),
            highlightColor:
                isDark
                    ? Colors.white.withOpacity(0.05)
                    : Colors.black.withOpacity(0.05),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  // زر تبديل حالة المهمة
                  Transform.scale(
                    scale: 1.1,
                    child: Checkbox(
                      value: todo.isCompleted,
                      activeColor: isDark ? const Color(0xFF42A5F5) : null,
                      checkColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      side: BorderSide(
                        color:
                            isDark
                                ? Colors.grey.shade400
                                : Colors.grey.shade600,
                        width: 1.5,
                      ),
                      onChanged: (_) => onToggle(),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // محتوى المهمة
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // عنوان المهمة
                        Text(
                          todo.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            decoration:
                                todo.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                            color:
                                todo.isCompleted
                                    ? Colors.grey
                                    : isDark
                                    ? Colors.white
                                    : Colors.black87,
                          ),
                        ),

                        // وصف المهمة (إذا وجد)
                        if (todo.description != null &&
                            todo.description!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              todo.description!,
                              style: TextStyle(
                                color:
                                    isDark ? Colors.white70 : Colors.grey[800],
                                decoration:
                                    todo.isCompleted
                                        ? TextDecoration.lineThrough
                                        : null,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                        // تاريخ المهمة (إذا وجد)
                        if (todo.dueDate != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    _isOverdue(todo.dueDate) &&
                                            !todo.isCompleted
                                        ? isDark
                                            ? Colors.red.withOpacity(0.4)
                                            : Colors.red.withOpacity(0.1)
                                        : isDark
                                        ? const Color(0xFF2C5789)
                                        : Get.theme.colorScheme.primary
                                            .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    size: 14,
                                    color:
                                        _isOverdue(todo.dueDate) &&
                                                !todo.isCompleted
                                            ? isDark
                                                ? Colors.red.shade300
                                                : Colors.red
                                            : isDark
                                            ? Colors.white
                                            : Get.theme.colorScheme.primary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    DateFormat(
                                      'yyyy/MM/dd - HH:mm',
                                    ).format(todo.dueDate!),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color:
                                          _isOverdue(todo.dueDate) &&
                                                  !todo.isCompleted
                                              ? isDark
                                                  ? Colors.red.shade300
                                                  : Colors.red
                                              : isDark
                                              ? Colors.white
                                              : Get.theme.colorScheme.primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // أيقونة للإشارة إلى مهمة متأخرة
                  if (todo.dueDate != null &&
                      _isOverdue(todo.dueDate) &&
                      !todo.isCompleted)
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color:
                            isDark
                                ? Colors.orange.withOpacity(0.4)
                                : Colors.orange.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.warning_amber_rounded,
                        color: isDark ? Colors.orange.shade300 : Colors.orange,
                        size: 20,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  // التحقق مما إذا كانت المهمة متأخرة
  bool _isOverdue(DateTime? dueDate) {
    if (dueDate == null) return false;
    final now = DateTime.now();
    return dueDate.isBefore(DateTime(now.year, now.month, now.day));
  }
}
