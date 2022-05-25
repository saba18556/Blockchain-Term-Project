pragma solidity >=0.5.0 <0.9.0;

contract Auction{

    // the one who starts the auction
    address payable public owner;

    // start time of the auction
    uint public start_time;

    // end time of the auction
    uint public end_time;

    // declaring state for the auction
    enum state {Start, Running, End, Cancel}
    state public auctionState;
    
    uint public highestBid;

    // highest bid from the other participants
    uint public highestBindingBid;

    // increment of bids
    uint public inc;

    // highest bidder in the auction
    address payable public highestBidder;

    // storing values of bid against participant's addresses
    mapping(address => uint) public bids;

    constructor() public {

        owner = msg.sender;

        // on deployment state is set to Running
        auctionState = state.Running;

        // starts when contract is deployed
        start_time = block.number;

        // ends after a week
        end_time = start_time + 604800;

        // bid increment is by 0.5 ether
        inc = 0.5 ether;
    }

    modifier notOwner(){
        require(msg.sender != owner, "owner cannot bid!");
        _;
    }

    modifier Owner(){
        require(msg.sender == owner, "Only owners can manipulate!");
        _;
    }

    modifier started(){
        require(block.number>start_time);
        _;
    }

    modifier ended(){
        require(block.number<end_time);
        _;
    }

    function cancelAuc() public Owner{

        // participants cannot change the state
        auctionState = state.Cancel;
    }

    function endAuc() public Owner{

        // participants cannot change the state
        auctionState = state.End;
    }

    function min(uint a, uint b) pure private returns(uint){
        if (a<=b){
            return a;
        }
        else{
            return b;
        }
    }

    function placeBid() payable public notOwner started{
        
        // owner cannot place a bid
        // auction should be in a running state to place bid
        require(auctionState == state.Running);

        // the bid placed should be more than the increment declared i.e 1 ether
        require(msg.value>1 ether);

        // current bid will be stored by acquiring participant's amount plus bid increment
        uint currentbid = bids[msg.sender] + inc;

        // if current bid is greater than highest payable bid
        require(currentbid > highestBindingBid);

        // it will be added in the bids record against the participant's address
        bids[msg.sender] = currentbid;


        if(currentbid<bids[highestBidder]){
            highestBindingBid = min(currentbid + inc, bids[highestBidder]);
        }
        else{
            highestBindingBid = min(currentbid, bids[highestBidder] + inc);
            highestBidder = msg.sender;
        }


    }

    function withdraw() public{

        // if the auction got cancelled or ended or reached the end time
        require((auctionState == state.Cancel) ||(auctionState == state.End)|| (block.number > end_time));
        
        // person can either be owner or bidder
        require((msg.sender == owner) || (bids[msg.sender] > 0));

        address payable person;
        uint amount;

        // if the auction gets cancelled all the amount will be send back to the bidders
        if(auctionState == state.Cancel){
            person = msg.sender;
            amount = bids[msg.sender];
        }

        else{

            // if the auction ends then owner will get the highet payable bid
            if(msg.sender == owner){
                person = owner;
                amount = highestBindingBid;
            }
            else{

                // if it's the highest bidder then it will get his remaining amount back
                if(msg.sender == highestBidder){
                    person = highestBidder;
                    amount = bids[highestBidder] - highestBindingBid;              
                }

                // if the remaining bidders end it they will get their amounts back
                else{
                    person = msg.sender;
                    amount = bids[msg.sender];
                }
            }
        }

        // the amount will be transferred to the relevant person
        person.transfer(amount);

    }

}