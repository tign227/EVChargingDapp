const hre = require("hardhat");

async function main() {

  const functions = await hre.ethers.deployContract("FunctionsService");
  await functions.waitForDeployment();
  const serviceAddress = functions.target;
  const reservation = await hre.ethers.deployContract("ChargingReservation", [serviceAddress]);
  await reservation.waitForDeployment();
  
  console.log("the address of functions service is :", serviceAddress)
  console.log("the address of charging reservation is :", reservation.target)
  console.log("All contracts have been deployed!!!");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
