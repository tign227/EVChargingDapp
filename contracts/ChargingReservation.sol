// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

/**
 * @title ChargingReservation
 * @dev This contract manages charging reservation functionality.
 * It is responsible for handling reservation and withdrawing.
 */
contract ChargingReservation {
    address public owner;
    /**
     * @dev Mapping from account address to reservation count.
     */
    mapping(address => uint256) public reservations;

    event ReservationMade(address indexed user, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /**
     * @notice Make a reservation for the charging station.
     * @dev Users can make a reservation by paying the reservation fee.
     */
    function makeReservation(
        address _user,
        string memory _plateLicense,
        uint256 _positionX,
        uint256 _positionY
    ) external payable {
        //TODO:post request through Oracles
        reservations[msg.sender]++;
        emit ReservationMade(msg.sender, block.timestamp);
    }

    /**
     * @notice Withdraw the reservation fee for the owner.
     * @dev Only the owner can withdraw the accumulated reservation fees.
     */
    function withdrawFees() external onlyOwner {
        reservations[msg.sender]--;
        payable(owner).transfer(address(this).balance);
    }
}
