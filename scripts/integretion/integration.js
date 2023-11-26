const hre = require("hardhat");

async function main() {
  try {
    const FunctionsService = await hre.ethers.getContractFactory(
      "FunctionsService"
    );
    //replace with your smart contract address
    const serviceContractAddress = "0x4Ca6e98187bC1E1e43c26932D4667cC67C742950";
    //event trigger
    const functions = await FunctionsService.attach(serviceContractAddress);

    functions.on("RequestMade", (_requestId) => {
      if (
        keccak256(abi.encodePacked(functions.getRequestType(_requestId))) ==
        keccak256(abi.encodePacked("Reservation"))
      ) {
        console.log(
          "Reservation is made, the result is : ",
          functions.getResult(_requestId)
        );
      } else if (
        keccak256(abi.encodePacked(functions.getRequestType(_requestId))) ==
        keccak256(abi.encodePacked("Account"))
      ) {
        console.log(
          "Query account, the address is : ",
          functions.getResult(_requestId)
        );
      }
    });

    const AccountRequest = await hre.ethers.getContractFactory(
      "AccountRequest"
    );
    //replace with your smart contract address
    const accountContractAddress = "0x44c79749A920C74C78DB8F59357533Bf628f3E74";

    const accountRequest = await AccountRequest.attach(accountContractAddress);
    let user = "0xc49341AfaC68ff16e04eD113A65fb8214E377164";
    let station = "Yundgy Seji";
    let url = `https://endpoint-dun.vercel.app/api/account?user=${user}&station=${station}`;
    let path = "message,account";
    await accountRequest.requestAccount(url, path);

    const ChargingReservation = await hre.ethers.getContractFactory(
      "ChargingReservation"
    );
    //replace with your smart contract address
    const reservationContractAddress =
      "0xa7efaDedA7b6BAc641453c9be2BA50D614E190Dc";

    const reservation = await ChargingReservation.attach(
      reservationContractAddress
    );
    user = "0x5477cE555Ffae19D38c58575403f00BF6fD05ed3";
    let lat = 53.456;
    let lng = -11.43;
    url = `https://endpoint-dun.vercel.app/api/reservation?user=${user}&lat=${lat}&lng=${lng}`;
    path = "message,reservationCode";
    await reservation.makeReservation(url, path);
  } catch (error) {
    console.error(error);
    process.exit(1);
  }
}

main();
