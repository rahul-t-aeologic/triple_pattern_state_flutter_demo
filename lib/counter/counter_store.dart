import 'package:flutter_triple/flutter_triple.dart';

class CounterStore extends Store<int> with MementoMixin {
  CounterStore() : super(0);

  Future<void> increment() async {
    setLoading(true);
    await Future.delayed(const Duration(milliseconds: 1000));
    update(state + 1);
    setLoading(false);
  }
}
