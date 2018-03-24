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
    }
    
    mapping(address => Employee) public employees; 
    
    function updateEmployeeSalary(address aid, uint salary) onlyOwner employeeNotExits(aid) {
        var employee = employees[aid];
        _partialPaid(employee);
        totleSalary = totleSalary.sub(employees[aid].salary);
        employees[aid].salary = salary.mul(1 ether);
        totleSalary = totleSalary.add(employees[aid].salary);
        employees[aid].lastPayday = now;
    }
    
    function addEmployee(address aid,uint salary) onlyOwner employeeExits(aid){
        var employee = employees[aid];
        uint newSalary = salary.mul(1 ether) ;
        employees[aid] = Employee(aid,newSalary,now);
        totleSalary = totleSalary.add(newSalary);
    }

    
    function _partialPaid (Employee employee) private{
        
        uint payment = employee.salary.mul(now.sub(employee.lastPayday)).div(payDuration);
        employee.addressId.transfer(payment);
    }
    
    function removeEmployee(address aid) onlyOwner employeeNotExits(aid){
        var employee = employees[aid];
        _partialPaid(employee);
        totleSalary = totleSalary.sub(employees[aid].salary);
        delete employees[aid];
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
    
    modifier employeeExits(address aid) {
        var employee = employees[aid];
        assert(employee.addressId == 0x0);
        _;
    }
    
    modifier employeeNotExits(address aid) {
        var employee = employees[aid];
        assert(employee.addressId != 0x0);
        _;
    }
    
    function changePaymentAddress(address oldId, address newId) onlyOwner employeeExits(oldId) employeeNotExits(newId) {
        var employee = employees[oldId];
        employees[newId] = Employee(newId, employee.salary, employee.lastPayday);
        delete employees[oldId];
}
    
    function getPaid(address aid) employeeNotExits(aid){
        var employee = employees[aid];
        assert(employee.addressId == msg.sender);
        uint nextPayday = employee.lastPayday.add(payDuration);
        assert(nextPayday < now);
        employee.lastPayday = nextPayday;
        employee.addressId.transfer(employee.salary);
    }
}