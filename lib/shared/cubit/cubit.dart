import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/modules/archived_task.dart';
import 'package:todo_app/modules/done_task.dart';
import 'package:todo_app/modules/new_task.dart';
import 'package:todo_app/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitState());

  static AppCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  List<Widget> screens = [
    NewTasks(),
    DoneTasks(),
    ArchivedTasks(),
  ];

  void changeIndex(int index) {
    currentIndex = index;
    emit(ChangeBottomNavBarState());
  }

  Database? db;
  List<Map?>? newTasks = [];
  List<Map?>? doneTasks = [];
  List<Map?>? archivedTasks = [];
  bool? isBottomSheet = false;

  IconData? fabIcon = Icons.edit;

  void changeBottomSheetState(
      {required bool? isShow, required IconData? icon}) {
    isBottomSheet = isShow;
    fabIcon = icon;

    emit(ChangeBottomSheetState());
  }

  void createDB() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (db, verstion) async {
        print('Database Created');
        await db
            .execute(
                'CREATE TABLE tasks(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT,date TEXT,time TEXT,status TEXT)')
            .then((value) => print('Table Created from onCreate'))
            .catchError((error) => print('there is error'));
      },
      onOpen: (db) {
        getFromDB(db);
        print('Database opened and executd get database function');
      },
    ).then((value) {
      db = value;
      emit(AppCreateDataBaseState());
    });
  }

  void insertIntoDB(
      {required String? title,
      required String? date,
      required String? time}) async {
    await db!.insert('tasks', {
      'title': title,
      'date': date,
      'time': time,
      'status': 'active',
    }).then((value) {
      print('Data added!! $value');
      emit(AppInsertDataBaseState());
      getFromDB(db);
    });
  }

  void getFromDB(db) async {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    emit(AppGetDataBaseLoadingState());
    db!.rawQuery('SELECT * FROM tasks ').then((value) {
      value.forEach((element) {
        if (element['status'] == 'active') {
          newTasks!.add(element);
          print(newTasks);
        } else if (element['status'] == 'done') {
          doneTasks!.add(element);
          print(doneTasks);
        } else
          archivedTasks!.add(element);
      });
      emit(AppGetDataBaseState());
    });
  }

  void updateDB({
    required String? status,
    required int? id,
  }) async {
    db!.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', '$id']).then((value) {
      getFromDB(db);
      emit(AppUpdateDataBaseState());
    });
  }

  void deleteRows(int? id) async {
    await db!.rawDelete('DELETE from tasks WHERE id = ?', [id]);
    getFromDB(db);
    emit(AppDeleteDataBaseState());
    Toast(
        msg: 'Deleted Successfully', background: Colors.red,
    );
  }

  void Toast({required String msg,required Color background}) {
    Fluttertoast.showToast(
      msg: msg,
      backgroundColor: background,
    );
  }
}
