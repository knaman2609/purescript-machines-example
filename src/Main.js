exports.testImpl = function(x) {
  return function() {
    console.log(x);

    return "MealyT " + x;
  }
}
