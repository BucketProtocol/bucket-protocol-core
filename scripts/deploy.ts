import { ethers } from "hardhat";

async function main() {
  const Test = await ethers.getContractFactory("Test");
  const t = await Test.deploy();
  await t.deployed();

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
