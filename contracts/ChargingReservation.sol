// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import "./FunctionsService.sol";
import "@openzeppelin/contracts-v0.7/utils/Counters.sol";

/**
 * @title ChargingReservation
 * @dev This contract manages the charging reservation functionality by utilizing Chainlink's Functions service.
 * It is responsible for handling reservation requests and interacting with external APIs.
 */
contract ChargingReservation {
    using Counters for Counters.Counter;

    Counters.Counter private _idCounter;

    FunctionsService service;

    mapping(address => Reservation[]) public reservationsOfUser;

    struct Reservation {
        uint256 id;
        string station;
        string lat;
        string lng;
    }

    event ReservationCanceled(address indexed user, uint256 reservationId);

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
    ) external payable {
        require(bytes(url).length > 0, "URL must not be empty");
        require(bytes(path).length > 0, "Path must not be empty");
        // Trigger a reservation request using the Chainlink service.
        service.request("Reservation", url, path);
        uint256 uuid = _idCounter.next();
        Reservation memory reservation = Reservation({
            id: uuid,
            staion: station,
            lat: lat,
            lng: lng
        });
        reservationsOfUser[msg.sender].push(reservation);
    }

    function cancelReservation(uint256 reservationId) external {
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
}
