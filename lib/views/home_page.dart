import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thimothe/logics/departments_list.dart';
import 'package:thimothe/services/department_service.dart';
import 'package:thimothe/views/game_area.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final departmentService = DepartmentService();

  bool isPlaying = false;
  bool hardMode = false;
  bool isTimed = false;

  void fetchDepartments() async {
    departmentsList = await departmentService.fetchAllDepartments();
  }

  @override
  void initState() {
    super.initState();
    fetchDepartments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          leading: IconButton(
            icon: Icon(Icons.home),
            onPressed: () => setState(
              () {
                isPlaying = false;
              },
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width > 500 && !isPlaying
                    ? MediaQuery.of(context).size.width / 2
                    : MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: isPlaying
                        ? GameArea(
                            hardMode: hardMode,
                            isTimed: isTimed,
                          )
                        : Column(
                            children: [
                              Text('Bienvenue dans le jeu des départements !',
                                  style: Theme.of(context).textTheme.titleMedium),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.0),
                                child: Text(
                                    'Vous vous pensez incollable sur les départements français ? Mesurez-vous à la Creuse ou à la Haute-Saône !'),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height / 1.8,
                                  child: Image.asset('assets/france.png')),
                              Row(
                                children: [
                                  Text('Mode hardcore'),
                                  Checkbox(
                                    value: hardMode,
                                    onChanged: (value) => setState(
                                      () {
                                        hardMode = value ?? false;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('Mode timé'),
                                  Checkbox(
                                    value: isTimed,
                                    onChanged: (value) => setState(
                                      () {
                                        isTimed = value ?? false;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              TextButton(
                                  onPressed: () => setState(
                                        () {
                                          isPlaying = true;
                                        },
                                      ),
                                  style: TextButton.styleFrom(
                                    alignment: Alignment.center,
                                    backgroundColor: Theme.of(context).secondaryHeaderColor,
                                    padding: const EdgeInsets.all(20),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40.0),
                                    ),
                                  ),
                                  child: Text('Lancer !', style: Theme.of(context).textTheme.titleLarge)),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
