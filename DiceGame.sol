pragma solidity >0.7.0 <=0.9.0;

contract DiceGame {

    mapping(address => uint) private balances;
    mapping(address => uint) private guess;

    address manager;

    constructor (address _manager) {
        _manager = msg.sender;
        manager = _manager;
    }

    modifier managerOnly {
        require(msg.sender == manager, "Manager Only");
        _;
    }

    function diceRoll() public managerOnly view returns(uint) {
        uint randomNumber = uint(keccak256(abi.encodePacked(block.timestamp, block.prevrandao, msg.sender))) % 6 + 1; 
        return randomNumber;
    }

    function numberGuess(uint number) public payable {
        require(number >= 1 && number <= 6, "Pilih angka 1 - 6");
        require(msg.value > 0, "Ether tidak Boleh < 0");
        balances[msg.sender] += msg.value;
        guess[msg.sender] = number;
    }

    function getPrize() public managerOnly returns(uint) {
        uint betAmount = balances[msg.sender];
        uint betNumber = guess[msg.sender];
        uint diceNumber = diceRoll();
        if (diceNumber == betNumber) {
            uint prizeAmount = betAmount * 2;
            balances[msg.sender] -= betAmount;
            payable(msg.sender).transfer(prizeAmount);
        }
        
        return diceNumber;
    }

}
