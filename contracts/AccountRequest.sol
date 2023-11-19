// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;
import "./FunctionsService.sol";

contract AccountRequest {
    FunctionsService service;

    constructor(address serviceAddress) {
        service = FunctionsService(serviceAddress);
    }

    function requestAccount(string memory url, string memory path) external {
        service.request("Account", url, path);
    }
}
