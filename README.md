
# 📋 Customer Service Tracker – Smart Contract

This is a **Solidity smart contract** for managing customer service tickets on the blockchain. It allows the creation, tracking, assignment, resolution, and closure of support tickets in a decentralized and transparent way.

---

## 🛠 Features

- Create support tickets with customer info and issue description  
- Assign agents to tickets (by contract owner)  
- Update ticket status (open, in progress, awaiting parts, resolved, closed)  
- Add resolution notes after resolving issues  
- Track timestamps for ticket creation and resolution  
- View full ticket details and status

---

## 🧱 Smart Contract Structure

### 🧩 Structs
```solidity
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
```

### 🔄 Enum: Status
```solidity
enum Status { 
    OPEN, 
    IN_PROGRESS, 
    AWAITING_PARTS, 
    RESOLVED, 
    CLOSED 
}
```

---

## ⚙️ Key Functions

| Function | Description |
|---------|-------------|
| `createTicket(...)` | Creates a new support ticket |
| `assignAgent(...)` | Assigns an agent to a ticket (only owner) |
| `updateStatus(...)` | Updates the status of a ticket (only agent/owner) |
| `addResolutionNotes(...)` | Adds resolution notes after ticket is resolved or closed |
| `closeTicket(...)` | Marks a resolved ticket as closed |
| `getTicketDetails(...)` | Returns full ticket info |
| `getTicketStatus(...)` | Returns current status of a ticket |

---

## 🔐 Access Control

- `onlyOwner`: only the contract deployer can assign agents  
- `onlyAgent`: only the assigned agent (or the owner) can update status or add notes  

---

## 📢 Events

| Event | Trigger |
|-------|--------|
| `TicketCreated(uint256, string, string)` | On ticket creation |
| `StatusUpdated(uint256, Status)` | On status change |
| `AgentAssigned(uint256, address)` | When an agent is assigned |
| `ResolutionAdded(uint256, string)` | When resolution notes are added |

---

## 📦 Deployment

```solidity
pragma solidity ^0.8.0;
```

- ✅ Compatible with Solidity 0.8.x
- 🔐 Owner-based permission model

---

## ✅ Example Use Case

1. User creates a ticket describing their issue  
2. Owner assigns the ticket to an available agent  
3. Agent updates the status as work progresses  
4. Once resolved, agent adds resolution notes  
5. Finally, the ticket is closed

---
