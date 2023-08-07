// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

// cryptocurrency "SKillCoin"
contract SkillCoin {

    address owner; // переменная в которой хранится владелец
    mapping(address => uint) public balances; // балансы всех пользователей

    // при создании контракта вызовется конструктор
    constructor() public {
        owner = msg.sender; // запоминаем пользователя к-рый создал контракт и считаем его владельцем
    }

    // функция вруную создает монеты
    // reciever - получатель
    // amount - количество монет к-рое получит reciever
    function createCoin(address reciever, uint amount) public {
        require(msg.sender == owner, "Only owner can create coins"); // проверяем кто создал монетц 
        balances[reciever] += amount;
    }

    function sendCoin(address reciever, uint amount) public {
        // проверим что у отправителя достаточно денег
        require(balances[msg.sender] >= amount, "Insufficient balance!");

        balances[msg.sender] -= amount;
        balances[reciever] += amount;
    } 
}