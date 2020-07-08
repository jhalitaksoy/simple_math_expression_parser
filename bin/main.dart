const argumentsError = 'Please enter the your math expression!';
const sytaxError = 'Syntax Error!';
const requiredArgumentsSize = 1;

const plus = '+';
const minus = '-';
const multiply = '*';
const divide = '/';

void main(List<String> arguments) {
  if (!checkArgumentsisCorrect(arguments)) {
    print(argumentsError);
    return;
  }

  try {
    print(Calculator(arguments.first).calculate());
  } catch (e) {
    print(sytaxError);
  }
}

bool checkArgumentsisCorrect(List<String> arguments) =>
    arguments.length == requiredArgumentsSize;

class Calculator {
  String expression;

  Calculator(this.expression);

  double calculate() =>
      _calculateExpression(Iterator(Tokenizer(expression).parseTokens()));

  double _calculateExpression(Iterator<String> iterator) {
    var result = double.parse(iterator.current);
    var currentOperator = iterator.next;

    while (currentOperator != null) {
      switch (currentOperator) {
        case plus:
          result += _calculateExpression(iterator..next);
          break;
        case minus:
          result -= _calculateExpression(iterator..next);
          break;
        case multiply:
          result *= double.parse(iterator.next);
          break;
        case divide:
          result /= double.parse(iterator.next);
          break;
      }
      currentOperator = iterator.next;
    }

    return result;
  }
}

class Tokenizer {
  String text;

  List<String> tokens = [];

  Tokenizer(this.text);

  List<String> parseTokens() {
    tokens.clear();

    var buffer = StringBuffer();
    for (var rune in text.runes) {
      var char = String.fromCharCode(rune);
      if (isSpace(char)) {
        addNumeric(buffer);
      } else if (isNumericOrDot(char)) {
        buffer.write(char);
      } else {
        addNumeric(buffer);
        tokens.add(char);
      }
    }
    addNumeric(buffer);
    return tokens;
  }

  void addNumeric(StringBuffer buffer) {
    if (buffer.toString().isNotEmpty) {
      tokens.add(buffer.toString());
      buffer.clear();
    }
  }

  bool isSpace(String text) => text == ' ' || text == '\t';

  bool isNumericOrDot(String text) => isNumeric(text) || isDot(text);

  bool isNumeric(String text) => double.tryParse(text) != null;

  bool isDot(String text) => text == '.';
}

class Iterator<T> {
  List<T> list;

  int index = 0;

  Iterator(this.list) : assert(list != null);

  T get prev => this[--index];

  T get next => this[++index];

  T get current => this[index];

  T operator [](int index) => isOutOfRange(index) ? null : list[index];

  bool isOutOfRange(int index) => index + 1 > list.length;
}
