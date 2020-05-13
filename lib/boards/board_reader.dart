import 'dart:io';

String board(String name) => File('lib/boards/$name').readAsStringSync();
