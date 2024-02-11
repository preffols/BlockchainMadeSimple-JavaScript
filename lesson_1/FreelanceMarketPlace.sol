// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title Counters
 * @author Prince Nsusa(BornToCode)
 * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
 * of elements in a mapping, issuing ERC721 ids, or counting request ids.
 *
 * Include with `using Counters for Counters.Counter;`
 */

contract FreelanceMarketPlace {

// total supply
uint256 public totalSupply;

  //struct to represent a freelance job  
    struct Job{
        address client;
        address freelancer;
        string title;
        string description;
        uint256 budget;
        bool completed;
    }



    //creating an event for a new job post
    event JobCreated(uint256 jobId);

    //Array to store all freelance Jobs
    Job[] public jobs;

 


    constructor() payable  {
      totalSupply = msg.value;
    }


    // function to create new job
    function createJob(

        string memory _title, 
        string memory _description,
        uint256 _budget
        
        )
          external   
        {

          //getting a new index for a new job post
        uint256 jobId = jobs.length;

        // registering the new job post into jobs array
        jobs.push(Job(msg.sender,address(0),_title,_description,_budget,false));

        //emmiting a new job event
        emit JobCreated(jobId);
    }

  function applyForJob(uint256 _jobId) external {
    //checking if job id is within the range
    require(_jobId < jobs.length, "Job does not exist");

  //creating an storage instance var
    Job storage job = jobs[_jobId];

    //checking if job is not already assigned
    require(job.freelancer == address(0), "JOb already taken");

    //assigning the freelancer to the job
    job.freelancer = msg.sender;
  }


  function completeJob(uint256 _jobId) external {
    //creating an storage instance var
    Job storage job = jobs[_jobId];

    //checking if job is not already assigned
    require(job.freelancer != address(0), "JOb in progress");

  //checking the msg.sender is the owner / creater of the job post
    require(msg.sender == job.client, "you are not the client" );

    //checking if job id is within the range
    require(_jobId < jobs.length, "Job does not exist");

   
   
    // marking the job to be finished
     job.completed = true;
    
  }

  function getJobDetails(uint256 _jobId) public view returns(Job memory) {
     //checking if job id is within the range
    require(_jobId < jobs.length, "Job does not exist");

    //returning a job description
    return jobs[_jobId];

  }
}