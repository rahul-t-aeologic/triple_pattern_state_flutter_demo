import 'package:flutter/material.dart';
import 'package:flutter_triple/flutter_triple.dart';

import 'counter_store.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final counter = CounterStore();
  late Disposer disposer;

  @override
  void initState() {
    super.initState();
    disposer = counter.observer(onState: print);
  }

  @override
  void dispose() {
    super.dispose();
    disposer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: counter.undo,
            icon: const Icon(Icons.arrow_back_ios),
          ),
          IconButton(
            onPressed: counter.redo,
            icon: const Icon(Icons.arrow_forward_ios),
          ),
        ],
      ),
      body: Center(
        child: ScopedConsumer<CounterStore, int>(
          store: counter,
          onLoadingListener: (context, isLoading) {},
          onErrorListener: (context, error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(error.toString()),
              ),
            );
          },
          onLoadingBuilder: (context) => const Text('Loading...'),
          onStateBuilder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('You have pushed the button'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$state',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const Text(
                      'Times',
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: TripleBuilder<CounterStore, int>(
        store: counter,
        builder: (context, triple) {
          return FloatingActionButton(
            onPressed: triple.isLoading ? null : counter.increment,
            tooltip: triple.isLoading ? 'no-active' : 'Increment',
            backgroundColor:
                triple.isLoading ? Colors.grey : Theme.of(context).primaryColor,
            child: const Icon(Icons.add),
          );
        },
      ),
    );
  }
}
