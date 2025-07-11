import 'package:flutter/material.dart';

import 'package:element_key_inspector/element_key_inspector.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    ElementKeyInspector.initialize(
      scopes: [
        const ElementKeyScope(
          type: MyHomePage,
        ),
      ],
      elementKeyPattern: (elementKey) {
        return elementKey.contains('demo_');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: ElementKeyInspectorStack(
          isShowInspectButton: true,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Element Key Inspector Demo',
            theme: ThemeData(
              useMaterial3: false,
            ),
            home: const MyHomePage(),
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Element Key Inspector Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              key: const Key('demo_container_1'),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Container with Key: demo_container_1',
                key: Key('demo_text_1'),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              key: const Key('demo_container_2'),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Container with Key: demo_text_2',
                key: Key('demo_text_2'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
