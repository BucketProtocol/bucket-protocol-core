import { ethers } from "hardhat";

async function main() {
  // token
  const BucketToken = await ethers.getContractFactory("BucketToken");
  const token = await BucketToken.deploy();
  await token.deployed();
  
  // protocol
  const BucketProtocolV1 = await ethers.getContractFactory("BucketProtocolV1");
  const bp = await BucketProtocolV1.deploy();
  await bp.deployed();
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
