// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

// NFT contract to inherit from.
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

// Helper functions OpenZeppelin provides.
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

// base64 function
import "./libraries/Base64.sol";

import "hardhat/console.sol";

contract Slayers is ERC721 {

    // character properties

    struct CharacterAttributes {
        uint characterIndex;
        string name;
        string imageURI;
        uint hp;
        uint maxHp;
        uint attackDamage;
        }

    struct BigBoss {
        string name;
        string imageURI;
        uint hp;
        uint maxHp;
        uint attackDamage;
    }

    BigBoss public bigBoss;

    uint256 private seed = (block.timestamp + block.difficulty) % 100;

    // create events to receive info on front end

    event CharacterNFTMinted(address sender, uint256 tokenId, uint256 characterIndex);
    event AttackComplete(address sender, uint newBossHp, uint newPlayerHp);
    event AttackClass(address sender, string attackClass, uint attackDamage);
    

    // create tokenIds

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // Array to hold character data

    CharacterAttributes[] defaultCharacters;

    // mapping of Ids to Characters and owners to Ids

    mapping(uint256 => CharacterAttributes) public nftHolderAttributes;

    mapping(address => uint256) public nftHolders;

    // character initialisation

    constructor(
        string[] memory characterNames,
        string[] memory characterImageURIs,
        uint[] memory characterHp,
        uint[] memory characterAttackDmg,
        string memory bossName,
        string memory bossImageURI,
        uint bossHp,
        uint bossAttackDamage
    )

    ERC721("Slayers", "SLAY") {
    // loop through characters and save them in contract for later use

    bigBoss = BigBoss(
        bossName,
        bossImageURI,
        bossHp,
        bossHp,
        bossAttackDamage
    );

    for (uint i = 0; i < characterNames.length; i++) {
        defaultCharacters.push(CharacterAttributes(
            i,
            characterNames[i],
            characterImageURIs[i],
            characterHp[i],
            characterHp[i],
            characterAttackDmg[i]
            ));

            CharacterAttributes memory c = defaultCharacters[i];
            console.log("Done initialising %s w/ HP %s, img %s", c.name, c.hp, c.imageURI);
        }

        _tokenIds.increment();
    }

    // function reviveCharacter() external {

    //     uint nftTokenIdOfPlayer = nftHolders[msg.sender];
    //     CharacterAttributes storage player = nftHolderAttributes[nftTokenIdOfPlayer];
    //     player.hp = player.maxHp;
    //     console.log("Player hp restored, now:", player.hp);

    // }

    function mintCharacterNFT(uint _characterIndex) external {
        uint256 newItemId = _tokenIds.current();

        _safeMint(msg.sender, newItemId);

        nftHolderAttributes[newItemId] = CharacterAttributes(
            _characterIndex,
            defaultCharacters[_characterIndex].name,
            defaultCharacters[_characterIndex].imageURI,
            defaultCharacters[_characterIndex].hp,
            defaultCharacters[_characterIndex].maxHp,
            defaultCharacters[_characterIndex].attackDamage
        );

        console.log("Minted NFT w/ tokenId %s and characterIndex %s", newItemId, _characterIndex);

        // record who owns what

        nftHolders[msg.sender] = newItemId;
        console.log(nftHolders[msg.sender]);

        // increment tokenId

        _tokenIds.increment();

        emit CharacterNFTMinted(msg.sender, newItemId, _characterIndex);

        

    }

    function tokenURI(uint256 _tokenId) public view override returns (string memory) {
        CharacterAttributes memory charAttributes = nftHolderAttributes[_tokenId];

        string memory strHp = Strings.toString(charAttributes.hp);
        string memory strMaxHp = Strings.toString(charAttributes.maxHp);
        string memory strAttackDamage = Strings.toString(charAttributes.attackDamage);

        string memory json = Base64.encode(
                abi.encodePacked(
                    '{"name": "',
                    charAttributes.name,
                    ' -- NFT #: ',
                    Strings.toString(_tokenId),
                    '", "description": "This is an NFT that lets people play in the game Fight Night!", "image": "',
                    charAttributes.imageURI,
                    '", "attributes": [ { "trait_type": "Health Points", "value": ',strHp,', "max_value":',strMaxHp,'}, { "trait_type": "Attack Damage", "value": ',
                    strAttackDamage,'} ]}'
                )
            );

        string memory output = string(
                abi.encodePacked("data:application/json;base64,", json)
                );

        return output;
            }

    function attackBoss() public {
        uint256 nftTokenIdOfPlayer = nftHolders[msg.sender];
        CharacterAttributes storage player = nftHolderAttributes[nftTokenIdOfPlayer];
        console.log("%s is about to attack. Has %s HP and %s AD", player.name, player.hp, player.attackDamage);
        console.log("Boss %s has %s HP and %s AD", bigBoss.name, bigBoss.hp, bigBoss.attackDamage);

        // Generate random attack possibility

        seed = (block.difficulty + block.timestamp + seed) % 100;
        console.log("seed is", seed);

        // make sure player and boss has enough HP to attack
        require (player.hp > 0, "Error: must have HP to attack.");
        require (bigBoss.hp > 0, "Error: boss must have HP to attack.");
        
        // player attacks boss

        if (seed < 15) {

            if (bigBoss.hp < (player.attackDamage * 5)) {
            bigBoss.hp = 0;
            emit AttackClass(msg.sender, "Mega Attack! Damage x 5!", (player.attackDamage * 5));
            }
            else {
            bigBoss.hp = bigBoss.hp - (player.attackDamage * 5);
            console.log("Mega Attack! Damage x 5");
            emit AttackClass(msg.sender, "Mega Attack! Damage x 5!", (player.attackDamage * 5));
            }

        }
        
        else if (seed < 40) {

            if (bigBoss.hp < (player.attackDamage * 3)) {
            bigBoss.hp = 0;
            console.log("Super Attack! Triple Damage!");
            emit AttackClass(msg.sender, "Super Attack! Triple Damage", (player.attackDamage * 3));
            }
            else {
            bigBoss.hp = bigBoss.hp - (player.attackDamage * 3);
            console.log("Super Attack! Triple Damage!");
            emit AttackClass(msg.sender, "Super Attack! Triple Damage!", (player.attackDamage * 3));
            }

        }

        else {

            if (bigBoss.hp < player.attackDamage) {
            bigBoss.hp = 0;
            emit AttackClass(msg.sender, "Standard Attack", player.attackDamage);

            
            }
            else {
            bigBoss.hp = bigBoss.hp - player.attackDamage;
            emit AttackClass(msg.sender, "Standard Attack", player.attackDamage);
            }

        }

        // boss now attacks player

        if (player.hp <= bigBoss.attackDamage) {
                player.hp = 0;
            }
            
        else {
            player.hp = player.hp - bigBoss.attackDamage;
        }

        console.log("boss hp now: %s. player hp now: %s", bigBoss.hp, player.hp);

        emit AttackComplete(msg.sender, bigBoss.hp, player.hp);
        
    }


    function checkIfUserHasNFT() public view returns (CharacterAttributes memory) {
        uint256 userNFTTokenID = nftHolders[msg.sender];
        if (userNFTTokenID > 0) {
            return nftHolderAttributes[userNFTTokenID];
        }
        else {
            CharacterAttributes memory emptyStruct;
            return emptyStruct;
        }
    }

    function getAllDefaultCharacters() public view returns (CharacterAttributes[] memory) {
        return defaultCharacters;
    }

    function getBigBoss() public view returns (BigBoss memory) {
        return bigBoss;
    }


}


