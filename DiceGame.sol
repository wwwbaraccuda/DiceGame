pragma solidity >0.7.0 <=0.9.0;

contract DiceGame {

    mapping(address => uint) public balances;

    address manager;

    constructor (address _manager) {
        _manager = msg.sender;
        manager = _manager;
    }

    function diceRoll() public view returns(uint) {
        uint randomNumber = uint(keccak256(abi.encodePacked(block.timestamp, block.prevrandao, msg.sender))) % 6 + 1; 
        return randomNumber;
    }

    function placeBet() public payable {
        balances[msg.sender] += msg.value;
    }

    function getPrize() public returns(uint) {
        uint betAmount = balances[msg.sender];
        uint diceNumber = diceRoll();
        if (diceNumber == 6) {
            uint prizeAmount = betAmount * 2;
            balances[msg.sender] -= betAmount;
            payable(msg.sender).transfer(prizeAmount);
        }
        
        return diceNumber;
    }

}
