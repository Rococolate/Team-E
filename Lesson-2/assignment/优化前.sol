pragma solidity ^0.4.14;

contract Payroll {
    
    address constant owner = msg.sender;
    uint constant payDuration = 10 seconds;
    
    
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    Employee[] employees;
    
    function updateEmployee(address id, uint salary){
        require(msg.sender == owner);
        var (ishadEmployee , index) = findEmployee(id);
        if (ishadEmployee) {
            _partialPaid(employees[index]);
            employees[index].salary = salary * 1 ether;
            employees[index].lastPayday = now;
            return;
        } 
    }
    
    function addEmployee(address id,uint salary){
        require(msg.sender == owner);
        var (ishadEmployee , index) = findEmployee(id);
        require(ishadEmployee == false);
        employees.push(Employee(id,salary * 1 ether,now));
    }
    
    
    function findEmployee(address id) returns(bool,uint){
        for(uint i = 0 ; i < employees.length; i ++){
            if (employees[i].id == id) return (true,i);
        }
        return (false,0);
    }
    
    function _partialPaid (Employee employee) private{
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }
    
    function removeEmployee(address id){
        require(msg.sender == owner);
        var (ishadEmployee , index) = findEmployee(id);
        require(ishadEmployee == true);
        _partialPaid(employees[index]);
        delete employees[index];
        employees[index] = employees[employees.length - 1];
        employees.length --;
    }
    
    
    function addFund() payable returns (uint){
        return this.balance;
    }
    
    function calculateRunway() returns (uint){
        uint totleSalary = 0;
        for(uint i = 0 ; i < employees.length; i ++){
            totleSalary += employees[i].salary;
        }
        return  this.balance / totleSalary;
    }
    
    function hasEnoughFund() returns (bool){
        return calculateRunway() > 0;
    }
    
    function getPaid() {
        var (ishadEmployee , index) = findEmployee(msg.sender);
        require(ishadEmployee == true);
    
        uint nextPayday = employees[index].lastPayday + payDuration;
        assert(nextPayday < now);
       
        employees[index].lastPayday = nextPayday;
        employees[index].id.transfer(employees[index].salary);
        
    }
}