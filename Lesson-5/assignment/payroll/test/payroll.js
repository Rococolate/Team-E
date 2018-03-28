var Payroll = artifacts.require("./Payroll.sol");
const address0 = 0x0000000000000000000000000000000000000000;
const ether = 1000000000000000000;
contract('Payroll', function(accounts) {
    
  it("addEmployee success.", function() {
    return Payroll.deployed().then(function(instance) {
      PayrollInstance = instance;
      return PayrollInstance.employees(accounts[1]);
    }).then(function(employee){
        employee1 = employee[0];
        return PayrollInstance.addEmployee(accounts[1],1);
    }).then(function(){
      return PayrollInstance.employees(accounts[1]);
    }).then(function(employee) {
        employee2 = employee[0];
        assert.equal(employee1, address0);
        assert.equal(employee2, accounts[1]);
    });
  });

  it("removeEmployee success.", function() {
      return Payroll.deployed().then(function(instance) {
      PayrollInstance2 = instance;
      return PayrollInstance2.addFund({from: accounts[0],value:10*ether});
    }).then(function(){
      return PayrollInstance2.addEmployee(accounts[3],1);
    }).then(function(){
      return PayrollInstance2.employees(accounts[3]);
    }).then(function(employee) {
      employee3 = employee[0];
      return PayrollInstance2.removeEmployee(accounts[3]);  
    }).then(function(){
        return PayrollInstance2.employees(accounts[3]);
    }).then(function(employee){
        employee4 = employee[0];
        assert.equal(employee3, accounts[3]);
        assert.equal(employee4, address0);
    });
  });

});
