import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/cubit/states.dart';
import 'package:flutter_conditional_rendering/conditional.dart';

import '../shared/components.dart';
import '../shared/cubit/cubit.dart';

class NewTasks extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var tasks = AppCubit.get(context).newTasks;
          return buildTask(tasks: tasks, context: context);
        });
  }
}
