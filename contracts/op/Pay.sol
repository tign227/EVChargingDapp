// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract Payment {
    
    function pay(address offical, uint256 amount) external returns (bool) {
        require(offical != address(0), "address = 0");
        (bool success, ) = offical.call{value: amount}("");
        return success;
    }
}
