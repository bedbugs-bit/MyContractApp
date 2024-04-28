// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract IOUContract {
    struct IOU {
        uint id;
        address issuer;
        address receiver;
        uint amount;
        bool settled;
    }

    IOU[] public ious;
    mapping(address => uint[]) public iousByIssuer;
    mapping(address => uint[]) public iousByReceiver;

    event IOUCreated(uint id, address indexed issuer, address indexed receiver, uint amount);
    event IOUSettled(uint id, address indexed issuer, address indexed receiver);

    function issueIOU(address receiver, uint amount) external {
        ious.push(IOU(ious.length, msg.sender, receiver, amount, false));
        iousByIssuer[msg.sender].push(ious.length - 1);
        iousByReceiver[receiver].push(ious.length - 1);
        emit IOUCreated(ious.length - 1, msg.sender, receiver, amount);
    }

    function settleIOU(uint iouId) external {
        IOU storage iou = ious[iouId];
        require(msg.sender == iou.receiver, "Only the receiver can settle the IOU");
        require(!iou.settled, "IOU already settled");
        iou.settled = true;
        emit IOUSettled(iouId, iou.issuer, iou.receiver);
    }

    function getIOUsIssuedBy(address issuer) external view returns (uint[] memory) {
        return iousByIssuer[issuer];
    }

    function getIOUsReceivedBy(address receiver) external view returns (uint[] memory) {
        return iousByReceiver[receiver];
    }
}
