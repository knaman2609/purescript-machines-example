exports.testImpl = function(x) {
  return function() {
    return x;
  }
}

exports.myLog = function(x) {
  return function() {
    console.log(x);

    return {};
  }
}
