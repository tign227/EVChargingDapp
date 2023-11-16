const hre = require("hardhat");

async function main() {
  const functions = await hre.ethers.deployContract("FunctionsService");
  await functions.waitForDeployment();
  console.log("FunctionsService is deployed!!!");
  console.log("the Address of FunctionsService is : ", (await functions.getAddress()).toString());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
