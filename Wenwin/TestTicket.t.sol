// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import "lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import "lib/forge-std/src/Test.sol";
import "src/interfaces/ITicket.sol";
import "src/Ticket.sol";

// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "lib/forge-std/src/Test.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "src/Ticket.sol";

contract TestTicket is Test {
    using Counters for Counters.Counter;

    Ticket ticket;
    Counters.Counter private ticketCounter;

    function setUp() public {
        ticket = new Ticket();
    }

    function testMint() public {
        // Mint a ticket and check its ID
        uint256 ticketId = ticket.mint(address(this), 1, 123456);
        ticketCounter.increment();
        uint256 expectedTicketId = ticketCounter.current();
        assertEq(ticketId, expectedTicketId);

        // Check ticket ownership and ticket info
        assertEq(ticket.ownerOf(ticketId), address(this));
        Ticket.TicketInfo memory info = ticket.ticketsInfo(ticketId);
        assertEq(info.drawId, 1);
        assertEq(info.combination, 123456);
        assertFalse(info.claimed);
    }

    function testMarkAsClaimed() public {
        // Mint a ticket and mark it as claimed
        uint256 ticketId = ticket.mint(address(this), 1, 123456);
        ticket.markAsClaimed(ticketId);
        Ticket.TicketInfo memory info = ticket.ticketsInfo(ticketId);
        assertTrue(info.claimed);
    }
}
