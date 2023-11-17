const hre = require("hardhat");

async function main() {
  const reservation = await hre.ethers.deployContract("ChargingReservation");
  await reservation.waitForDeployment();
  const address = await reservation.getAddress();
  console.log("ChargingReservation is deployed, the address is : ", address.toString());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
