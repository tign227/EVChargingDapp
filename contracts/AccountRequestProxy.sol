// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title AccountRequestProxy
 * @dev This contract acts as a proxy to forward requests to AccountRequest contract.
 */
contract AccountRequestProxy {
    address public target;

    event TargetChanged(address newTarget);

    constructor(address _target) {
        target = _target;
    }

    modifier onlyTarget() {
        require(msg.sender == target, "Not authorized");
        _;
    }

    /**
     * @dev Change the target address that this contract forwards requests to.
     * @param newTarget The new target address.
     */
    function changeTarget(address newTarget) external onlyTarget {
        require(newTarget != address(0), "Invalid target address");
        target = newTarget;
        emit TargetChanged(newTarget);
    }

    /**
     * @dev Forward a request to the target contract.
     * @param data The data to be forwarded.
     */
    function forwardRequest(
        bytes calldata data
    ) external onlyTarget returns (bytes memory) {
        (bool success, bytes memory result) = target.delegatecall(data);
        require(success, "Forwarded call failed");
        return result;
    }
}
