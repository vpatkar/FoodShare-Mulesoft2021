-- Donor table script---
CREATE TABLE sys.donor (
    donorID INT NOT NULL AUTO_INCREMENT,
    deviceToken VARCHAR(500) NOT NULL,
    firstName VARCHAR(100) NOT NULL,
    lastName VARCHAR(100) NOT NULL,
    mobileNumber VARCHAR(100) NOT NULL,
    emailAddress VARCHAR(100) NOT NULL,
    establishmentName VARCHAR(100) NOT NULL,
    establishmentRegistrationNumber VARCHAR(100) NOT NULL,
    establishmentLogoURL VARCHAR(500),
    establishmentCountry VARCHAR(100) NOT NULL,
    establishmentCity VARCHAR(100) NOT NULL,
    establishmentStreet VARCHAR(100),
    establishmentPinCode VARCHAR(100) NOT NULL,
    latitude varchar(100) NOT NULL,
    longitude varchar(100) NOT NULL,
    PRIMARY KEY (donorID)
);

select * from donor;

-- Donation Item table -
CREATE TABLE donation_item (
    donationItemID INT NOT NULL AUTO_INCREMENT,
    itemTitle VARCHAR(500) NOT NULL,
    itemShortDesc VARCHAR(1000),
    dateCreated DATETIME NOT NULL default NOW(),
    status VARCHAR(100) NOT NULL default 'SUBMITTED',
    itemExpiryDate DATETIME NOT NULL default (now() + interval 1 day),
    audioFilePath VARCHAR(500),
    donorID varchar(100) NOT NULL,
    beneficiaryID varchar(100),
    PRIMARY KEY (donationItemID)
);

select * from donation_item;

drop table donation_item;

-- Donation Item Attachments --
CREATE TABLE donation_item_attachments (
    donationItemAttachmentID INT NOT NULL AUTO_INCREMENT,
    donationItemID INT NOT NULL,
    fileName VARCHAR(100) NOT NULL,
    mimeType VARCHAR(100),
    url VARCHAR(500),
    PRIMARY KEY (donationItemAttachmentID)
);

-- Beneficiary table script--
CREATE TABLE beneficiary (
    beneficiaryID INT NOT NULL AUTO_INCREMENT,
    deviceToken VARCHAR(500) NOT NULL,
    firstName VARCHAR(100) NOT NULL,
    lastName VARCHAR(100) NOT NULL,
    mobileNumber VARCHAR(100) NOT NULL,
    emailAddress VARCHAR(100) NOT NULL,
    establishmentName VARCHAR(100) NOT NULL,
    establishmentRegistrationNumber VARCHAR(100) NOT NULL,
    establishmentLogoURL VARCHAR(500),
    establishmentCountry VARCHAR(100) NOT NULL,
    establishmentCity VARCHAR(100) NOT NULL,
    establishmentStreet VARCHAR(100),
    establishmentPinCode VARCHAR(100) NOT NULL,
	latitude varchar(100) NOT NULL,
    longitude varchar(100) NOT NULL,
    PRIMARY KEY (beneficiaryID)
);



