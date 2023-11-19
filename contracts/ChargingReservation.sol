// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;
import "./FunctionsService.sol";

contract ChargingReservation {
    FunctionsService service;

    constructor(address serviceAddress) {
        service = FunctionsService(serviceAddress);
    }

    function makeReservation(
        string memory url,
        string memory path
    ) external payable {
        service.request("Reservation", url, path);
    }
}
