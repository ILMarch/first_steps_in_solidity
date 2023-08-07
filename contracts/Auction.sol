// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Auction {

    address payable public seller; // payable - на этот адрес наш смарт контракт будет отпр средства, продавец

    address highestBidder; // польз сделавший максимальную ставку

    uint public highestBid; // макс. ставка

    uint endTime; // время кога закончится аукцион

    mapping (address => uint) chargeback; // возвраты денег

    // constructor - код который вызывается при создании смарт-контракта, вып. один раз за счет продавца
    constructor(
        address payable _seller,
        uint auction_interval // время в сек, длительности аукциона
    ) public {
        seller = _seller;
        endTime = block.timestamp + auction_interval;
    }

//    function isEnded() returns (bool) {
//        return now > endTime;
//    }

    function makeBid() public payable {

        require(block.timestamp < endTime, "Auction has ended"); 
        require(msg.value > highestBid, "Invalid bid");

        if (highestBid != 0) {
            // предыдущий highestBidder должен получить деньги назад
            chargeback[highestBidder] += highestBid;
        }

        highestBidder = msg.sender;
        highestBid = msg.value;
    }

    function withdraw(address payable sender) public returns (bool) {
        require(sender == msg.sender, "Invalid address");
        uint amount = chargeback[sender]; // сколько надо вернуть
        if (amount > 0) {
            // Посылаем деньги обратно
            if (sender.send(amount)) {
                // если все ок, то обнуляем "долг"
                chargeback[sender] = 0;
                return true;
            }
        }

        return false;
    }
    // Завершение аукциона
    function finalizeAuction() public {
        require(block.timestamp >= endTime, "Auction hasn't ended yet");
        require(seller == msg.sender, "Only seller can finalize");

        seller.transfer(highestBid);
    }
}