import 'package:get/get.dart';

import '../db/db_helper.dart';
import '../models/task.dart';

class TaskController extends GetxController {

  @override
  void onReady() {
    super.onReady();
    getTasks();
  }

  var taskList = <Task>[].obs;

  // static Future<int> insert(Task? task) async {}
  Future<int> addTask({Task? task}) async {
    return await DBHelper.insert(task);
  }

  // get all the data from table
  void getTasks() async {
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
  }

  void delete(Task task) {
    DBHelper.delete(task);
    getTasks(); // 삭제한 이후 tasklist 내용 불러오기
  }

  void markTaskCompleted(int id) async {
    await DBHelper.update(id);
    getTasks(); // 수정한 이후 tasklist 내용 불러오기
  }

}
