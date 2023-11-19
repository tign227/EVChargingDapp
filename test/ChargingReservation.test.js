
const { expect, assert } = require("chai");

describe("ChargingReservation", function () {
  it("Make a reservation", async function () {
    const [reserverAddress, plateLicense] = await ethers.getSigners();
    const ChargingReservation = await ethers.getContractFactory("ChargingReservation");
    const reservation = await ChargingReservation.deploy();

    const positionX = 43;
    const positionY = 567;
    const chargingStationID = 1;
    const chargingStationAddress = "Mock Address"
    const chargingStationName = "Mock Name"
    const startTime = Math.floor(Date.now() / 1000) + 3600; // start reservation 1 hour from now
    const endTime = startTime + 7200; // end reservation 2 hours from start

    const tx = await reservation.makeReservation(reserverAddress, plateLicense, positionX, positionY, chargingStationID,chargingStationAddress, chargingStationName, startTime, endTime);
    assert(tx, "200");
  });
});

