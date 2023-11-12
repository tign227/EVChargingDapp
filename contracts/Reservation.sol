// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

/**
 * @title ChargingReservation
 * @dev This contract manages charging reservation functionality.
 * It is responsible for handling reservation and withdrawing.
 */
contract ChargingReservation {
    address public owner;
    uint256 public reservationFee;
    uint256 public totalReservations;

    /**
     * @dev Mapping from account address to reservation count.
     */
    mapping(address => uint256) public reservations;

    event ReservationMade(address indexed user, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    constructor(uint256 _reservationFee) {
        owner = msg.sender;
        reservationFee = _reservationFee;
    }

    /**
     * @notice Make a reservation for the charging station.
     * @dev Users can make a reservation by paying the reservation fee.
     */
    function makeReservation() external payable {
        require(msg.value == reservationFee, "Incorrect reservation fee");
        //TODO:post request through Oracles
        reservations[msg.sender]++;
        totalReservations++;
        emit ReservationMade(msg.sender, block.timestamp);
    }

    /**
     * @notice Withdraw the reservation fee for the owner.
     * @dev Only the owner can withdraw the accumulated reservation fees.
     */
    function withdrawFees() external onlyOwner {
        payable(owner).transfer(address(this).balance);
    }
}
