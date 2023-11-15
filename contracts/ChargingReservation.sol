// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

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

    event ReservationMade(address indexed user, uint256 timestamp);

    constructor() {
    }
    //console test
    function greet() public pure returns(string memory) {
        return "Hello World";
    }
    /**
     * @notice Make a reservation for the charging station.
     * @dev Users can make a reservation by paying the reservation fee.
     */
    function makeReservation(
        address _reserverAddress,
        string memory _plateLicense,
        uint256 _positionX,
        uint256 _positionY,
        uint256 _chargingStationID,
        string memory _chargingStationAddress,
        string memory _chargingStationName,
        uint256 _startTime,
        uint256 _endTime
    ) external payable returns (string memory status){
        //TODO:post request through Oracles
        reservations[msg.sender]++;
        emit ReservationMade(msg.sender, block.timestamp);
        return "200";
    }
}
