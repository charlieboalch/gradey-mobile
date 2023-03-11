import 'package:flutter/material.dart';
import 'package:gradey/struct/arguments.dart';
import 'package:studentvue/studentvue.dart';

class ClassRoute extends StatelessWidget {
  const ClassRoute({super.key});

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments as ClassArguments;
    Course course = args.course;

    return Scaffold(
      appBar: AppBar(
        title: Text(course.title),
      ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FractionallySizedBox(
                widthFactor: 1,
                child: DecoratedBox(
                    decoration: const BoxDecoration(
                      color: Colors.blue
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Text('Overall grade: ${course.totalGrade.calculatedMark}', style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30
                      ),),
                    )
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                child: FractionallySizedBox(
                  widthFactor: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        width: 0.5
                      ),
                      boxShadow: const [
                        BoxShadow(
                          offset: Offset(3, 3),
                          spreadRadius: -4,
                          blurRadius: 5,
                          color: Color.fromRGBO(0, 0, 0, 1),
                        )
                      ]
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          child: Text('Teacher: ${course.staff}'),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          child: Text('Teacher contact: ${course.staffEMail}')
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              StatefulClassRoute(course: course)
            ],
          )
      ),
    );
  }
}

class StatefulClassRoute extends StatefulWidget {
  final Course course;
  
  const StatefulClassRoute({super.key, required this.course});
  
  @override
  State<StatefulWidget> createState() {
    return _StatefulClassRoute();
  }
}

class _StatefulClassRoute extends State<StatefulClassRoute>{
  @override
  Widget build(BuildContext context) {
    return Expanded(child: Container(
      padding: const EdgeInsets.all(16),
      child: FractionallySizedBox(
        widthFactor: 1,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  width: 0.5
              ),
              boxShadow: const [
                BoxShadow(
                  offset: Offset(3, 3),
                  spreadRadius: -4,
                  blurRadius: 5,
                  color: Color.fromRGBO(0, 0, 0, 1),
                )
              ]
          ),
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              padding: const EdgeInsets.all(8),
              itemCount: widget.course.assignments.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text('${widget.course.assignments.elementAt(index).measure} | ${widget.course.assignments.elementAt(index).score}'),
                  onTap: () {
                    ScaffoldMessenger.of(context).removeCurrentSnackBar();
                    final snackBar = SnackBar(
                      content: Text('${widget.course.assignments.elementAt(index).measure}: ${widget.course.assignments.elementAt(index).score} ${(widget.course.assignments.elementAt(index).notes != '') ? '(${widget.course.assignments.elementAt(index).notes})' : ''}'),
                    );

                    // Find the ScaffoldMessenger in the widget tree
                    // and use it to show a SnackBar.
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                );
              }
          ),
        ),
      ),
    ));
  }
}