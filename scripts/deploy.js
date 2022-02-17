const main = async () => {
    const gameContractFactory = await hre.ethers.getContractFactory("Slayers");
    const gameContract = await gameContractFactory.deploy(
        ["Ninja", "Swordsman", "Blade", "Quicksilver", "Slayer", "Mystique", "Slash"],       // Names
        ["https://scott-a-m.github.io/slayers/slayers-ninja.png",
        "https://scott-a-m.github.io/slayers/slayers-swordsman.png", // Images
        "https://scott-a-m.github.io/slayers/slayers-blade.png",
        "https://scott-a-m.github.io/slayers/slayers-quicksilver.png",
        "https://scott-a-m.github.io/slayers/slayers-slayer.png",
        "https://scott-a-m.github.io/slayers/slayers-mystique.png",
        "https://scott-a-m.github.io/slayers/slayers-slash.png"
    ],
        [400, 500, 450, 500, 450, 550, 500],                    // HP values
        [200, 170, 190, 150, 180, 150, 175],     // Attack damage values
        "Desolator",
        "https://scott-a-m.github.io/slayers/slayers-desolator.png",
        20000,
        50                      
    );
    await gameContract.deployed();
    console.log("Contract deployed to:", gameContract.address);

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
