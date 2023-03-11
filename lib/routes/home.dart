import 'package:flutter/material.dart';
import 'package:gradey/struct/arguments.dart';
import 'package:studentvue/studentvue.dart';

class HomeRoute extends StatelessWidget {
  const HomeRoute({super.key});

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments as HomeArguments;
    Client client = args.client;

    return StatefulHomeRoute(client: client);
  }
}

class StatefulHomeRoute extends StatefulWidget {
  final Client client;

  const StatefulHomeRoute({super.key, required this.client});
  @override
  State<StatefulHomeRoute> createState() => _StatefulHomeRouteState();
}

class _StatefulHomeRouteState extends State<StatefulHomeRoute> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Gradebook>(
      future: widget.client.gradebook(),
      builder: (BuildContext context, AsyncSnapshot<Gradebook> snapshot) {
        List<Widget> drawers = <Widget>[];
        List<Widget> children = <Widget>[];

        if (snapshot.hasData) {
          drawers.add(const SizedBox(
              height: 64,
              child: DrawerHeader(
                padding: EdgeInsets.zero,
                margin: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Center(
                  child: Text('Your classes',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
              )));

          for (var element in snapshot.data!.courses) {
            drawers.add(ListTile(
              title: Text('${element.period}. ${element.title}'),
              onTap: () {
                Navigator.of(context)
                    .pushNamed('/class', arguments: ClassArguments(element));
              },
            ));
          }

          children = <Widget>[
            const Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 60,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text(
                'Successfully loaded grade data',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Expanded(
                child: Container(
                    padding: const EdgeInsets.all(16),
                    child: FractionallySizedBox(
                        widthFactor: 1,
                        child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                width: 0.5,
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
                                itemCount: snapshot.data!.courses.length,
                                itemBuilder: (BuildContext context, int index) {
                                    return ListTile(
                                      title: Text(snapshot.data!.courses.elementAt(index).title),
                                      onTap: () {
                                        ScaffoldMessenger.of(context).removeCurrentSnackBar();
                                        final snackBar = SnackBar(
                                          content: Text('${snapshot.data!.courses.elementAt(index).title} : ${snapshot.data!.courses.elementAt(index).totalGrade.calculatedMark}'),
                                        );

                                        // Find the ScaffoldMessenger in the widget tree
                                        // and use it to show a SnackBar.
                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                      },
                                    );
                                }
                            )
                        )
                    )
                )
            )
          ];
        } else if (snapshot.hasError) {
          children = const <Widget>[
            Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            ),
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text(
                'An error occurred :(',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ];
        } else {
          children = const <Widget>[
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text(
                'Loading grades...',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ];
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(widget.client.username),
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [...drawers],
            ),
          ),
          body: Center(
              child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [...children],
            ),
          )),
        );
      },
    );
  }
}
