// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import "./FunctionsService.sol";

/**
 * @title ChargingReservation
 * @dev This contract manages the charging reservation functionality by utilizing Chainlink's Functions service.
 * It is responsible for handling reservation and interacting with external APIs.
 */
contract ChargingReservation {
    FunctionsService public service;

    mapping(address => bytes32[]) public reservationsOfUser;

    event ReservationCreated(address indexed user, bytes32 reservationId);

    event ReservationCanceled(address indexed user, bytes32 reservationId);

    constructor(address serviceAddress) {
        service = FunctionsService(serviceAddress);
    }

    /**
     * @dev Initiates a reservation request using the Chainlink service.
     * @param _url The URL of the external API for reservation details.
     * @param _path The JSONPath to extract the reservation details from the API response.
     */
    function makeReservation(
        string memory _url,
        string memory _path
    ) external payable returns (bytes32 reservationId) {
        require(bytes(_url).length > 0, "URL must not be empty");
        require(bytes(_path).length > 0, "Path must not be empty");
        // Trigger a reservation request using the Chainlink service.
        bytes32 requestId = service.request("Reservation", _url, _path);
        reservationId = requestId;
        emit ReservationCreated(msg.sender, reservationId);
        reservationsOfUser[msg.sender].push(reservationId);
    }

    function cancelReservation(bytes32 _reservationId) public returns (bool) {
        service.cancelRequest(_reservationId);
        emit ReservationCanceled(msg.sender, _reservationId);
        return true;
    }
}
