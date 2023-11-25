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

    mapping(address => Reservation[]) public reservationsOfUser;

    struct Reservation {
        bytes32 id;
        string station;
        string lat;
        string lng;
    }

    event ReservationCreated(address indexed user, bytes32 reservationId);

    event ReservationCanceled(address indexed user, bytes32 reservationId);

    constructor(address serviceAddress) {
        service = FunctionsService(serviceAddress);
    }

    /**
     * @dev Initiates a reservation request using the Chainlink service.
     * @param url The URL of the external API for reservation details.
     * @param path The JSONPath to extract the reservation details from the API response.
     */
    function makeReservation(
        string memory station,
        string memory lat,
        string memory lng,
        string memory url,
        string memory path
    ) external payable returns (bytes32 reservationId) {
        require(bytes(url).length > 0, "URL must not be empty");
        require(bytes(path).length > 0, "Path must not be empty");
        // Trigger a reservation request using the Chainlink service.
        bytes32 requestId = service.request("Reservation", url, path);
        emit ReservationCreated(msg.sender, requestId);
        Reservation memory reservation = Reservation({
            id: requestId,
            station: station,
            lat: lat,
            lng: lng
        });
        reservationsOfUser[msg.sender].push(reservation);
        reservationId = requestId;
    }

    function cancelReservation(bytes32 reservationId) external {
        require(
            reservationsOfUser[msg.sender].length > 0,
            "Reservation don't exist"
        );
        Reservation[] storage userReservations = reservationsOfUser[msg.sender];
        for (uint256 i = 0; i < userReservations.length; i++) {
            if (userReservations[i].id == reservationId) {
                userReservations[i] = userReservations[
                    userReservations.length - 1
                ];
                userReservations.pop();
                emit ReservationCanceled(msg.sender, reservationId);
                return;
            }
        }
        revert("Reservation not found");
    }

    function getReservation(
        address user,
        bytes32 reservationId
    ) public view returns (Reservation memory) {
        Reservation[] storage userReservations = reservationsOfUser[user];
        for (uint256 i = 0; i < userReservations.length; i++) {
            if (userReservations[i].id == reservationId) {
                return userReservations[i];
            }
        }
        revert("Reservation not found");
    }

    function getAllReservationsOfUser(
        address user
    ) public view returns (Reservation[] memory) {
        return reservationsOfUser[user];
    }
}

