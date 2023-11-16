// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;
import "./FunctionsService.sol";
/**
 * @title ChargingReservation
 * @dev This contract manages charging reservation functionality.
 * It is responsible for handling reservation and withdrawing.
 */


contract ChargingReservation {
    /**
     * @dev Mapping from account address to reservation count.
     */
    mapping(address => uint256) public reservations;
    
    FunctionsService service;
    string public result;

    event ReservationMade(
        address indexed _user,
        string _plateLicense,
        string _chargingStationName,
        string _chargingStationAddress,
        uint256 _startTime,
        uint256 _endTime
    );

    constructor(address serviceAddress) {
        service = FunctionsService(serviceAddress);
    }

    //console test
    function greet() public pure returns (string memory) {
        return "Hello World";
    }

    /**
     * @notice Make a reservation for the charging station.
     * @dev Users can make a reservation by paying the reservation fee.
     */
    function makeReservation(
        address _user,
        string memory _plateLicense,
        string memory _chargingStationName,
        string memory _chargingStationAddress,
        uint256 _startTime,
        uint256 _endTime
    ) external payable returns (string memory status) {
        // require(
        //     reservations[_user] == 0,
        //     "You have a unfinished charging reservation"
        // );
        reservations[_user]++;
        service.request("Reservation", "http://endpoint-dun.vercel.app/api/reservation", "message,reservationDetails,chargingStation,stationID");
        emit ReservationMade(
            _user,
            _plateLicense,
            _chargingStationName,
            _chargingStationAddress,
            _startTime,
            _endTime
        );
        result = service.result();
        return "200";
    }
}
