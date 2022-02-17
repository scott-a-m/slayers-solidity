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

// const gameContract = await gameContractFactory.deploy(
//     ["Ninja", "Swordsman", "Blade", "Quicksilver", "Slayer", "Mystique", "Slash"],       // Names
//     ["https://cdn.pixabay.com/photo/2017/01/07/09/15/woman-1959982_1280.png", // Images
//     "https://cdn.pixabay.com/photo/2015/10/22/14/29/man-1001285_1280.png",
//     "https://cdn.pixabay.com/photo/2019/07/22/03/46/female-warrior-4354082_1280.png",
//     "https://cdn.pixabay.com/photo/2018/02/21/05/47/warrior-woman-3169505_1280.png",
//     "https://cdn.pixabay.com/photo/2019/01/31/01/29/fantasy-3965761_1280.png",
//     "https://cdn.pixabay.com/photo/2017/10/13/23/57/warrior-woman-2849393_1280.png",
//     "https://cdn.pixabay.com/photo/2017/01/26/01/03/viking-2009503_1280.png"
// ],
//     [400, 600, 450, 500, 450, 500, 525],                    // HP values
//     [200, 100, 200, 150, 175, 225, 175],     // Attack damage values
//     "Desolator",
//     "https://cdn.pixabay.com/photo/2021/07/28/22/51/warrior-6504827_1280.png",
//     15000,
//     50                      
// );