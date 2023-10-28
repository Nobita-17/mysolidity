// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

contract crowdfunding {
    mapping(address => uint256) contributors; // this will map the contributor address to the amount paid
    address public manager; //address of manager
    uint256 public minimumcontribution;
    uint256 public target;
    uint256 public deadline;
    uint256 public raised;
    uint256 public noofcontributors;
    bool public pausefund=false; 
    event FundraisingPaused(uint256 timestamp);   //we are declaring event beforehand this is use to pause event

    struct Request {
        string discription;
        address payable receiver;
        uint256 value;
        bool completed;
        uint256 noofvoters;
        mapping(address => bool) voters;
    }
    mapping(uint256 => Request) public request;
    uint256 public noofrequest;

    constructor(uint256 _target, uint256 _deadline) {
        //contructors gets called when the contract is deployed
        deadline = block.timestamp + _deadline; //our manager will deploy it & he will set the target & deadline for crwdfunding
        target = _target;
        minimumcontribution = 10 wei;
        manager = msg.sender; //we are storing the address of the person who deployed our contract
    }

    modifier onlymanager() {
        require(msg.sender == manager, "you are not manager");
        _;
    }

    function pauseevent( uint time) public onlymanager{
        require(pausefund==false,"Event is already Paused");
        pausefund=true;
        uint resumetime = block.timestamp+time;
        emit FundraisingPaused(resumetime);
    }

    function sendEth() public payable {
        require(block.timestamp < deadline, "Time is ended");
        require(msg.value > minimumcontribution, "Amount is two Small");
        require(contributors[msg.sender]<500,"You can only Send less that 500");

        if (contributors[msg.sender] == 0) {
            //here contributor[msg.sender] is a key that is pointing to int which represent amount,If u contribute for fist time then no amont will come  we have keys of diffrent address & this address is pointing to int
            noofcontributors++;
        }
        
        contributors[msg.sender] += msg.value; //here we are increaminting the value
        raised += msg.value;
    }

    function getbalance() public view returns (uint256) {
        return address(this).balance;
    }

    function refund() public {
        //in this we are refunding the amount
        require(
            block.timestamp < deadline && raised < target,
            "We cannot raise sufficent Funds"
        );
        require(
            contributors[msg.sender] > 0,
            "You have not contributed anything"
        );
        address payable user = payable(msg.sender);
        user.transfer(contributors[msg.sender]);
        contributors[msg.sender] = 0;
    }


    function withdraw( uint withdrawamount) public payable {
        require(contributors[msg.sender]>0,"You have not contributed so u cannot withdraw");
        require(withdrawamount<=contributors[msg.sender],"You cannot withdraw more money than contributoted");
        address payable user  = payable(msg.sender);    // Casting msg.sender to an address payable
         
         if(withdrawamount==contributors[msg.sender]){
           user.transfer(contributors[msg.sender]);
           contributors[msg.sender]=0;
         }
         else {
        user.transfer(withdrawamount);
        contributors[msg.sender]=contributors[msg.sender]-withdrawamount;
         }
         
    }

    function createrequest(
        string memory discription1,
        address payable receiver1,
        uint256 value1
    ) public onlymanager {
        Request storage myrequest = request[noofrequest];
        noofrequest++;
        myrequest.discription = discription1;
        myrequest.receiver = receiver1;
        myrequest.value = value1;
        myrequest.completed = false;
        myrequest.noofvoters = 0;
    }

    function vote(uint256 requestNo) public {
        require(contributors[msg.sender] > 0, "You did Not Payed Anything");
        Request storage myrequest = request[requestNo];
        require(myrequest.completed == false, "You have already got refund");
        myrequest.voters[msg.sender] = true;
        myrequest.noofvoters++;
    }

    function finalpayment(uint requestNo) public onlymanager{
        require(raised>target);
        Request storage myrequest = request[requestNo];
        require(myrequest.completed==false,"you have already recieved payment");
        require(myrequest.noofvoters>noofcontributors/2,"You dont have majority Vote");
        myrequest.receiver.transfer(raised);
    }

    function finalinvestor() public onlymanager{
        require(block.timestamp>deadline,"Event is still going on");
        
    }


} //end of contract it is
