const { expect, assert } = require("chai");

describe("AccountRequest", function () {
  let service;
  it("Should deploy the contract", async function () {
    const AccountRequest = await ethers.getContractFactory("AccountRequest");
    service = await AccountRequest.deploy();
    expect(service.address).to.exist;
  });

  it("Should call the function", async function () {
    const result = await service.callFunction();
    expect(result).to.exist;
  });

  it("Should emit the event", async function () {
    await expect(service.emitEvent())
      .to.emit(service, "EventName")
      .withArgs(expectedArgs);
  });
});
