// test/OracleFunctions.test.js
const hardhat = require("hardhat");
const { expect } = require('chai');

describe('OracleFunctions', function () {
  let OracleFunctions;
  let oracleFunctions;

  beforeEach(async function () {
    // Deploy the contract before each test
    OracleFunctions = await hardhat.ethers.getContractFactory('OracleFunctions');
    oracleFunctions = await OracleFunctions.deploy();
  });
  it("should send a request and fulfill it", async () => {
    const subscriptionId = 1662; // Set your subscriptionId
    let requestId;
    try {
        await oracleFunctions.sendRequest(subscriptionId);
      } catch (error) {
        console.error('Error:', error);
        expect.fail('Transaction should not have reverted');
      }
    const response = "CS001"; // Set your expected response

    // Fulfill the request
    await oracleFunctions.fulfillRequest(requestId, web3.utils.asciiToHex(response), "0x");

    // Check the contract state variables
    const lastResponse = await oracleFunctions.s_lastResponse();
    const responseJson = await oracleFunctions.responseJson();

    assert.equal(lastResponse, web3.utils.asciiToHex(response), "Response doesn't match");
    assert.equal(responseJson, response, "Response JSON doesn't match");
  });
});
