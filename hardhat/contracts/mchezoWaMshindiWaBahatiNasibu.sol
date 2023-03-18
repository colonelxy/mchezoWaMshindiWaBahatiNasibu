// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol"
import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol"

contract mchezoWaMshindiWaBahatiNasibu is VRFConsumerBase, Ownable {
    uint256 public ada;
    bytes32 public keyHash;
    address[] public wachezaji;

    uint8 wachezajiWaKiwangoChaJuu;

    bool public mchezoUmeanza;

    uint256 adaYaKuingia;

    uint256 public kitambulishoChaMchezo;

    event MchezoKuanza(uint256 kitambulishoChaMchezo, uint8 wachezajiWaKiwangoChaJuu,  uint256 adaYaKuingia);

    event MchezajiAjiunga(uint256 kitambulishoChaMchezo, address mchezaji);

    event MchezoKumalizika( uint256 kitambulishoChaMchezo, address mshindi, bytes32 kitambulishoChaOmbi);


}