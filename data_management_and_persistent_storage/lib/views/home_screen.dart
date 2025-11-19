import 'package:data_management_and_persistent_storage/hower/effect_on_image.dart';
import 'package:data_management_and_persistent_storage/views/counter_view.dart';
import 'package:data_management_and_persistent_storage/views/todo_view.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Welcome to the Home Screen!',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'This is where the main content will go.',
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Enjoy these two different features!',
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),
                      Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Counter App Column
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  HoverGrowImage(
                                    imagePath: 'image/counter.png',
                                    destination: CounterView(),
                                    width: 250,
                                    height: 250,
                                    hoverHeight: 300,
                                  ),
                                  const SizedBox(height: 10),
                                  const Icon(
                                    Icons.touch_app,
                                    color: Colors.red,
                                  ),
                                  const SizedBox(height: 5),
                                  const Text(
                                    "Click to Counter App",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                      fontSize: 20,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 20),
                            // Todo App Column
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  HoverGrowImage(
                                    imagePath: 'image/todoview.png',
                                    destination: TodoView(),
                                    width: 250,
                                    height: 250,
                                    hoverHeight: 300,
                                  ),
                                  const SizedBox(height: 10),
                                  const Icon(
                                    Icons.touch_app,
                                    color: Colors.red,
                                  ),
                                  const SizedBox(height: 5),
                                  const Text(
                                    "Click to Todo App",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                      fontSize: 20,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
