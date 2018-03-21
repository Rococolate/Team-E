pragma solidity ^0.4.14;

import "./SafeMath.sol";
import "./Ownable.sol";

contract Payroll is Ownable {
    // 可调整薪水、地址  
    using SafeMath for uint;
    address owner;
    uint constant payDuration = 10 seconds;
    uint public totleSalary;
    
    struct Employee {
        address addressId;
        uint salary;
        uint lastPayday;
        uint id;
    }
    
    mapping(uint => Employee) public employees; 
    
    function updateEmployeeSalary(uint id, uint salary) onlyOwner employeeNotExits(id) {
        var employee = employees[id];
        _partialPaid(employee);
        totleSalary = totleSalary.sub(employees[id].salary);
        employees[id].salary = salary.mul(1 ether);
        totleSalary = totleSalary.add(employees[id].salary);
        employees[id].lastPayday = now;
    }
    
    function addEmployee(address aid,uint salary,uint id) onlyOwner employeeExits(id){
        var employee = employees[id];
        uint newSalary = salary.mul(1 ether) ;
        employees[id] = Employee(aid,newSalary,now,id);
        totleSalary = totleSalary.add(newSalary);
    }

    
    function _partialPaid (Employee employee) private{
        
        uint payment = employee.salary.mul(now.sub(employee.lastPayday)).div(payDuration);
        employee.addressId.transfer(payment);
    }
    
    function removeEmployee(uint id) onlyOwner employeeNotExits(id){
        var employee = employees[id];
        _partialPaid(employee);
        totleSalary = totleSalary.sub(employees[id].salary);
        delete employees[id];
    }
    
    
    function addFund() payable returns (uint){
        return this.balance;
    }
    
    function calculateRunway() returns (uint){
        if (totleSalary == 0) return 0;
        return  this.balance.div(totleSalary);
    }
    
    function hasEnoughFund() returns (bool){
        return calculateRunway() > 0;
    }
    
    modifier employeeExits(uint id) {
        var employee = employees[id];
        assert(employee.addressId == 0x0);
        _;
    }
    
    modifier employeeNotExits(uint id) {
        var employee = employees[id];
        assert(employee.addressId != 0x0);
        _;
    }
    
    function changePaymentAddress(uint id,address aid) employeeNotExits(id){
        var employee = employees[id];
        _partialPaid(employee);
        employee.addressId = aid;
    }
    
    function getPaid(uint id) employeeNotExits(id){
        var employee = employees[id];
        assert(employee.addressId == msg.sender);
        uint nextPayday = employee.lastPayday.add(payDuration);
        assert(nextPayday < now);
        employee.lastPayday = nextPayday;
        employee.addressId.transfer(employee.salary);
        
    }
}