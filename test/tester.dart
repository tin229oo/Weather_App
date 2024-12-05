
void Task1(){
  print('Task 1');
}

Future<String> Task2() async {
  String C = 'Task 3';
  Duration duration = const Duration(seconds: 5);
  await Future.delayed(duration, () {
    print('Task 2');
  });
  return C;
}

void Task3(String X){
  print(X);
}

void TaskAll(){
  print('Task 1');
}

void main(){
  print('Task 1');
}