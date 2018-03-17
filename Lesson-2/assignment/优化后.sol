pragma solidity ^0.4.14;

contract Payroll {
    
    address constant owner = msg.sender;
    uint constant payDuration = 10 seconds;
    uint totleSalary = 0;
    
    
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
            totleSalary -= employees[index].salary;
            employees[index].salary = salary * 1 ether;
            totleSalary += employees[index].salary;
            employees[index].lastPayday = now;
            return;
        } 
    }
    
    function addEmployee(address id,uint salary){
        require(msg.sender == owner);
        var (ishadEmployee , index) = findEmployee(id);
        require(ishadEmployee == false);
        uint newSalary = salary * 1 ether;
        employees.push(Employee(id,newSalary,now));
        totleSalary += newSalary;
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
        totleSalary -= employees[index].salary;
        delete employees[index];
        employees[index] = employees[employees.length - 1];
        employees.length --;
        
    }
    
    
    function addFund() payable returns (uint){
        return this.balance;
    }
    
    function calculateRunway() returns (uint){
        
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