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

    /**
    * constructor hurithi VRFConsumerBase na kuanzisha thamani za keyHash, ada na mchezoKuanza
    * @param anwani vrfCoordinator  ya mkataba wa VRFCoordinator
    * @param anwani linkToken  ya mkataba wa LINK tokeni 
    * @param vrfAda kiasi cha LINK cha kutuma pamoja na ombi
    @param Kitambulisho cha vrfKeyHash cha ufunguo wa umma ambapo ubahatishaji unatolewa
     */

     constructor(address vrfCoordinator, address linkToken, bytes32 vrfKeyHash, uint256 vrfAda)
     VRFConsumerBase(vrfCoordinator linkToken) {
        keyHash = vrfKeyHash;
        ada = vrfAda;
        mchezoKuanza = false;
     }

     /**
     * anzaMchezo yaanza mchezo kwa kuweka thamani zinazofaa kwa vigezo vyote
      */

    function anzaMchezo(uint8 _wachezajiWaKiwangoChaJuu, uint256 _adaYaKuingia) public onlyOwner{
        // Angalia ikiwa kuna mchezo tayari
        require(!mchezoUmeanza, "Mchezo unaendelea kwa sasa");
        // tupu safu za wachezaji
        delete wachezaji;

        // weka wachezaji wengi zaidi kwa mchezo huu
        wachezajiWaKiwangoChaJuu = _wachezajiWaKiwangoChaJuu;
        mchezoUmeanza = true;

        // sanidi adaYaKuingia ya kiingilio cha mchezo
        adaYaKuingia = _adaYaKuingia
        kitambulishoChaMchezo += 1;
        emit MchezoKuanza(kitambulishoChaMchezo, wachezajiWaKiwangoChaJuu, adaYaKuingia)
    }

    /**
    * jiungaNaMchezo inaitwa wakati mchezaji anataka kuingia kwenye mchezo
     */

     function jiungaNaMchezo() public payable {
        // Angalia ikiwa mchezo tayari unaendelea
        require(mchezoUmeanza, "Mchezo bado haujaanza");

        // Angalia kama thamani iliyotumwa na mtumiaji inalingana na adaYaKuingia
        require(msg.value == adaYaKuingia, "Thamani iliyotumwa si sawa na adaYaKuingia");

        // Angalia ikiwa bado kuna nafasi iliyosalia kwenye mchezo ili kuongeza mchezaji mwingine
        require(wachezaji.length < wachezajiWaKiwangoChaJuu, "Mchezo umejaa");

        // ongeza mtumaji kwenye orodha ya wachezaji
        wachezaji.push(msg.sender);
        emit MchezajiAjiunga(kitambulishoChaMchezo, msg.sender);

        // Ikiwa orodha imejaa anza mchakato wa uteuzi wa mshindi
        if(wachezaji.length == wachezajiWaKiwangoChaJuu) {
            pataMshindiBilaMpangilio();
        }

     }

     /**
     * fulfillRandomness huitwa na VRFCoordinator inapopokea uthibitisho halali wa VRF.
     * Chaguo hili la kukokotoa limebatilishwa ili kufanyia kazi nambari nasibu iliyotolewa na Chainlink VRF.
     * @param kitambulishoChaOmbi (requestId) kitambulisho hiki ni cha kipekee kwa ombi tulilotuma kwa Mratibu wa VRF (VRF Coordinator)
     * @param randomness hii ni kitengo cha uint256 kilichotolewa na kurudishwa kwetu na Mratibu wa VRF (VRF Coordinator)
      */

      function fulfillRandomness(bytes32 requestId,  uint256 randomness) internal virtual override {
        // Tunataka kielezoChaMshindi yetu iwe katika urefu kutoka 0 hadi wachezaji.length-1
        // Kwa hili tunaibadilisha na thamani ya wachezaji.length

        uint256 kielezoChaMshindi = randomness % wachezaji.length;
        // pata anwani ya mshindi kutoka kwa safu ya wachezaji
        address mshindi = wachezaji[kielezoChaMshindi];

        // tuma ethari katika mkataba kwa mshindi
        (bool sent,) = mshindi.call{value: address(this).balance}("");
        require(sent, "Imeshindwa kutuma Ether");

        // Emit kwamba mchezo umekwisha
        emit MchezoKumalizika(kitambulishoChaMchezo, mshindi, kitambulishoChaOmbi);

        // weka mchezoKuanza kutofautisha hali sivyo
        mchezoUmeanza = false;
      }

      /**
      * pataMshindiBilaMpangilio inaitwa kuanza mchakato wa kuchagua mshindi bila mpangilio
       */

       function pataMshindiBilaMpangilio() private returns(bytes32 kitambulishoChaOmbi) {
        // LINK ni kiolesura cha ndani cha tokeni ya LINK inayopatikana ndani ya VRFConsumerBase
        // Hapa tunatumia njia ya balanceOf kutoka kwa kiolesura hicho ili kuhakikisha kuwa mkataba wetu una LINK cha kutosha ili tuweze kumuomba Mratibu wa VRFCoordinator kwa nasibu.

        require(LINK.balanceOf(address(this)) >= ada, "LINK haitoshi");
        // Fanya ombi kwa mratibu wa VRF.
        // requestRandomness ni chaguo la kukokotoa ndani ya VRFConsumerBase
        // huanza mchakato wa kizazi cha nasibu
        return requestRandomness(keyHash, ada);
       }

       // Kazi ya kupokea Ethari. msg.data lazima iwe tupu;
       receive() external payable{}

       // Chaguo za kukokotoa huitwa wakati msg.data si tupu
       fallback() external payable {}





}