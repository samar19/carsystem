var TestCar=artifacts.require("./CarExchangeInterface.sol");
contract("TestCar",function(accounts)
{


it("should register car", function() {
    return TestCar.deployed()
.then(function(instance) {
      return instance.register.call(accounts[0],557);
    }).then(function(balance) {
      assert.equal(balance.valueOf(), true, "car didn't registered");
    });
  });

});
