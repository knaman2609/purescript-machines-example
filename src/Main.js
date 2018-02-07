exports.testImpl = function(x) {
  return function(y) {
    return function(cb) {
      return function() {
        var body = document.getElementsByTagName("body")[0];

        body.addEventListener("click", function() {
          cb(x*y)();
        });
      }
    }
  }
}
