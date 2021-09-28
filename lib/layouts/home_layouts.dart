import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';

import 'package:todo_app/shared/components.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

class HomeLayout extends StatelessWidget {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  final timecontroller = TextEditingController();
  final tittlecontroller = TextEditingController();
  final dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) => {
              if (state is AppInsertDataBaseState) {Navigator.pop(context)}
            },
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              backgroundColor: Colors.black45,
              title: Text("${cubit.screens[cubit.currentIndex]}"),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.black45,
              foregroundColor: Colors.white,
              onPressed: () {
                if (cubit.isBottomSheet!) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertIntoDB(
                        title: tittlecontroller.text,
                        date: dateController.text,
                        time: timecontroller.text);

                    timecontroller.clear();
                    dateController.clear();
                    tittlecontroller.clear();
                  }
                } else {
                  scaffoldKey.currentState!
                      .showBottomSheet(
                          (context) => Container(
                                padding: EdgeInsets.all(20.0),
                                color: Colors.white,
                                child: Form(
                                  key: formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      defaultTextField(
                                        controller: tittlecontroller,
                                        type: TextInputType.text,
                                        onValidate: (value) {
                                          String errortxt =
                                              'This Filed cannot be Empty';
                                          return (value!.isEmpty)
                                              ? errortxt
                                              : null;
                                        },
                                        label: 'Task Tittle',
                                        prefix: Icons.title,
                                      ),
                                      SizedBox(height: 10),
                                      defaultTextField(
                                        controller: timecontroller,
                                        type: TextInputType.datetime,
                                        onTap: () {
                                          showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now(),
                                          ).then((value) {
                                            timecontroller.text = value!
                                                .format(context)
                                                .toString();
                                          });
                                        },
                                        onValidate: (value) {
                                          String errortxt =
                                              'This Filed cannot be Empty';
                                          return (value!.isEmpty)
                                              ? errortxt
                                              : null;
                                        },
                                        label: 'Task Time',
                                        prefix: Icons.watch_later_outlined,
                                      ),
                                      SizedBox(height: 10),
                                      defaultTextField(
                                        controller: dateController,
                                        type: TextInputType.datetime,
                                        onTap: () {
                                          showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate:
                                                DateTime.parse('2021-10-18'),
                                          ).then((value) {
                                            dateController.text =
                                                DateFormat.yMMMd()
                                                    .format(value!);
                                          });
                                        },
                                        onValidate: (value) {
                                          String errortxt =
                                              'This Filed cannot be Empty';
                                          return (value!.isEmpty)
                                              ? errortxt
                                              : null;
                                        },
                                        label: 'Task Date',
                                        prefix: Icons.calendar_today_outlined,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          elevation: 20.0)
                      .closed
                      .then((value) {
                    cubit.changeBottomSheetState(
                        isShow: false, icon: Icons.edit);
                  });
                  cubit.changeBottomSheetState(isShow: true, icon: Icons.add);
                }
              },
              child: Icon(cubit.fabIcon),
            ),
            bottomNavigationBar: BottomNavigationBar(
                currentIndex: cubit.currentIndex,
                onTap: (index) {
                  cubit.changeIndex(index);
                },
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.menu), label: 'Tasks'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.done), label: 'Done'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.archive), label: 'Archived'),
                ]),
            body: Conditional.single(
              context: context,
              conditionBuilder: (context) =>
                  state is! AppGetDataBaseLoadingState,
              widgetBuilder: (context) => cubit.screens[cubit.currentIndex],
              fallbackBuilder: (context) => Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        });
  }
}
