exports.testImpl = function(x) {
  return function(y) {
    return function() {
      console.log(x, y);
      return "Mealy " + x  + " " + y;
    }
  }
}

exports.myLog = function(x) {
  return function() {
    console.log(x);

    return {};
  }
}
