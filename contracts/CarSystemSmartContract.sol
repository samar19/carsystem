pragma solidity ^0.5.2;
import 'github.com/OpenZeppelin/openzeppelin-solidity/contracts/math/SafeMath.sol';
import 'github.com/OpenZeppelin/openzeppelin-solidity/contracts/cryptography/ECDSA.sol';

contract CarExchange{
    using SafeMath for uint256;
    uint256 minCarValue = 0;
    uint256 timeout = 0;
    // car state represents care life cycle
    enum CarState {Deregistered, Registered, Sold}
    
    struct VinNumber {
        bool isExist;
    }
    
    struct Car {
        CarState state;
        uint256 value;
        uint256 vinNumber;
        address owner;
    }
    
     
    // keccak256(owner + vinNumber) => Car
    mapping(bytes32 => Car) cars;
    // keccak256(VinNumber) = > isExist ?
    mapping(bytes32 => VinNumber) vinNumbers;
    // car List
    bytes32[] public carList;
    mapping (address=>Car[]) carperaddress;
    // modifiers
    modifier onlyRequestOwner(bytes32 requestId)
    {
        //TODO: check request Id ownership
        require(true);
        _;
    }
    
    modifier onlyNonRegisteredCars(uint256 vinNumber)
    {
        bytes32 carId = generateCarId(msg.sender, vinNumber);
        require(
            cars[carId].state == CarState.Deregistered,
            'Car does not exist!'
        );
        _;
    }
    
    modifier onlyUniqueVinNumber(uint256 vinNumber)
    {
        require(
            !vinNumbers[keccak256(abi.encodePacked(vinNumber))].isExist,
            'Vin number is already exists'
        );
        _;
    }
    
    modifier onlyCarOwner(uint256 vinNumber)
    {
        bytes32 carId = generateCarId(msg.sender, vinNumber);
        require(
            cars[carId].state == CarState.Registered,
            'Invalid car owner'
        );
        _;
    }
    
    
    
    // events
    event Registered(
        bytes32 indexed carId,
        address owner,
        uint256 vinNumber
    );
    
    event Deregistered(
        bytes32 indexed carId,
        bool state
    );
    
    event PurchaseRequested(
        bytes32 indexed carId,
        uint256 newValue,
        address newOwner,
        bytes   signature,
        uint256 requestedAt,
        uint256 timeout
    );
      
    constructor(uint256 minValue) 
        public 
    {
        minCarValue = minValue;
    }
    
    function register(uint256 vinNumber, uint256 value) 
        public
        onlyNonRegisteredCars(vinNumber)
        onlyUniqueVinNumber(vinNumber)
    {
        require(
            value >= minCarValue,
            'Invalid car value'
        );
        
        bytes32 carId = keccak256(
            abi.encodePacked(
                msg.sender, 
                vinNumber)
        );
        
        cars[carId] = Car(
            CarState.Registered,
            vinNumber,
            value,
            msg.sender
        );
        vinNumbers[keccak256(abi.encodePacked(vinNumber))].isExist = true;
        carList.push(carId);
        carperaddress[msg.sender].push(Car(
            CarState.Registered,
            vinNumber,
            value,
            msg.sender
        ));
        emit Registered(
            carId, 
            msg.sender, 
            vinNumber
        );
    }
    
    
    function deregister(uint256 vinNumber)
        public
        onlyCarOwner(vinNumber)
    {
        bytes32 carId = generateCarId(msg.sender, vinNumber);
        cars[carId].state = CarState.Deregistered;
        vinNumbers[keccak256(abi.encodePacked(vinNumber))].isExist = false;
        emit Deregistered(
            carId,
            true
        );
    }
    
    function requestPurchase(
        bytes32 carId, 
        uint256 newValue,
        bytes memory signature
    )
        public
    {
        require(
            ECDSA.recover(keccak256(abi.encodePacked(newValue)), signature) == msg.sender,
            'Could not recover signature'
        );
        require(
            cars[carId].state == CarState.Registered,
            'Car does not exist'
        );
        require(
            minCarValue <= newValue,
            'Invalid value'
        );
        //TODO: lock tokens
        emit PurchaseRequested(
            carId,
            newValue,
            msg.sender,
            signature,
            block.number,
            timeout
        );
    }
    
    function cancelPurchase(bytes32 requestId)
        public
        onlyRequestOwner(requestId)
    {
        
    }
    
    function approvePurchase(
        bytes32 carId,
        uint256 vinNumber,
        address newOwner,
        uint256 newValue,
        bytes memory newOwnerSig
    )
        public
        onlyCarOwner(vinNumber)
    {
        require(
            ECDSA.recover(keccak256(abi.encodePacked(newValue)), newOwnerSig) == newOwner,
            'Could not recover signature'
        );
            bytes32 NcarId = keccak256(
            abi.encodePacked(
               newOwner, 
                vinNumber)
        );
        
        cars[NcarId] = Car(
            CarState.Deregistered,
            vinNumber,
            newValue,
           newOwner
        );
    
         cars[carId].state = CarState.Sold;
       
        
        emit Deregistered(
            carId, 
            
            false
        );   
        
    }
 function generateCarId(address owner, uint256 vinNumber)
        public
        pure
        returns(bytes32)
    {
        return keccak256(
            abi.encodePacked(
                owner, 
                vinNumber)
        );
    }
}