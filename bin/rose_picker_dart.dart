import 'dart:io';
import 'dart:math';

const cacheFileName = '.saved';
final cacheFile = File(cacheFileName);
final cached = <int>{};

void load() {
  if (cacheFile.existsSync()) {
    final strs = cacheFile.readAsLinesSync();
    for (var str in strs) {
      final num = int.tryParse(str);
      if (num != null) {
        cached.add(num);
      }
    }
  }
}

void save() {
  final outStr = cached.map((e) => e.toString()).join('\n');
  cacheFile.writeAsStringSync(outStr);
}

void main(List<String> arguments) {
  load();

  print('From 1 to: ');
  String maxStr = stdin.readLineSync() ?? "100";
  int max = int.tryParse(maxStr) ?? 100;

  print('Pick how many at a time: ');
  String quantityStr = stdin.readLineSync() ?? "3";
  int quantity = int.tryParse(quantityStr) ?? 3;

  final pool = List.generate(max, (index) => index + 1);
  pool.removeWhere((element) => cached.contains(element));
  pool.shuffle();

  while (pool.isNotEmpty) {
    final q = min(pool.length, quantity);
    final haul = [];
    for (var i = 0; i < q; i++) {
      final pick = pool[0];
      pool.removeAt(0);
      haul.add(pick);
      cached.add(pick);
    }

    for (final pick in haul) {
      print(pick);
    }

    save();

    print(' waiting (q to quit) ');
    final com = stdin.readLineSync();
    if (com == 'q') {
      return;
    }
  }

  print('all done, resetting');
  cached.clear();
  save();
}
