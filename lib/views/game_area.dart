import 'dart:math';

import 'package:flutter/material.dart';
import 'package:thimothe/logics/departments_list.dart';
import 'package:thimothe/models/department.dart';

import 'answer_button.dart';

class GameArea extends StatefulWidget {
  final bool hardMode;
  final bool isTimed;
  const GameArea({
    super.key,
    required this.hardMode,
    required this.isTimed,
  });

  @override
  State<GameArea> createState() => _GameAreaState();
}

class _GameAreaState extends State<GameArea> with SingleTickerProviderStateMixin {
  bool isPlaying = false;
  Department? department;

  List<String> answers = [];
  int score = 0;
  List<Department> playingList = [];

  late AnimationController _controller;
  late Animation<Duration> _animation;
  bool _isPaused = false;

  @override
  void initState() {
    if (widget.isTimed) {
      super.initState();
      _controller = AnimationController(
        duration: const Duration(minutes: 1),
        vsync: this,
      );

      _animation = Tween(
        begin: const Duration(minutes: 1),
        end: Duration.zero,
      ).animate(_controller);

      _controller.addListener(() {
        if (_controller.isCompleted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Fini !'),
              content: SizedBox(
                height: MediaQuery.of(context).size.height / 6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text('Votre score :'),
                    Text(
                      score.toString(),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () => setState(
                          () {
                            Navigator.of(context).pop();
                            resetList();
                            loadNewShuffle();
                            score = 0;
                            _controller.reset();
                            _controller.forward();
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
                    child: Text('Relancer !', style: Theme.of(context).textTheme.titleLarge))
              ],
            ),
          );
        }
      });
      _controller.forward();
    }
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _pauseAnimation() {
    if (_controller.isAnimating) {
      _controller.stop();
      setState(() {
        _isPaused = true;
      });
    }
  }

  void _resumeAnimation() {
    if (_isPaused) {
      _controller.forward(from: _controller.value);
      setState(() {
        _isPaused = false;
      });
    }
  }

  Department shuffleDepartment() {
    return playingList[Random().nextInt(playingList.length)];
  }

  List<String> shuffleAnswers(String realAnswer) {
    final shuffledList = List<Department>.from(playingList);
    shuffledList.shuffle();
    if (shuffledList.length > 4) {
      List<String> answers =
          shuffledList.where((d) => d != department).take(3).map((department) => department.name).toList();
      answers.add(realAnswer);
      return answers;
    } else {
      return shuffledList.map((department) => department.name).toList();
    }
  }

  List<String> fetchCloseAnswers(Department realAnswer) {
    if (playingList.length > 4) {
      final departmentIndex = playingList.indexOf(realAnswer);
      if (departmentIndex + 4 > playingList.length) {
        final maxRange = playingList.length - departmentIndex;
        final highestIndex = departmentIndex + maxRange;
        return playingList.sublist(departmentIndex - (4 - maxRange), highestIndex).map((d) => d.name).toList();
      } else {
        final lowerestIndex = Random().nextInt(4);
        return playingList
            .sublist(departmentIndex - lowerestIndex, departmentIndex + (4 - lowerestIndex))
            .map((d) => d.name)
            .toList();
      }
    } else {
      return playingList.map((department) => department.name).toList();
    }
  }

  void resetList() {
    playingList = departmentsList;
  }

  void loadNewShuffle() {
    if (playingList.isEmpty) {
      playingList = departmentsList;
    }
    department = shuffleDepartment();
    loadAnswers();
  }

  void loadAnswers() {
    if (department != null) {
      if (!widget.hardMode) {
        answers = shuffleAnswers(department!.name);
      } else {
        answers = fetchCloseAnswers(department!);
      }
      answers.shuffle();
    }
  }

  void validateAnswer(String answer) {
    _pauseAnimation();
    bool isRight = answer == department!.name;
    playingList.removeWhere((d) => d == department);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: isRight ? Theme.of(context).primaryColor : Colors.red,
      duration: const Duration(seconds: 1),
      content: SizedBox(
          height: 50,
          child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                  isRight
                      ? 'Bravo !'
                      : widget.hardMode
                          ? 'Pas bravo !'
                          : 'Pas bravo ! La réponse était ${department!.name}',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.white)))),
    ));
    setState(() {
      if (isRight) {
        score++;
      }
      Future.delayed(
        const Duration(seconds: 1),
        () => setState(() {
          loadNewShuffle();
          _resumeAnimation();
        }),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isOnPhone = MediaQuery.of(context).size.width < 550;

    if (department == null) {
      loadNewShuffle();
    }

    return Padding(
      padding: EdgeInsets.all(isOnPhone ? 20.0 : 50.0),
      child: playingList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Bravo, vous avez fait tous les départments !', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(
                    height: 50.0,
                  ),
                  Text('Votre score : ', style: Theme.of(context).textTheme.titleLarge),
                  Text(score.toString(), style: Theme.of(context).textTheme.titleLarge)
                ],
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (widget.isTimed)
                      AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          final minutes = _animation.value.inMinutes;
                          final seconds = _animation.value.inSeconds % 60;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              '$minutes:${seconds.toString().padLeft(2, '0')}',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          );
                        },
                      ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                        text: TextSpan(
                          text: 'Score : ',
                          style: Theme.of(context).textTheme.titleMedium,
                          children: [
                            TextSpan(
                                text: score.toString(),
                                style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Text("C'est quoi donc le ${department?.code ?? ''} ?",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 30)),
                const SizedBox(
                  height: 50,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 2,
                  child: GridView.count(
                    childAspectRatio: isOnPhone ? 4 : 2,
                    crossAxisCount: isOnPhone ? 1 : 4,
                    mainAxisSpacing: isOnPhone ? 20.0 : 30.0,
                    crossAxisSpacing: isOnPhone ? 8.0 : 20.0,
                    children: answers
                        .map(
                          (answer) => AnswerButton(answer: answer, validateAnswer: validateAnswer),
                        )
                        .toList(),
                  ),
                )
              ],
            ),
    );
  }
}
