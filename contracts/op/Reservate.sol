// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import "./../infru/Functions.sol";

/**
 * @title ChargingReservation
 * @dev This contract manages the charging reservation functionality by utilizing Chainlink's Functions service.
 * It is responsible for handling reservation and interacting with external APIs.
 */
contract ChargingReservation {
    FunctionsService public service;

    mapping(address => bytes32[]) public reservationsOfUser;

    event ReservationCreated(address indexed _user, bytes32 _reservationId);

    event ReservationCanceled(address indexed _user, bytes32 _reservationId);

    event ErrorOccurred(string indexed _errorMessage);

    constructor(address _serviceAddress) {
        service = FunctionsService(_serviceAddress);
    }

    /**
     * @dev Initiates a reservation request using the Chainlink service.
     * @param _url The URL of the external API for reservation details.
     * @param _path The JSONPath to extract the reservation details from the API response.
     * @return _reservationId The ID of the reservation request
     */
    function makeReservation(
        string memory _url,
        string memory _path
    ) external returns (bytes32 _reservationId) {
        require(bytes(_url).length > 0, "URL must not be empty");
        require(bytes(_path).length > 0, "Path must not be empty");
        // Trigger a reservation request using the Chainlink service.
        bytes32 requestId = service.request("Reservation", _url, _path);
        _reservationId = requestId;
        emit ReservationCreated(msg.sender, _reservationId);
        reservationsOfUser[msg.sender].push(_reservationId);
    }

    /**
     * @dev Allows a user to cancel a reservation request.
     * @param _reservationId The ID of the reservation to be canceled.
     * @return A boolean indicating the success of the cancellation.
     */
    function cancelReservation(bytes32 _reservationId) external returns (bool) {
        try service.cancelRequest(_reservationId) {
            emit ReservationCanceled(msg.sender, _reservationId);
        } catch Error(string memory errorMessage) {
            emit ErrorOccurred(errorMessage);
            return false;
        } catch (bytes memory) {
            emit ErrorOccurred("An error occurred");
            return false;
        }
        return true;
    }
}
