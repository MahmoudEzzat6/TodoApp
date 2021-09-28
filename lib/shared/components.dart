import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:todo_app/shared/cubit/cubit.dart';

Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  bool isUpperCase = false,
  double radius = 3.0,
  required Function? function,
  required String? text,
}) {
  return Container();
}

Widget defaultTextField({
  required TextEditingController? controller,
  required TextInputType? type,
  Function()? onTap,
  Function(String)? onChange,
  required String? Function(String?)? onValidate,
  String Function(String?)? onSubmit,
  bool isPassword = false,
  required String? label,
  required IconData? prefix,
  IconData? suffix,
  Function()? suffixPress,
}) {
  return TextFormField(
    controller: controller,
    keyboardType: type,
    obscureText: isPassword,
    onChanged: onChange,
    onTap: onTap,
    onFieldSubmitted: onSubmit,
    validator: onValidate,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(prefix),
      suffixIcon: suffix != null
          ? IconButton(onPressed: suffixPress, icon: Icon(suffix))
          : null,
      border: OutlineInputBorder(),
    ),
  );
}

Widget buildTaskItem(Map? model, context) {
  AppCubit cubit = AppCubit.get(context);
  return Dismissible(
    onDismissed: (direction) {
      cubit.deleteRows(model!['id']);
    },
    key: Key(model!['id'].toString()),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
      child: Card(
        elevation: 6.0,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.black12,
                radius: 38.0,
                child: Text(
                  '${model['time']}',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(width: 20.0),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model['title']}',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${model['date']}',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
                onPressed: () {
                  cubit.updateDB(status: 'done', id: model['id']);
                },
                icon: Icon(
                  Icons.check_box_rounded,
                  color: Colors.green.shade800,
                )),
            IconButton(
                onPressed: () {
                  cubit.updateDB(status: 'archive', id: model['id']);
                },
                icon: Icon(
                  Icons.archive,
                  color: Colors.black45,
                )),
          ],
        ),
      ),
    ),
  );
}

Widget buildTask({BuildContext? context, List<Map?>? tasks}) {
  return Conditional.single(
    context: context!,
    widgetBuilder: (context) => ListView.separated(
      itemBuilder: (context, index) => buildTaskItem(tasks![index], context),
      separatorBuilder: (context, index) =>Divider(),
      itemCount: tasks!.length,
    ),
    conditionBuilder: (context) => tasks!.length > 0,
    fallbackBuilder: (context) => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.menu,
            color: Colors.grey,
            size: 100.0,
          ),
          Text(
            'No Tasks added yet Start Planning Now !',
            style: TextStyle(fontSize: 18.0),
          ),
        ],
      ),
    ),
  );
}
Widget Divider() => Container(width: double.infinity, height: 1.0);
