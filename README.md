# E_Election

Introduction:
    The provided Solidity smart contract, titled "Voting," is a decentralized application (DApp) designed 
for managing elections on the Ethereum blockchain. This contract enables the registration of voters 
and candidates, the initiation and conclusion of elections, and the casting of votes, including 
delegated votes.

Key Components:
    1. Structs and Mappings:
     - The contract employs several structs to organize and store data, such as `Voters_List` for voter 
    details, `Candidate_List` for candidate details, and others to manage eligibility, voting status, and 
    identifiers.
     - Mappings are used to associate addresses or IDs with relevant data, ensuring efficient retrieval 
    and manipulation.
    2. Enums:
     - The `DelegatedRelationship` enum defines relationships for delegated votes, allowing users to 
    delegate their voting rights to specific individuals.
    3. State Variables:
     - Key state variables include counts for total active voters, active candidates, and total votes.
     - The contract tracks the election commission's address, IDs for voters and candidates, and flags for 
    the election's status.
    4. Modifiers:
     - Modifiers like `onlyElectionCommission` restrict access to specific functions to the authorized 
    election commission.
     - Additional modifiers, such as `OneTimeRegistrationVoter` and `votePolling`, enforce certain 
    conditions for voter registration and voting processes.
    5. Events:
     - Events like `voter_registration` and `candidate_registration` log successful registrations.
     - Events such as `Approved` and `Rejected_or_Banned` provide transparency on the approval or 
    rejection of voters and candidates.
    6. Functions:
     - The contract includes functions for registering voters and candidates, approving or rejecting them, 
    starting and ending elections, and casting votes.
     - Delegated voting is supported through the `delegate_my_vote` function, allowing voters to 
    delegate their votes to others.
    7. Result Retrieval:
     - Functions like `get_candidate_result` and `get_election_result` enable users to retrieve specific 
    candidate results or overall election results.
    8. Information Retrieval:
     - Functions like `get_voter_detail` and `get_candidate_detail` provide detailed information about 
    voters and candidates.
     - The `get_candidate_list` function retrieves the list of candidates.
    9. Eligibility Check:
     - Functions such as `get_voter_eligibility` and `get_candidate_eligibility` allow users to check the 
    eligibility status of voters and candidates.
    
Conclusion:
    The "Voting" smart contract provides a comprehensive and secure framework for conducting 
decentralized elections on the Ethereum blockchain. It incorporates essential features for voter and 
candidate registration, election management, and result retrieval, ensuring transparency and 
reliability in the election process. The use of modifiers, events, and gas-efficient practices enhances 
the overall functionality and efficiency of the contract.

# Development Env:
    Language - Solidity
    IDE - Remix IDE
    Test Network - Ganache
