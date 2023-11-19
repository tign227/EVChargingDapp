const hre = require("hardhat");

async function main() {
  const functions = await hre.ethers.deployContract("FunctionsService");
  await functions.waitForDeployment();
  const address = await functions.getAddress();
  console.log("FunctionsService is deployed, the address is : ", address.toString());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
