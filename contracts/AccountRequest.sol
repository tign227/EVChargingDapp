// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import "./FunctionsService.sol";

/**
 * @title AccountRequest
 * @dev This contract interacts with Chainlink's Functions service to request external account information.
 * It sends a request to an external API through Chainlink's Functions service.
 */
contract AccountRequest {
    FunctionsService service;

    mapping(address => bytes32[]) public requestsOfUser;

    event AccountRequestCreated(address indexed _user, bytes32 _requestId);

    event AccountRequestCanceled(address indexed _user, bytes32 _requestId);

    event ErrorOccurred(string indexed _errorMessage);

    constructor(address _serviceAddress) {
        service = FunctionsService(_serviceAddress);
    }

    /**
     * @dev Initiates an account information request using the Chainlink service.
     * @param _url The URL of the external API for account information.
     * @param _path The JSONPath to extract the account details from the API response.
     * @return _requestId The ID of the request
     */
    function requestAccount(
        string memory _url,
        string memory _path
    ) external returns (bytes32 _requestId) {
        require(bytes(_url).length > 0, "URL must not be empty");
        require(bytes(_path).length > 0, "Path must not be empty");
        // Trigger an account information request using the Chainlink service.
        _requestId = service.request(
            FunctionsService.RequestType.ACCOUNT,
            _url,
            _path
        );
        emit AccountRequestCreated(msg.sender, _requestId);
        requestsOfUser[msg.sender].push(_requestId);
    }

    /**
     * @dev Allows a user to cancel a pending request.
     * @param _requestId The ID of the request to be canceled.
     * @return A boolean indicating the success of the cancellation.
     */
    function cancelRequest(bytes32 _requestId) external returns (bool) {
        try service.cancelRequest(_requestId) {
            emit AccountRequestCanceled(msg.sender, _requestId);
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
