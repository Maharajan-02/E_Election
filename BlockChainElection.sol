// SPDX-License-Identifier: GPL-3.0

//git-hub : https://github.com/Maharajan-02/E_Election.git

pragma solidity > 0.8.0;

contract Voting{

    uint total_active_voters;
    uint active_candidates;
    address private election_commission;
    uint id_voter;
    uint id_candidate;
    string constant registration_message = "Registration Successful";
    uint private total_votes;

    bool election_started;
    bool election_ended;

    struct Voters_List{
        uint voter_id;
        string voter_name;
        string voter_address;
        uint8 voter_age;
        string voter_aadhaar_number;
    }

    struct Voter_Eligible{
        bool voter_eligible;
    }

    struct Voted{
        bool voted;
    }

    struct Voter_Id_Manager{
        uint id;
    }
   
    struct Candidate_List{
        uint candidate_id;
        string candidate_name;
        string candidate_address;
        string candidate_age;
        string candidate_promise;
    }

    struct Candidate_Eligible{
        bool candiate_eligible;
    }

    struct Candidate_Id_Manager{
        uint id;
    }

    struct Votes{
        uint id;
        uint vote_count;
    }

    struct Delegated_Votes{
        uint delegated_voter_id;
        DelegatedRelationship delegated_voter_relationship;
        bool can_vote;
    }

     enum DelegatedRelationship {Parent, Spouse, Child, Sibling, Friend, Guardian}

    mapping (uint => Voters_List) voters;
    mapping (address => Voter_Id_Manager) voterIdManager;
    mapping (uint  => Candidate_List) candidate;
    mapping (address => Candidate_Id_Manager) candidateIdManager;
    mapping (address => Voted) is_voted;
    mapping (uint => Votes) results;
    mapping (uint => Voter_Eligible) voterEligible;
    mapping (uint => Candidate_Eligible) candidateEligible;
    mapping (uint => Delegated_Votes[]) delegatedVotes;

    Candidate_List[] private candidateList;

    constructor(){
        election_commission = msg.sender;
        total_active_voters = 0;
        active_candidates = 0;
        id_voter = 1;
        id_candidate = 1;
        total_votes = 0;
        election_started = false;
        election_ended = false;
    }

    modifier onlyElectionCommission{
        require(msg.sender == election_commission, "Unauthorized access");
        _;
    }

    modifier OneTimeRegistrationVoter{
        require(voterIdManager[msg.sender].id == 0, "You have already been registered.");
        _;
    }

    modifier OneTimeRegistrationCandidate{
         require(candidateIdManager[msg.sender].id == 0, "You have already been registered.");
        _;
    }
    
    modifier votePolling(uint _candidate_id){
        require(election_started, "Election is not in progress.");
        require(!election_ended, "Election is not in progress.");
        require(voterIdManager[msg.sender].id != 0, "You are not eligible to vote.");
        require(!is_voted[msg.sender].voted, "You have already voted.");
        require(candidateEligible[_candidate_id].candiate_eligible, "The candidate is not eligible.");
        _;
    }

    modifier delegateMyVote(uint _voter_id){
        require(voterIdManager[msg.sender].id != 0, "You are not an authorized voter.");
        require(voterEligible[voterIdManager[msg.sender].id].voter_eligible, "You are not an authorized voter.");
        require(voterEligible[_voter_id].voter_eligible, "They are not an authorized voter.");
        _;
    }

    modifier election_in_progress(){
        require(election_started, "Election is not in progress.");
        require(!election_ended, "Election is not in progress.");
        _;
    }
    

    event voter_registration(address , string);
    event candidate_registration(address , string);
    event Approved(uint);
    event Rejected_or_Banned(uint);
    event Request_For_Registration(address, string);

    function add_voter(string memory _voter_name, string memory _voter_address, uint8 _voter_age, string memory _voter_aadhaar_number) public OneTimeRegistrationVoter{
        voters[id_voter] = Voters_List(id_voter, _voter_name, _voter_address, _voter_age, _voter_aadhaar_number);
        voterIdManager[msg.sender] = Voter_Id_Manager(id_voter);
        voterEligible[id_voter] = Voter_Eligible (false);
        is_voted[msg.sender].voted = false;
        id_voter++;
        emit voter_registration(msg.sender, registration_message);
        emit Request_For_Registration(election_commission, "Request for Voter Registration");
    }

    function approve_or_unBan_voter(uint _voter_id) public onlyElectionCommission{
        if(!voterEligible[_voter_id].voter_eligible){
            voterEligible[_voter_id].voter_eligible = true;
            total_active_voters++;
            emit Approved(_voter_id);
        }else{
            revert("The voter has already been approved.");
        }
    }

    function reject_or_ban_voter(uint _voter_id) public onlyElectionCommission{
        if(voterEligible[_voter_id].voter_eligible){
            voterEligible[_voter_id].voter_eligible = false;
            total_active_voters--;
            emit Rejected_or_Banned(_voter_id);
        }else{
            revert("The voter has already been declined or banned.");
        }
    }

    function register_candidate(string memory _candidate_name, string memory _candidate_address, string memory _candidate_age, string memory _candidate_promise) public OneTimeRegistrationCandidate{
        candidate[id_candidate] = Candidate_List(id_candidate, _candidate_name, _candidate_address, _candidate_age, _candidate_promise);
        candidateIdManager[msg.sender] = Candidate_Id_Manager(id_candidate);
        candidateEligible[id_candidate]  = Candidate_Eligible(false);
        results[id_candidate].vote_count = 0;
        candidateList.push(candidate[id_candidate]);
        id_candidate++;
        emit candidate_registration(msg.sender , registration_message);
        emit Request_For_Registration(election_commission, "Request for Candidate Registration");
    }

    function approve_or_unBan_candidate(uint _candidate_id) public onlyElectionCommission {
        if(!candidateEligible[_candidate_id].candiate_eligible){
            candidateEligible[_candidate_id].candiate_eligible = true;
            active_candidates++;
            emit Approved(_candidate_id);
        }else{
            revert("The candidate has already been approved.");
        }
    }

    function reject_or_ban_candidate(uint _candidate_id) public onlyElectionCommission{
        if(candidateEligible[_candidate_id].candiate_eligible){
            candidateEligible[_candidate_id].candiate_eligible = false;
            active_candidates--;
            emit Rejected_or_Banned(_candidate_id);
        }else{
            revert("The candidate has already been declined or banned.");
        }
    }

    function startElection() public onlyElectionCommission{
        if(!election_started){
            election_started = true;
        }
        else{
            revert("The election is already in progress.");
        }
    }

    function endElection() public onlyElectionCommission{
        if(election_started){
            if(!election_ended){
                election_ended = true;
            }
        }else{
            revert("The election is not started yet.");
        }
    }

    function delegate_my_vote(uint _voter_id, DelegatedRelationship _relationship) public delegateMyVote(_voter_id) {
        delegatedVotes[_voter_id].push( Delegated_Votes(voterIdManager[msg.sender].id, _relationship, true) );
        is_voted[msg.sender].voted = true;
    }

    function registerVote(uint _candidate_id) public votePolling(_candidate_id) election_in_progress{
        require(voterEligible[voterIdManager[msg.sender].id].voter_eligible, "You are not authorized to vote. Please contact Election Commission");
        results[_candidate_id].vote_count++;
        total_votes++;
        is_voted[msg.sender].voted = true;
    }

    function register_delegated_vote(uint _delegated_voter_id, uint _candidate_id) public election_in_progress{
       require(candidateEligible[_candidate_id].candiate_eligible, "The candidate is not eligible.");
        bool voted = false;
        for(uint i = 0; i < delegatedVotes[voterIdManager[msg.sender].id].length; i++){
            if(delegatedVotes[voterIdManager[msg.sender].id][i].delegated_voter_id == _delegated_voter_id){
                results[_candidate_id].vote_count++;
                total_votes++;
                delegatedVotes[voterIdManager[msg.sender].id][i].can_vote = false;
                voted = true;
                break;
            }
        }
        if(!voted){
            revert("You are not delegated by this person");
        }
    }

    function get_voter_detail(uint _voter_id) public view returns (Voters_List memory){
        return voters[_voter_id];
    }

    function get_candidate_detail(uint _candidate_id) public view returns (Candidate_List memory){
        return candidate[_candidate_id];
    }

    function get_candidate_list() public view returns (Candidate_List[] memory){
        return candidateList;
    }

    function get_election_result() public view returns (string memory, uint, uint){
        require(election_ended, "You cannot view the results at the moment.");
        uint max_vote = results[1].vote_count;
        uint tie_id = 0;
        uint  winner = candidate[1].candidate_id;
        for(uint i = 2; i <= active_candidates; i++){
            if(results[i].vote_count > max_vote){
                max_vote = results[i].vote_count;
                winner = candidate[i].candidate_id;
            }else if(results[i].vote_count == max_vote){
                tie_id = i;
            }
        }
        if(tie_id == 0){
            return(string(abi.encodePacked("The winner is ", candidateList[winner].candidate_name)), winner, max_vote);
        }else{
            return ("The result is Tie Between" ,winner,  tie_id);
        }
    }

    function get_candidate_result(uint _candidate_id) public view returns (uint){
        require(election_ended, "You cannot view the results at the moment.");
        return results[_candidate_id].vote_count;
    }

    function get_voter_eligibility(uint _voter_id) public view returns(bool){
        return voterEligible[_voter_id].voter_eligible;
    }

    function get_candidate_eligibility(uint _candidate_id) public view returns(bool){
        return candidateEligible[_candidate_id].candiate_eligible;
    }
}