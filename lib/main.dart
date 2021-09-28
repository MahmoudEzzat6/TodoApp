import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/layouts/home_layouts.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'shared/cubit/bloc_observer.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => AppCubit()..createDB(),
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: HomeLayout()));

  }
}
