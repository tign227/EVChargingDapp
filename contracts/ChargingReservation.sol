// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import "./FunctionsService.sol";

/**
 * @title ChargingReservation
 * @dev This contract manages the charging reservation functionality by utilizing Chainlink's Functions service.
 * It is responsible for handling reservation requests and interacting with external APIs.
 */
contract ChargingReservation {
    FunctionsService service;

    constructor(address serviceAddress) {
        service = FunctionsService(serviceAddress);
    }

    /**
     * @dev Initiates a reservation request using the Chainlink service.
     * @param url The URL of the external API for reservation details.
     * @param path The JSONPath to extract the reservation details from the API response.
     */
    function makeReservation(
        string memory url,
        string memory path
    ) external payable {
        // Trigger a reservation request using the Chainlink service.
        service.request("Reservation", url, path);
    }
}
