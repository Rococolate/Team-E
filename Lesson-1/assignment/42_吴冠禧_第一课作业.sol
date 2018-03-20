pragma solidity ^0.4.14;

contract Payroll {
    // 可调整薪水、地址  
    uint salary = 1 ether;
    address member;
    address constant OWNER = msg.sender;
    uint constant payDuration = 10 seconds;
    uint lastPayday = now;
    
    function checkIsOnwer(){
        if (msg.sender != OWNER) {
            throw;
        }
    }
    
    
    function changeSalary(uint newSalary) returns (uint){
        checkIsOnwer();
        if (newSalary > 0 ) {
            salary = newSalary;
        }
        return salary;
    }
    
    function changeAddress(address newAdd) returns (address){
        checkIsOnwer();
        if (newAdd != 0x0 ) {
            member = newAdd;
        }
        return member;
    }
    
    function addFund() payable returns (uint){
        return this.balance;
    }
    
    function calculateRunway() returns (uint){
        return this.balance / salary;
    }
    
    function hasEnoughFund() returns (bool){
        return calculateRunway() > 0;
    }
    
    function getPaid() {
        if (msg.sender != member){
            revert();
        }
        uint nextPayday = lastPayday + payDuration;
        if (nextPayday > now) {
           revert();
        }
       
        lastPayday = nextPayday;
        member.transfer(salary);
        
    }
}