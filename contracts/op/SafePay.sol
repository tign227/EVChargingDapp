// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;
import "./../info/Account.sol";
import "./Pay.sol";

contract SafePayment {
    //1,fetch account info
    //2,pay with ether
    function accountAndPay(
        address account,
        address pay,
        string url,
        string path,
        uint256 amount
    ) external returns (bytes[] memory result) {
        bytes[] memory results = new bytes[](2);
        accountFetcher.call();
        return results;
    }
}
