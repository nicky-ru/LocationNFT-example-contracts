import { LocationNFT } from "./../typechain/contracts/LocationNFT"
import { deployments, ethers } from "hardhat"
import { expect } from "chai"
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers"

describe("LocationNFT", function () {
    let locationNFT: LocationNFT
    let [admin, minter, holder]: SignerWithAddress[] = []

    before(async function () {
        ;[admin, minter, holder] = await ethers.getSigners()
    })
    beforeEach(async () => {
        await deployments.fixture(["LocationNFT"])
        locationNFT = (await ethers.getContract("LocationNFT")) as LocationNFT

        const minterRole = await locationNFT.MINTER_ROLE()
        await locationNFT.connect(admin).grantRole(minterRole, minter.address)
    })

    it("should mint token", async function () {
        expect(false).to.equal(true)
    })
})
