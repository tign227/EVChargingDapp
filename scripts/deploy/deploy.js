const hre = require("hardhat");

async function main() {
  const functions = await hre.ethers.deployContract("FunctionsService");
  await functions.waitForDeployment();

  const reservation = await hre.ethers.deployContract("ChargingReservation", [functions.target]);
  await reservation.waitForDeployment();

  const account = await hre.ethers.deployContract("AccountRequest", [functions.target]);
  await account.waitForDeployment();
  
  console.log("FunctionsService is deployed remotely, the address is : ", functions.target);
  console.log("ChargingReservation is deployed remotely, the address is : ", reservation.target);
  console.log("AccountRequest is deployed remotely, the address is : ", account.target);

}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
