 // SPDX-License-Identifier: MIT    
pragma solidity >=0.5.0 <0.9.0;      // we are basically telling why compiler to use providing range of version 

contract TwitterProject {

    struct Tweet {                          // Creating a Struct of Tweet 
        uint id;
        address author;
        string content;
        uint createdAt;
    }
 
    struct Message {                             // Creating a Struct of Message
        uint id;
        string content;
        address sender;
        address receiver;
        uint createdAt;
    }

    uint public nextId;
    uint public nextMessageId;

    mapping (uint => Tweet) public tweets;
    mapping (address => uint[]) public tweetsOf;
    mapping (address => Message[]) public conversations;
    mapping (address => address[]) public following;
    mapping (address => mapping(address => bool)) public operators;

    constructor() {
        nextId = 0;
        nextMessageId = 0;
    }

    function _tweet(address _from, string memory _content) internal {
        require(msg.sender == _from || operators[_from][msg.sender], "You do not have access");

        tweets[nextId] = Tweet(nextId, _from, _content, block.timestamp);   //tweets is a map of struct type we are mapping nextid with the Tweet struct 
        tweetsOf[_from].push(nextId);   //tweetof is a map of array type now we are mapping adress of a user with the array of tweet id 
        nextId++;   //increase the value of next tweet - this can be done by any user of any address
    }

    function _sendMessage(address _sender, address _receiver, string memory _content) internal {
        require(msg.sender == _sender || operators[_sender][msg.sender], "You do not have access");

        conversations[_sender].push(Message(nextMessageId, _content, _sender, _receiver, block.timestamp));  //the data type of map is dynamic array type so we have to push our struct rather than normal memory allocation make sure to write the aruguments provided in fuction in same way u have declare strcut 
        nextMessageId++;
    }

    //below is the example of polymorphism 

    function tweet(string memory _content) public {     //fucntion to call tweet function by owner
        _tweet(msg.sender, _content);
    }

   function tweet(address _from , string memory _content ) public   //function to call tweet function when owner gives acess to partciular address
   {
       _tweet(_from,_content);
   }

function followeingLst(address _following) public {   //this function is for trcaking whom I am following 
    following[msg.sender].push(_following);
}

function allow(address _from) public {
    operators[msg.sender][_from]=true;
}

function disallow(address _from) public {
    operators[msg.sender][_from]=false;
}

function getlatestTweet(uint count) public view returns(Tweet[] memory){
     require(count>0 && count <= nextId, "invalid");
     int j ; 
     Tweet [] memory _tweets = new Tweet[](count);

     for(uint i=nextId-count;i<nextId;i++)
     {
       Tweet storage _structure = tweets[i];  
       _tweets[i]=Tweet(
           _structure.id,
        _structure.author,
        _structure.content,
        _structure. createdAt);
        j=j+1;
     }
     return _tweets;
}

}