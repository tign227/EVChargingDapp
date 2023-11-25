const { expect, assert } = require("chai");
describe("FunctionsService", function () {
  let service;
  it("Should deploy the contract", async function () {
    const FunctionsService = await ethers.getContractFactory(
      "FunctionsService"
    );
    service = await FunctionsService.deploy();
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
