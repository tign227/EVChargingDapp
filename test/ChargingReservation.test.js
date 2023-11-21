
const { expect, assert } = require("chai");

describe("ChargingReservation", function () {
  it("Make a reservation", async function () {
    const FunctionsService = await ethers.getContractFactory("FunctionsService");
    const service = await FunctionsService.deploy();

    const ChargingReservation = await ethers.getContractFactory("ChargingReservation");
    const reservation = await ChargingReservation.deploy(service.target);

    url = "http://endpoint-dun.vercel.app/api/reservation";
    path = "message,reservationCode";
    const requestId = await reservation.makeReservation(
      url,
      path,
    );
    console.log(requestId.toString());
  });
});

