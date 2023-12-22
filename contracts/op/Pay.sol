// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract Pay {
    mapping(address => uint256) failureRecords;

    error FailedPayment(address user, address official, uint256 amount);

    bool private locked;

    modifier ReentrancyGuard() {
        require(locked);
        locked = true;
        _;
        locked = false;
    }

    function pay(address official, uint256 amount) external ReentrancyGuard {
        require(official != address(0), "address = 0");
        require(official.code.length == 0, "contract address");
        (bool success, ) = official.call{value: amount}("");
        if (!success) {
            failureRecords[msg.sender] = amount;
            revert FailedPayment(msg.sender, official, amount);
        }
    }
}
