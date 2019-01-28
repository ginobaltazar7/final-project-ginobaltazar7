/*
    Consensys Final proj on Solidity version 0.5
    Marketplace contract to trade, ie buy and sell, digital representations of Endangered Wildlife
    MEW - Marketplace of Endangered Wildlife, inspired by my love of cats
    To create communities of interest, indirectly funding their conservation
    Baltazar 2019
*/

pragma solidity ^0.5.0;

import './Store.sol'; 

/// @title A simulator Marketplace to trade digital representations of Endangered Wildlife (MEW)
/// @author GBaltazar
/// @notice Very basic simulation
/// @dev Gas costs warning: functions may not execute if gas requirements are too high 
contract Marketplace {
  mapping (address => bool) public MEWstoreOwners;
  mapping (address => bool) public MEWadmins;
  address[] public MEWstoreOwnerRequests;
  mapping (address => address[]) public MEWstoreAddressesByOwner;

  event MEWStoreOwnerRequestSent(address MEWstoreOwnerRequestAddress);
  event MEWStoreOwnerAdded(address MEWstoreOwnerAddress);
  event MEWStoreOwnerRequestsUpdated(address[]);
  event MEWNewStoreCreated(address owner, address store);


  modifier isStoreOwner() {
    require(MEWstoreOwners[msg.sender] == true);
    _;
  }

  modifier isAdmin() {
    require(MEWadmins[msg.sender] == true);
    _;  
  }

  /// @dev set admin as person who instantiated the MEW marketplace contract
  constructor() public {
    MEWadmins[msg.sender] = true;
  }

  /// @dev fetch list of store contract addresses that msg.sender owns.
  /// @return list of store contract addresses.
  function MEWfetchStoreAddressesByOwner() public view returns (address[] memory) {
    return MEWstoreAddressesByOwner[msg.sender];
  }

  /// @dev create new store contract with msg.sender as owner.
  /// @param name is the name of the store.
  /// @param description is the description of the store.
  function MEWcreateNewStore(string memory name, string memory description) public isStoreOwner {
    Store newStore = new Store(msg.sender, name, description);
    MEWstoreAddressesByOwner[msg.sender].push(address(newStore));
    emit MEWNewStoreCreated(msg.sender, address(newStore));
  } 

  /// @dev Fetch type of user msg.sender.
  /// @return Type of user msg.sender in a string.
  function MEWfetchUserType() public view returns (string memory) {
    if (MEWadmins[msg.sender] == true) {
      return 'MEW admin';
    }
    else if (MEWstoreOwners[msg.sender] == true) {
      return 'MEW storeOwner';
    }
    else {
      return 'MEW adopter';
    }
  }

  /// @dev Adds a request for msg.sender to become a store owner 
  function MEWaddStoreOwnerRequest() public {
    MEWstoreOwnerRequests.push(msg.sender);
    emit MEWStoreOwnerRequestSent(msg.sender);
  }

  /// @dev Adds a new store owner from the list of requests.
  /// @param index among list of requests of the approved store owner.
  /// @param storeOwner is the address of the store owner that admin approves.
  function MEWaddStoreOwner(uint index, address storeOwner) public isAdmin {
    require(MEWstoreOwnerRequests.length > index);
    require(MEWstoreOwnerRequests[index] == storeOwner);
    MEWstoreOwners[storeOwner] = true;
    emit MEWStoreOwnerAdded(storeOwner);
  }

  /// @dev Fetch all the store owner requests.
  /// @return List of all the addresses of open requests.
  function MEWfetchStoreOwnerRequests() public view returns (address[] memory) {
    return MEWstoreOwnerRequests;
  }

  /// @dev Adds a new admin to the marketplace.
  /// @param newAdmin Address of the new admin to add.
  function MEWaddAdmin(address newAdmin) public isAdmin {
    MEWadmins[newAdmin] = true;
  }

  /// @dev Admins can withdraw any funds sent to the contract.
  function MEWwithdraw() public payable isAdmin {
    msg.sender.transfer(address(this).balance);
  }

  /// @dev Default payable function.
  function () external payable {}
}
