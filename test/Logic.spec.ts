import { Logic } from "./../typechain/contracts/Logic"
import { deployments, ethers } from "hardhat"
import { expect } from "chai"
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers"

describe("Logic", function () {
    let logic: Logic
    let [admin, minter, holder]: SignerWithAddress[] = []

    before(async function () {
        ;[admin, minter, holder] = await ethers.getSigners()
    })
    beforeEach(async () => {
        await deployments.fixture(["LocationNFT", "Logic"])
        logic = (await ethers.getContract("Logic")) as Logic
    })

    it("should airdrop token", async function () {
        expect(false).to.equal(true)
    })
    it("shuld mint token", async function () {
        expect(false).to.equal(true)
    })
})
