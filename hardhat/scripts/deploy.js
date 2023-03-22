const {ethers} = require("hardhat")
require("dotenv").config({peth: ".env"})
const {FEE, VRF_COORDINATOR, LINK_TOKEN, KEY_HASH} = require("../constants")

async function main() {
  /**
   * Kiwanda cha Mkataba (ContractFactory) katika ethers.js ni kifupi kinachotumika kupeleka mikataba mipya mahiri,
  kwa hivyo mchezoWaMshindiWaBahatiNasibu hapa ni kiwanda kwa matukio ya mkataba wetu wa MchezoWaMshindiWaBahatiNasibu.
   */

  const mchezoWaMshindiWaBahatiNasibu = await ethers.getContractFactory("mchezoWaMshindiWaBahatiNasibu")

  // peleka mkataba
  const pelekaMkatabaMchezoWaMshindiWaBahatiNasibu = await mchezoWaMshindiWaBahatiNasibu.deploy(
    VRF_COORDINATOR, LINK_TOKEN, KEY_HASH, FEE
  );

  await pelekaMkatabaMchezoWaMshindiWaBahatiNasibu.deployed()

  // chapisha anwani ya mkataba uliotumwa
  console.log(
    pelekaMkatabaMchezoWaMshindiWaBahatiNasibu.address
  );

  console.log("Nalala...");

  // Subiri kwa etherscan itambue kwamba mkataba umewekwa
  await lala(30000);

  // Thibitisha mkataba baada ya kupeleka
  await hre.run("verify:verify", {
    address: pelekaMkatabaMchezoWaMshindiWaBahatiNasibu.address,
    constructorArguments: [VRF_COORDINATOR, LINK_TOKEN, KEY_HASH, FEE]
  })
}

function lala(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms))

}

// Ita chaguo hili kuu la kukokotoa na ushike ikiwa kuna hitilafu yoyote
main()
.then(() => process.exit(0))
.catch((error) => {
  console.error(error);
  process.exit(1)
})