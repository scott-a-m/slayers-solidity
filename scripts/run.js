// run this file for testing contract locally

const main = async () => {
  const gameContractFactory = await hre.ethers.getContractFactory("Slayers");
  const gameContract = await gameContractFactory.deploy(
    ["Ninja", "Swordsman", "Blade"], // Names
    [
      "https://cdn.pixabay.com/photo/2017/01/07/09/15/woman-1959982_1280.png", // Images
      "https://cdn.pixabay.com/photo/2015/10/22/14/29/man-1001285_1280.png",
      "https://cdn.pixabay.com/photo/2019/07/22/03/46/female-warrior-4354082_1280.png",
    ],
    [200, 200, 400], // HP values
    [200, 250, 300],
    "Desolator",
    "https://cdn.pixabay.com/photo/2021/07/28/22/51/warrior-6504827_1280.png",
    10000,
    50 // Attack damage values
  );
  await gameContract.deployed();
  console.log("Contract deployed to:", gameContract.address);

  let txn = await gameContract.mintCharacterNFT(1);
  txn.wait();
  txn = await gameContract.checkIfUserHasNFT();
  txn = await gameContract.attackBoss();
  txn.wait();
  txn = await gameContract.attackBoss();
  txn.wait();
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();
