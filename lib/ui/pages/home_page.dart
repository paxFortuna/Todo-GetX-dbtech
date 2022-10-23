import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../controller/task_controller.dart';
import '../../models/task.dart';
import '../../services/theme_service.dart';
import '../widgets/add_task_bar.dart';
import '../widgets/buttons.dart';
import '../widgets/task_tile.dart';
import '../widgets/themes.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _taskController = Get.put(TaskController());

  DateTime _selectedDate = DateTime.now();

  //var notifyHelper;

  @override
  void initState() {
    // Future.microtask(() => _taskController.getTasks());
    super.initState();
    //notifyHelper = NotifyHelper();
    //notifyHelper.showNotification();
    //notifyHelper.addScheduledNotification();
    //notifyHelper.initializeNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: context.theme.backgroundColor,
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
          const SizedBox(height: 10),
          _showTasks(),
        ],
      ),
    );
  }

  _appBar() {
    return AppBar(
      elevation: 0,
      // thmemMode 전환할 때 변화
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: () {
          ThemeService().switchTheme();
        },
        child: Icon(
            Get.isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_round,
            size: 20,
            color: Get.isDarkMode ? Colors.white : Colors.black),
      ),
      title: Text('ToDo',
        style: TextStyle(
            color: Get.isDarkMode ? Colors.white : Colors.black),),
      actions: const [
        // Icon(Icons.person, size: 20),
        CircleAvatar(
          backgroundImage: AssetImage('images/tarot.png'),
        ),
        SizedBox(width: 12),
      ],
    );
  }

  _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: subHeadingStyle,
              ),
              Text(
                'Today',
                style: headingStyle,
              ),
            ],
          ),
          MyButton(
            label: "+ Add Task",
            onTap: () async {
              await Get.to(() => const AddTaskPage());
              _taskController.getTasks();
            },
          ),
        ],
      ),
    );
  }

  _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryClr,
        selectedTextColor: Colors.white,
        dateTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),

        // Today 날짜 선택하면, 입력된 데이터 호출!!
        onDateChange: (date) {
          setState(() {
            _selectedDate = date;
          });

        },
      ),
    );
  }

  _showTasks() {
    return Expanded(
      child: Obx(() {
        return ListView.builder(
            itemCount: _taskController.taskList.length,
            itemBuilder: (_, index) {
              Task task = _taskController.taskList[index];

              if (task.repeat == 'Daily') {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                    child: FadeInAnimation(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _showBottomSheet(context, task);
                            },
                            child: TaskTile(task),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              if (task.date == DateFormat.yMd()
                  .format(_selectedDate)) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                    child: FadeInAnimation(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _showBottomSheet(context, task);
                            },
                            child: TaskTile(task),
                          ),
                        ],
                      ),
                    ),
                  ),
                );

              } else {
                return Container();
              }
            });
      }),
    );
  }

  // Show BottomSheet
  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 4),
        height: task.isCompleted == 1
            ? MediaQuery.of(context).size.height * 0.24
            : MediaQuery.of(context).size.height * 0.32,
        color: Get.isDarkMode ? darkGreyClr : Colors.white,
        child: Column(
          children: [
            Container(
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Get.isDarkMode
                    ? Colors.grey[600] : Colors.grey[300],
              ),
            ),

            const Spacer(),

            task.isCompleted == 1
                ? Container()
                : _bottomSheetButton(
              label: "Task Completed",
              onTap: () {
                _taskController.markTaskCompleted(task.id!);
                Get.back();
              },
              clr: primaryClr,
              context: context,
            ),

            const SizedBox(height: 20),

            _bottomSheetButton(
              label: "Delete Task",
              onTap: () {
                _taskController.delete(task);
                // _taksController.getTasks();
                Get.back();
              },
              clr: Colors.red[300]!,
              context: context,
            ),
            const SizedBox(height: 20),
            _bottomSheetButton(
              label: "Close",
              onTap: () {
                Get.back();
              },
              clr: Colors.red[300]!,
              isClose: true,
              context: context,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
  // Bottom Sheet Button
  _bottomSheetButton({
    required String label,
    required Function()? onTap,
    required Color clr,
    bool isClose = false,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose == true
                ? Get.isDarkMode
                ? Colors.grey[600]!
                : Colors.grey[300]!
                : clr,
          ),

          borderRadius: BorderRadius.circular(20),
          color: isClose == true ? Colors.transparent : clr,
        ),
        // BoxDecoration
        child: Center(
          child: Text(
            label,
            style:
            isClose ? titleStyle
                : titleStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
