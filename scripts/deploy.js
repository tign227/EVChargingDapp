const hre = require("hardhat");

async function main() {
  const reservation = await hre.ethers.deployContract("ChargingReservation");
  await reservation.waitForDeployment();
  console.log("ChargingReservation is deployed!!!");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
