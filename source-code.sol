// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CustomerServiceTracker {
    struct Ticket {
        uint256 ticketId;
        string customerName;
        string productSerial;
        string issueDescription;
        uint256 creationDate;
        uint256 resolutionDate;
        Status status;
        string resolutionNotes;
        address assignedAgent;
    }
    
    enum Status { 
        OPEN, 
        IN_PROGRESS, 
        AWAITING_PARTS, 
        RESOLVED, 
        CLOSED 
    }
    
    mapping(uint256 => Ticket) public tickets;
    uint256 public ticketCount;
    address public owner;

    
    event TicketCreated(uint256 ticketId, string customerName, string productSerial);
    event StatusUpdated(uint256 ticketId, Status newStatus);
    event AgentAssigned(uint256 ticketId, address agent);
    event ResolutionAdded(uint256 ticketId, string resolutionNotes);
    
    constructor() {
        owner = msg.sender;
        ticketCount = 0;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }
    
    modifier onlyAgent(uint256 _ticketId) {
        require(
            msg.sender == tickets[_ticketId].assignedAgent || msg.sender == owner,
            "Only assigned agent or owner can perform this action"
        );
        _;
    }
    
    
    function createTicket(
        string memory _customerName,
        string memory _productSerial,
        string memory _issueDescription
    ) public {
        ticketCount++;
        tickets[ticketCount] = Ticket({
            ticketId: ticketCount,
            customerName: _customerName,
            productSerial: _productSerial,
            issueDescription: _issueDescription,
            creationDate: block.timestamp,
            resolutionDate: 0,
            status: Status.OPEN,
            resolutionNotes: "",
            assignedAgent: address(0)
        });
        
        emit TicketCreated(ticketCount, _customerName, _productSerial);
    }
    
    function assignAgent(uint256 _ticketId, address _agent) public onlyOwner {
        require(tickets[_ticketId].ticketId != 0, "Ticket does not exist");
        tickets[_ticketId].assignedAgent = _agent;
        tickets[_ticketId].status = Status.IN_PROGRESS;
        
        emit AgentAssigned(_ticketId, _agent);
        emit StatusUpdated(_ticketId, Status.IN_PROGRESS);
    }
    
    // Maj le statut d'un ticket
    function updateStatus(uint256 _ticketId, Status _newStatus) public onlyAgent(_ticketId) {
        require(tickets[_ticketId].ticketId != 0, "Ticket does not exist");
        
        if (_newStatus == Status.RESOLVED) {
            tickets[_ticketId].resolutionDate = block.timestamp;
        }
        
        tickets[_ticketId].status = _newStatus;
        emit StatusUpdated(_ticketId, _newStatus);
    }
    
    // Ajouter des notes de résolution
    function addResolutionNotes(uint256 _ticketId, string memory _resolutionNotes) public onlyAgent(_ticketId) {
        require(tickets[_ticketId].ticketId != 0, "Ticket does not exist");
        require(tickets[_ticketId].status == Status.RESOLVED || tickets[_ticketId].status == Status.CLOSED, 
            "Ticket must be resolved or closed to add resolution notes");
        
        tickets[_ticketId].resolutionNotes = _resolutionNotes;
        emit ResolutionAdded(_ticketId, _resolutionNotes);
    }
    
    function closeTicket(uint256 _ticketId) public onlyAgent(_ticketId) {
        require(tickets[_ticketId].status == Status.RESOLVED, "Ticket must be resolved before closing");
        tickets[_ticketId].status = Status.CLOSED;
        emit StatusUpdated(_ticketId, Status.CLOSED);
    }
    
    // Fonctions de consultation
    function getTicketDetails(uint256 _ticketId) public view returns (
        uint256, string memory, string memory, string memory, 
        uint256, uint256, Status, string memory, address
    ) {
        require(tickets[_ticketId].ticketId != 0, "Ticket does not exist");
        Ticket memory ticket = tickets[_ticketId];
        return (
            ticket.ticketId,
            ticket.customerName,
            ticket.productSerial,
            ticket.issueDescription,
            ticket.creationDate,
            ticket.resolutionDate,
            ticket.status,
            ticket.resolutionNotes,
            ticket.assignedAgent
        );
    }
    
    function getTicketStatus(uint256 _ticketId) public view returns (Status) {
        require(tickets[_ticketId].ticketId != 0, "Ticket does not exist");
        return tickets[_ticketId].status;
    }
}