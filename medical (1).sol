// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MedicalRecordManager {
    struct MedicalRecord {
        address doctor;
        string patientName;
        string details; // could be a hash or summary
        bool delivered;
        uint timestamp;
    }

    mapping(address => MedicalRecord) private records;

    event RecordGenerated(address patient, address doctor, uint timestamp);
    event RecordDelivered(address patient, address doctor, uint timestamp);

    function generateRecord(address patient, string memory patientName, string memory details) public {
        require(records[patient].doctor == address(0), "Record already exists");
        records[patient] = MedicalRecord(msg.sender, patientName, details, false, block.timestamp);
        emit RecordGenerated(patient, msg.sender, block.timestamp);
    }

    function verifyRecord(address patient) public view returns (
        address doctor,
        string memory patientName,
        string memory details,
        bool delivered,
        uint timestamp
    ) {
        MedicalRecord memory r = records[patient];
        require(r.doctor != address(0), "No record found");
        return (r.doctor, r.patientName, r.details, r.delivered, r.timestamp);
    }

    function deliverRecord(address patient) public {
        MedicalRecord storage r = records[patient];
        require(msg.sender == r.doctor, "Only doctor can deliver");
        require(!r.delivered, "Record already delivered");
        r.delivered = true;
        emit RecordDelivered(patient, msg.sender, block.timestamp);
    }
}
