/*
 Author: Garrett Coleman
 Student No.: 96344598
 Course: MSc Computer Science (Conversion) 2013-2014 
 Module: COMP40725 Introduction to Relational Databases & SQL Programming
 Lecturer: Mark Scanlon
 Project - Badminton Club Database
 Date: 17 April 2014
 */
------------ ------------------------------------------------------------------------

/* 
Part 2
Q1. - Database Setup

Create Table Statements

General Note:
Where foreign keys define a mandatory relationship they are set 
to 'NOT NULL'.
Foreign key constraints are used throughout to enforces referential 
integrity by guaranteeing that changes cannot be made to data in the 
primary key table if those changes invalidate the link to data in 
the foreign key table.    

Create Membership_Types Table */
COMMIT;
SET TRANSACTION NAME 'CREATE_MEMBERSHIP_TYPES_TABLE';
SET AUTOCOMMIT OFF;
CREATE TABLE Membership_Types (
membership_type_code NUMBER(10) NOT NULL,
membership_description NVARCHAR2(20),
annual_subscription_amount NUMBER (10,2),
CONSTRAINT pk_Membership_Types PRIMARY KEY (membership_type_code)
);
COMMIT;

/* Create Members Table */
COMMIT;
SET TRANSACTION NAME 'CREATE_MEMBERS_TABLE';
SET AUTOCOMMIT OFF;
CREATE TABLE Members (
membership_no NUMBER(10) NOT NULL,
fname NVARCHAR2(20),
lname NVARCHAR2(20),
address NVARCHAR2(250),
email NVARCHAR2(60),
tel_no VARCHAR(20),
date_joined DATE,
fees_paid_yn CHAR(1),
code_membership_type NUMBER(10) NOT NULL,
CONSTRAINT pk_Members PRIMARY KEY (membership_no),
CONSTRAINT fk_Members FOREIGN KEY (code_membership_type) 
	REFERENCES Membership_Types(membership_type_code),
CONSTRAINT fees_paid_yn check (fees_paid_yn in ('Y', 'N'))
);
COMMIT;

/* Create Annual_Member_Payments Table */
COMMIT;
SET TRANSACTION NAME 'CREATE_ANNUAL_MEMBER_PAYMENTS_TABLE';
SET AUTOCOMMIT OFF;
CREATE TABLE Annual_Member_Payments (
payment_id NUMBER(10) NOT NULL,
payment_amount NUMBER (10,2),
membership_year NUMBER (4),
date_paid DATE,
no_membership NUMBER(10) NOT NULL,
CONSTRAINT pk_Annual_Member_Payments PRIMARY KEY (payment_id),
CONSTRAINT fk_Annual_Member_Payments FOREIGN KEY (no_membership) 
REFERENCES Members(membership_no)
);
COMMIT;

/* 
Create Lockers Table
As the use of a locker is optional the membership_no
foreign key is nullable
*/
COMMIT;
SET TRANSACTION NAME 'CREATE_LOCKERS_TABLE';
SET AUTOCOMMIT OFF;
CREATE TABLE Lockers (
locker_no NUMBER(10) NOT NULL,
changing_room NVARCHAR2(20),
no_membership NUMBER(10),
CONSTRAINT pk_Lockers PRIMARY KEY (locker_no),
CONSTRAINT fk_Lockers FOREIGN KEY (no_membership) 
REFERENCES Members(membership_no)
);
COMMIT;

/* Create Teams Table */
COMMIT;
SET TRANSACTION NAME 'CREATE_TEAMS_TABLE';
SET AUTOCOMMIT OFF;
CREATE TABLE Teams (
team_id NUMBER(10) NOT NULL,
team_start_year NUMBER(4),
team_name NVARCHAR2(20),
team_division NVARCHAR2(20),
team_captain NVARCHAR2(40),
CONSTRAINT pk_Teams PRIMARY KEY (team_id)
);
COMMIT;

/* Create Team_Players Junction Table
no_membership and id_team are mandatory and are therefore set to 
'not null' */
COMMIT;
SET TRANSACTION NAME 'CREATE_TEAM_PLAYERS_TABLE';
SET AUTOCOMMIT OFF;
CREATE TABLE Team_Players (
no_membership NUMBER(10) NOT NULL REFERENCES Members(membership_no),
id_team NUMBER(10) NOT NULL REFERENCES Teams(team_id),
CONSTRAINT pk_Team_Players PRIMARY KEY (no_membership, id_team)
);
COMMIT;

/* Create Coaches Table */
COMMIT;
SET TRANSACTION NAME 'CREATE_COACHES_TABLE';
SET AUTOCOMMIT OFF;
CREATE TABLE Coaches (
coach_id NUMBER(10) NOT NULL,
fname NVARCHAR2(20),
lname NVARCHAR2(20),
address NVARCHAR2(250),
email NVARCHAR2(60),
tel_no VARCHAR(20),
qualification_level NVARCHAR2(20),
salary NUMBER (10,2),
CONSTRAINT pk_Coaches PRIMARY KEY (coach_id)
);
COMMIT;

/* Create Team_Coaching_Sessions Table */
COMMIT;
SET TRANSACTION NAME 'CREATE_TEAM_COACHING_SESSIONS_TABLE';
SET AUTOCOMMIT OFF;
CREATE TABLE Team_Coaching_Sessions (
coaching_session_id NUMBER(10) NOT NULL,
coaching_session_datetime TIMESTAMP,
id_team NUMBER(10) NOT NULL,
id_coach NUMBER(10) NOT NULL,
CONSTRAINT pk_Team_Coaching_Sessions PRIMARY KEY (coaching_session_id),
CONSTRAINT fk_Team_Coaching_Sessions1 FOREIGN KEY (id_team) 
REFERENCES Teams(team_id),
CONSTRAINT fk_Team_Coaching_Sessions2 FOREIGN KEY (id_coach) 
REFERENCES Coaches(coach_id)
);
COMMIT;

/* Create Courts Table */
COMMIT;
SET TRANSACTION NAME 'CREATE_COURTS_TABLE';
SET AUTOCOMMIT OFF;
CREATE TABLE Courts (
court_no NUMBER(10) NOT NULL,
CONSTRAINT pk_Courts PRIMARY KEY (court_no)
);
COMMIT;

/* Create Court_Sessions Table */
COMMIT;
SET TRANSACTION NAME 'CREATE_COURT_SESSIONS_TABLE';
SET AUTOCOMMIT OFF;
CREATE TABLE Court_Sessions (
court_session_id NUMBER(10) NOT NULL,
court_session_start_datetime TIMESTAMP,
court_session_end_datetime TIMESTAMP,
court_session_available_yn CHAR(1),
no_court NUMBER(10) NOT NULL,
CONSTRAINT pk_Court_Sessions PRIMARY KEY (court_session_id),
CONSTRAINT fk_Court_Sessions FOREIGN KEY (no_court) 
	REFERENCES Courts(court_no),
CONSTRAINT court_session_available_yn check (court_session_available_yn in ('Y', 'N'))
);
COMMIT;

/* Create Court_Bookings Table */
COMMIT;
SET TRANSACTION NAME 'CREATE_COURT_BOOKINGS_TABLE';
SET AUTOCOMMIT OFF;
CREATE TABLE Court_Bookings (
court_booking_id NUMBER(10) NOT NULL,
id_court_session NUMBER(10) NOT NULL,
no_membership NUMBER(10) NOT NULL,
CONSTRAINT pk_Court_Bookings PRIMARY KEY (court_booking_id),
CONSTRAINT fk_Court_Bookings1 FOREIGN KEY (id_court_session) 
REFERENCES Court_Sessions(court_session_id),
CONSTRAINT fk_Court_Bookings2 FOREIGN KEY (no_membership) 
REFERENCES Members(membership_no)
);
COMMIT;

------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------

/* Insert Data into Tables */

/* Membership_Types Table */

-- Create sequence to be used for membership_type_code primary key
CREATE SEQUENCE Membership_Types_Sequence START WITH 1
INCREMENT BY 1
minvalue 1
maxvalue 10000000;

INSERT INTO Membership_Types (membership_type_code, membership_description, annual_subscription_amount) 
	VALUES ( Membership_Types_Sequence.nextval, 'Full Member', 500.00);
INSERT INTO Membership_Types (membership_type_code, membership_description, annual_subscription_amount) 
	VALUES ( Membership_Types_Sequence.nextval, 'Senior Member', 400.00);
INSERT INTO Membership_Types (membership_type_code, membership_description, annual_subscription_amount) 
	VALUES ( Membership_Types_Sequence.nextval, 'Student Member', 300.00);


/* Members Table */

-- Create sequence to be used for membership_no primary key
CREATE SEQUENCE Members_Sequence START WITH 1
INCREMENT BY 1
minvalue 1
maxvalue 10000000;

INSERT INTO Members (membership_no, fname, lname, address, email, tel_no, date_joined, fees_paid_yn, code_membership_type) 
	VALUES ( Members_Sequence.nextval, 'Lin', 'Dan', '2 Wynnefield Rd, Dublin 6, Co. Dublin', 'lindan@gmail.com', '0861057898', to_date('2013-01-15', 'YYYY-MM-DD'), 'Y', 01);
INSERT INTO Members (membership_no, fname, lname, address, email, tel_no, date_joined, fees_paid_yn, code_membership_type) 
	VALUES ( Members_Sequence.nextval, 'Lee', 'Chongwei', '40 Dunville Ave, Dublin 6', 'leechongwei@gmail.com', '0862508756', to_date('2013-01-22', 'YYYY-MM-DD'), 'Y', 01);
INSERT INTO Members (membership_no, fname, lname, address, email, tel_no, date_joined, fees_paid_yn, code_membership_type) 
	VALUES ( Members_Sequence.nextval, 'Taufik', 'Hydiat', '28 Fitzwilliam St Upr, Dublin 2', 'taufik@gmail.com', '0862583675', to_date('2013-02-02', 'YYYY-MM-DD'), 'Y', 01);
INSERT INTO Members (membership_no, fname, lname, address, email, tel_no, date_joined, fees_paid_yn, code_membership_type) 
	VALUES ( Members_Sequence.nextval, 'Peter', 'Gade', '80 Cushlawn Pk, Dublin 24', 'petergade@gmail.com', '0866582147', to_date('2013-02-10', 'YYYY-MM-DD'), 'Y', 01);
INSERT INTO Members (membership_no, fname, lname, address, email, tel_no, date_joined, fees_paid_yn, code_membership_type) 
	VALUES ( Members_Sequence.nextval, 'Scott', 'Evans', '53 Talbot St, Dublin 1', 'scottevans@gmail.com', '0862783679', to_date('2013-02-18', 'YYYY-MM-DD'), 'Y', 01);
INSERT INTO Members (membership_no, fname, lname, address, email, tel_no, date_joined, fees_paid_yn, code_membership_type) 
	VALUES ( Members_Sequence.nextval, 'Chloe', 'Magee', '14 Vernon Ave, Dublin 3', 'chloemagee@gmail.com', '0862473698', to_date('2013-02-26', 'YYYY-MM-DD'), 'Y', 01);
INSERT INTO Members (membership_no, fname, lname, address, email, tel_no, date_joined, fees_paid_yn, code_membership_type) 
	VALUES ( Members_Sequence.nextval, 'Peter', 'Rasmusen', '37 Greenlea Rd, Dublin 6w', 'peterras@gmail.com', '0862483648', to_date('2013-03-12', 'YYYY-MM-DD'), 'Y', 01);
INSERT INTO Members (membership_no, fname, lname, address, email, tel_no, date_joined, fees_paid_yn, code_membership_type) 
	VALUES ( Members_Sequence.nextval, 'Rudy', 'Hartono', '27 Portersgate Cres, Dublin 15', 'hartono@gmail.com', '0862547368', to_date('2013-03-28', 'YYYY-MM-DD'), 'Y', 01);
INSERT INTO Members (membership_no, fname, lname, address, email, tel_no, date_joined, fees_paid_yn, code_membership_type) 
	VALUES ( Members_Sequence.nextval, 'Saina', 'Nehwal', '46 Upper Mount St, Dublin 2', 'sainanehwal@gmail.com', '0862549358', to_date('2013-04-05', 'YYYY-MM-DD'), 'Y', 03);
INSERT INTO Members (membership_no, fname, lname, address, email, tel_no, date_joined, fees_paid_yn, code_membership_type) 
	VALUES ( Members_Sequence.nextval, 'Morten', 'Hansen', '132 Rutland Grove, Crumlin, Dublin 12', 'mortenhansen@gmail.com', '0862453150', to_date('2013-04-09', 'YYYY-MM-DD'), 'Y', 01);
INSERT INTO Members (membership_no, fname, lname, address, email, tel_no, date_joined, fees_paid_yn, code_membership_type) 
	VALUES ( Members_Sequence.nextval, 'Erland', 'Kops', '273 Griffith Ave, Dublin 9', 'erlandkops@gmail.com', '0865487963', to_date('2013-04-19', 'YYYY-MM-DD'), 'Y', 01);
INSERT INTO Members (membership_no, fname, lname, address, email, tel_no, date_joined, fees_paid_yn, code_membership_type) 
	VALUES ( Members_Sequence.nextval, 'Royce', 'Reyes', '16 Lr Liffey St, Dublin 1', 'royce@gmail.com', '0862483687', to_date('2013-04-25', 'YYYY-MM-DD'), 'Y', 01);
INSERT INTO Members (membership_no, fname, lname, address, email, tel_no, date_joined, fees_paid_yn, code_membership_type) 
	VALUES ( Members_Sequence.nextval, 'Susi', 'Susanti', '5 Barton Ct, Churchtown, Dublin 14', 'susibaby@gmail.com', '0863259846', to_date('2013-05-07', 'YYYY-MM-DD'), 'Y', 01);
INSERT INTO Members (membership_no, fname, lname, address, email, tel_no, date_joined, fees_paid_yn, code_membership_type) 
	VALUES ( Members_Sequence.nextval, 'Tina', 'Rasmusen', '33 Merrion Sq Upr, Dublin 2', 'tinaras@gmail.com', '0863249876', to_date('2013-05-13', 'YYYY-MM-DD'), 'Y', 01);
INSERT INTO Members (membership_no, fname, lname, address, email, tel_no, date_joined, fees_paid_yn, code_membership_type) 
	VALUES ( Members_Sequence.nextval, 'Tony', 'Gunawan', '7a Shanliss Rd, Dublin 9', 'gunawan@gmail.com', '0862483648', to_date('2013-05-15', 'YYYY-MM-DD'), 'Y', 01);
INSERT INTO Members (membership_no, fname, lname, address, email, tel_no, date_joined, fees_paid_yn, code_membership_type) 
	VALUES ( Members_Sequence.nextval, 'Gail', 'Emms', '114 Sundrive Rd, Dublin 12', 'gailemms@gmail.com', '0861588725', to_date('2013-06-28', 'YYYY-MM-DD'), 'Y', 01);
INSERT INTO Members (membership_no, fname, lname, address, email, tel_no, date_joined, fees_paid_yn, code_membership_type) 
	VALUES ( Members_Sequence.nextval, 'Pam', 'Peard', 'Wood Ctge, Ballyedmonduff, Co Dublin', 'pampeard@gmail.com', '0865806498', to_date('2013-09-22', 'YYYY-MM-DD'), 'Y', 03);
INSERT INTO Members (membership_no, fname, lname, address, email, tel_no, date_joined, fees_paid_yn, code_membership_type) 
	VALUES ( Members_Sequence.nextval, 'Bernie', 'Deering', '185 Kimmage Rd W, Dublin 12', 'bernied@gmail.com', '0861573289', to_date('2013-10-21', 'YYYY-MM-DD'), 'Y', 01);
INSERT INTO Members (membership_no, fname, lname, address, email, tel_no, date_joined, fees_paid_yn, code_membership_type) 
	VALUES ( Members_Sequence.nextval, 'Maeve', 'Walsh', '137 Galtymore Rd, Dublin 12', 'maevewalsh@gmail.com', '0861247963', to_date('2013-11-15', 'YYYY-MM-DD'), 'Y', 01);
INSERT INTO Members (membership_no, fname, lname, address, email, tel_no, date_joined, fees_paid_yn, code_membership_type) 
	VALUES ( Members_Sequence.nextval, 'Siobhan', 'Grehan', '13 Grand Canal St Lr, Dublin 2', 'siobhang@gmail.com', '0862483648', to_date('2013-12-08', 'YYYY-MM-DD'), 'Y', 01);
INSERT INTO Members (membership_no, fname, lname, address, email, tel_no, date_joined, fees_paid_yn, code_membership_type) 
	VALUES ( Members_Sequence.nextval, 'Grace', 'Webster', '19 Hermitage Grove, Rathfarnham, Dublin 16', 'graceweb@gmail.com', '0861573258', to_date('2014-01-08', 'YYYY-MM-DD'), 'N', 01);
INSERT INTO Members (membership_no, fname, lname, address, email, tel_no, date_joined, fees_paid_yn, code_membership_type) 
	VALUES ( Members_Sequence.nextval, 'Bryan', 'Duggan', '60 Springfield Ave, Dublin 6w', 'bryanduggan@gmail.com', '0862483287', to_date('2014-01-18', 'YYYY-MM-DD'), 'N', 01);
INSERT INTO Members (membership_no, fname, lname, address, email, tel_no, date_joined, fees_paid_yn, code_membership_type) 
	VALUES ( Members_Sequence.nextval, 'Noel', 'Prendergast', '12a Raleigh Sq, Crumlin, Dublin 12', 'nprendergast@gmail.com', '0861483987', to_date('2014-01-25', 'YYYY-MM-DD'), 'N', 01);
INSERT INTO Members (membership_no, fname, lname, address, email, tel_no, date_joined, fees_paid_yn, code_membership_type) 
	VALUES ( Members_Sequence.nextval, 'David', 'Wilson', '13 Wellington Qy, Dublin 2', 'davewilson@gmail.com', '0861483289', to_date('2014-02-14', 'YYYY-MM-DD'), 'N', 01);
INSERT INTO Members (membership_no, fname, lname, address, email, tel_no, date_joined, fees_paid_yn, code_membership_type) 
	VALUES ( Members_Sequence.nextval, 'Damian', 'Mooney', '4 Herbert Pl, Dublin 2', 'damored@gmail.com', '0861593058', to_date('2014-02-28', 'YYYY-MM-DD'), 'N', 01);


/* Annual_Member_Payments Table */

-- Create sequence to be used for payment_id primary key
CREATE SEQUENCE Amp_Sequence START WITH 1
INCREMENT BY 1
minvalue 1
maxvalue 10000000;


/* 2013 */
INSERT INTO Annual_Member_Payments (payment_id, payment_amount, membership_year, date_paid, no_membership) 
	VALUES ( Amp_Sequence.nextval, 500.00, 2013, to_date('2013-01-10', 'YYYY-MM-DD'), 01);
INSERT INTO Annual_Member_Payments (payment_id, payment_amount, membership_year, date_paid, no_membership) 
	VALUES ( Amp_Sequence.nextval, 500.00, 2013, to_date('2013-01-11', 'YYYY-MM-DD'), 02);
INSERT INTO Annual_Member_Payments (payment_id, payment_amount, membership_year, date_paid, no_membership) 
	VALUES ( Amp_Sequence.nextval, 500.00, 2013, to_date('2013-01-12', 'YYYY-MM-DD'), 03);
INSERT INTO Annual_Member_Payments (payment_id, payment_amount, membership_year, date_paid, no_membership) 
	VALUES ( Amp_Sequence.nextval, 500.00, 2013, to_date('2013-01-08', 'YYYY-MM-DD'), 04);
INSERT INTO Annual_Member_Payments (payment_id, payment_amount, membership_year, date_paid, no_membership) 
	VALUES ( Amp_Sequence.nextval, 500.00, 2013, to_date('2013-01-18', 'YYYY-MM-DD'), 05);
INSERT INTO Annual_Member_Payments (payment_id, payment_amount, membership_year, date_paid, no_membership) 
	VALUES ( Amp_Sequence.nextval, 500.00, 2013, to_date('2013-01-19', 'YYYY-MM-DD'), 06);
INSERT INTO Annual_Member_Payments (payment_id, payment_amount, membership_year, date_paid, no_membership) 
	VALUES ( Amp_Sequence.nextval, 500.00, 2013, to_date('2013-01-29', 'YYYY-MM-DD'), 07);
INSERT INTO Annual_Member_Payments (payment_id, payment_amount, membership_year, date_paid, no_membership) 
	VALUES ( Amp_Sequence.nextval, 500.00, 2013, to_date('2013-01-10', 'YYYY-MM-DD'), 08);
INSERT INTO Annual_Member_Payments (payment_id, payment_amount, membership_year, date_paid, no_membership) 
	VALUES ( Amp_Sequence.nextval, 300.00, 2013, to_date('2013-01-11', 'YYYY-MM-DD'), 09);
INSERT INTO Annual_Member_Payments (payment_id, payment_amount, membership_year, date_paid, no_membership) 
	VALUES ( Amp_Sequence.nextval, 500.00, 2013, to_date('2013-01-14', 'YYYY-MM-DD'), 10);
INSERT INTO Annual_Member_Payments (payment_id, payment_amount, membership_year, date_paid, no_membership) 
	VALUES ( Amp_Sequence.nextval, 400.00, 2013, to_date('2013-01-24', 'YYYY-MM-DD'), 11);
INSERT INTO Annual_Member_Payments (payment_id, payment_amount, membership_year, date_paid, no_membership) 
	VALUES ( Amp_Sequence.nextval, 500.00, 2013, to_date('2013-01-14', 'YYYY-MM-DD'), 12);
INSERT INTO Annual_Member_Payments (payment_id, payment_amount, membership_year, date_paid, no_membership) 
	VALUES ( Amp_Sequence.nextval, 500.00, 2013, to_date('2013-01-04', 'YYYY-MM-DD'), 13);
INSERT INTO Annual_Member_Payments (payment_id, payment_amount, membership_year, date_paid, no_membership) 
	VALUES ( Amp_Sequence.nextval, 500.00, 2013, to_date('2013-01-05', 'YYYY-MM-DD'), 14);
INSERT INTO Annual_Member_Payments (payment_id, payment_amount, membership_year, date_paid, no_membership) 
	VALUES ( Amp_Sequence.nextval, 500.00, 2013, to_date('2013-01-15', 'YYYY-MM-DD'), 15);
INSERT INTO Annual_Member_Payments (payment_id, payment_amount, membership_year, date_paid, no_membership) 
	VALUES ( Amp_Sequence.nextval, 500.00, 2013, to_date('2013-01-22', 'YYYY-MM-DD'), 16);
INSERT INTO Annual_Member_Payments (payment_id, payment_amount, membership_year, date_paid, no_membership) 
	VALUES ( Amp_Sequence.nextval, 300.00, 2013, to_date('2013-01-08', 'YYYY-MM-DD'), 17);
INSERT INTO Annual_Member_Payments (payment_id, payment_amount, membership_year, date_paid, no_membership) 
	VALUES ( Amp_Sequence.nextval, 400.00, 2013, to_date('2013-01-28', 'YYYY-MM-DD'), 18);
INSERT INTO Annual_Member_Payments (payment_id, payment_amount, membership_year, date_paid, no_membership) 
	VALUES ( Amp_Sequence.nextval, 500.00, 2013, to_date('2013-01-14', 'YYYY-MM-DD'), 19);
INSERT INTO Annual_Member_Payments (payment_id, payment_amount, membership_year, date_paid, no_membership) 
	VALUES ( Amp_Sequence.nextval, 500.00, 2013, to_date('2013-01-24', 'YYYY-MM-DD'), 20);
INSERT INTO Annual_Member_Payments (payment_id, payment_amount, membership_year, date_paid, no_membership) 
	VALUES ( Amp_Sequence.nextval, 500.00, 2013, to_date('2013-02-22', 'YYYY-MM-DD'), 21);
INSERT INTO Annual_Member_Payments (payment_id, payment_amount, membership_year, date_paid, no_membership) 
	VALUES ( Amp_Sequence.nextval, 500.00, 2013, to_date('2013-02-12', 'YYYY-MM-DD'), 22);
INSERT INTO Annual_Member_Payments (payment_id, payment_amount, membership_year, date_paid, no_membership) 
	VALUES ( Amp_Sequence.nextval, 500.00, 2013, to_date('2013-02-17', 'YYYY-MM-DD'), 23);
INSERT INTO Annual_Member_Payments (payment_id, payment_amount, membership_year, date_paid, no_membership) 
	VALUES ( Amp_Sequence.nextval, 500.00, 2013, to_date('2013-02-11', 'YYYY-MM-DD'), 24);
INSERT INTO Annual_Member_Payments (payment_id, payment_amount, membership_year, date_paid, no_membership) 
	VALUES ( Amp_Sequence.nextval, 500.00, 2013, to_date('2013-02-21', 'YYYY-MM-DD'), 25);

/* 2014 */
INSERT INTO Annual_Member_Payments (payment_id, payment_amount, membership_year, date_paid, no_membership) 
	VALUES ( Amp_Sequence.nextval, 500.00, 2014, to_date('2014-01-10', 'YYYY-MM-DD'), 01);
INSERT INTO Annual_Member_Payments (payment_id, payment_amount, membership_year, date_paid, no_membership) 
	VALUES ( Amp_Sequence.nextval, 500.00, 2014, to_date('2014-01-11', 'YYYY-MM-DD'), 02);
INSERT INTO Annual_Member_Payments (payment_id, payment_amount, membership_year, date_paid, no_membership) 
	VALUES ( Amp_Sequence.nextval, 500.00, 2014, to_date('2014-01-12', 'YYYY-MM-DD'), 03);
INSERT INTO Annual_Member_Payments (payment_id, payment_amount, membership_year, date_paid, no_membership) 
	VALUES ( Amp_Sequence.nextval, 500.00, 2014, to_date('2014-01-08', 'YYYY-MM-DD'), 04);
INSERT INTO Annual_Member_Payments (payment_id, payment_amount, membership_year, date_paid, no_membership) 
	VALUES ( Amp_Sequence.nextval, 500.00, 2014, to_date('2014-01-18', 'YYYY-MM-DD'), 05);
INSERT INTO Annual_Member_Payments (payment_id, payment_amount, membership_year, date_paid, no_membership) 
	VALUES ( Amp_Sequence.nextval, 500.00, 2014, to_date('2014-01-19', 'YYYY-MM-DD'), 06);
INSERT INTO Annual_Member_Payments (payment_id, payment_amount, membership_year, date_paid, no_membership) 
	VALUES ( Amp_Sequence.nextval, 500.00, 2014, to_date('2014-01-29', 'YYYY-MM-DD'), 07);
INSERT INTO Annual_Member_Payments (payment_id, payment_amount, membership_year, date_paid, no_membership) 
	VALUES ( Amp_Sequence.nextval, 500.00, 2014, to_date('2014-01-10', 'YYYY-MM-DD'), 08);
INSERT INTO Annual_Member_Payments (payment_id, payment_amount, membership_year, date_paid, no_membership) 
	VALUES ( Amp_Sequence.nextval, 300.00, 2014, to_date('2014-01-11', 'YYYY-MM-DD'), 09);
INSERT INTO Annual_Member_Payments (payment_id, payment_amount, membership_year, date_paid, no_membership) 
	VALUES ( Amp_Sequence.nextval, 500.00, 2014, to_date('2014-01-14', 'YYYY-MM-DD'), 10);
INSERT INTO Annual_Member_Payments (payment_id, payment_amount, membership_year, date_paid, no_membership) 
	VALUES ( Amp_Sequence.nextval, 400.00, 2014, to_date('2014-01-24', 'YYYY-MM-DD'), 11);
INSERT INTO Annual_Member_Payments (payment_id, payment_amount, membership_year, date_paid, no_membership) 
	VALUES ( Amp_Sequence.nextval, 500.00, 2014, to_date('2014-01-14', 'YYYY-MM-DD'), 12);
INSERT INTO Annual_Member_Payments (payment_id, payment_amount, membership_year, date_paid, no_membership) 
	VALUES ( Amp_Sequence.nextval, 500.00, 2014, to_date('2014-01-04', 'YYYY-MM-DD'), 13);
INSERT INTO Annual_Member_Payments (payment_id, payment_amount, membership_year, date_paid, no_membership) 
	VALUES ( Amp_Sequence.nextval, 500.00, 2014, to_date('2014-01-05', 'YYYY-MM-DD'), 14);
INSERT INTO Annual_Member_Payments (payment_id, payment_amount, membership_year, date_paid, no_membership) 
	VALUES ( Amp_Sequence.nextval, 500.00, 2014, to_date('2014-01-15', 'YYYY-MM-DD'), 15);
INSERT INTO Annual_Member_Payments (payment_id, payment_amount, membership_year, date_paid, no_membership) 
	VALUES ( Amp_Sequence.nextval, 500.00, 2014, to_date('2014-01-22', 'YYYY-MM-DD'), 16);
INSERT INTO Annual_Member_Payments (payment_id, payment_amount, membership_year, date_paid, no_membership) 
	VALUES ( Amp_Sequence.nextval, 300.00, 2014, to_date('2014-01-08', 'YYYY-MM-DD'), 17);
INSERT INTO Annual_Member_Payments (payment_id, payment_amount, membership_year, date_paid, no_membership) 
	VALUES ( Amp_Sequence.nextval, 400.00, 2014, to_date('2014-01-28', 'YYYY-MM-DD'), 18);
INSERT INTO Annual_Member_Payments (payment_id, payment_amount, membership_year, date_paid, no_membership) 
	VALUES ( Amp_Sequence.nextval, 500.00, 2014, to_date('2014-01-14', 'YYYY-MM-DD'), 19);
INSERT INTO Annual_Member_Payments (payment_id, payment_amount, membership_year, date_paid, no_membership) 
	VALUES ( Amp_Sequence.nextval, 500.00, 2014, to_date('2014-01-24', 'YYYY-MM-DD'), 20);


/* Lockers Table */

-- Create sequence to be used for locker_no primary key
CREATE SEQUENCE Lockers_Sequence START WITH 1
INCREMENT BY 1
minvalue 1
maxvalue 10000000;

INSERT INTO Lockers (locker_no, changing_room, no_membership) 
	VALUES ( Lockers_Sequence.nextval, 'ladies', 06);
INSERT INTO Lockers (locker_no, changing_room, no_membership) 
	VALUES ( Lockers_Sequence.nextval, 'ladies', 13);
INSERT INTO Lockers (locker_no, changing_room, no_membership) 
	VALUES ( Lockers_Sequence.nextval, 'ladies', 14);
INSERT INTO Lockers (locker_no, changing_room, no_membership) 
	VALUES ( Lockers_Sequence.nextval, 'ladies', 16);
INSERT INTO Lockers (locker_no, changing_room, no_membership) 
	VALUES ( Lockers_Sequence.nextval, 'ladies', 17);
INSERT INTO Lockers (locker_no, changing_room, no_membership) 
	VALUES ( Lockers_Sequence.nextval, 'ladies', NULL);
INSERT INTO Lockers (locker_no, changing_room, no_membership) 
	VALUES ( Lockers_Sequence.nextval, 'ladies', NULL);
INSERT INTO Lockers (locker_no, changing_room, no_membership) 
	VALUES ( Lockers_Sequence.nextval, 'ladies', NULL);
INSERT INTO Lockers (locker_no, changing_room, no_membership) 
	VALUES ( Lockers_Sequence.nextval, 'ladies', NULL);
INSERT INTO Lockers (locker_no, changing_room, no_membership) 
	VALUES ( Lockers_Sequence.nextval, 'ladies', NULL);
INSERT INTO Lockers (locker_no, changing_room, no_membership) 
	VALUES ( Lockers_Sequence.nextval, 'mens', 01);
INSERT INTO Lockers (locker_no, changing_room, no_membership) 
	VALUES ( Lockers_Sequence.nextval, 'mens', 02);
INSERT INTO Lockers (locker_no, changing_room, no_membership) 
	VALUES ( Lockers_Sequence.nextval, 'mens', 03);
INSERT INTO Lockers (locker_no, changing_room, no_membership) 
	VALUES ( Lockers_Sequence.nextval, 'mens', 04);
INSERT INTO Lockers (locker_no, changing_room, no_membership) 
	VALUES ( Lockers_Sequence.nextval, 'mens', 05);
INSERT INTO Lockers (locker_no, changing_room, no_membership) 
	VALUES ( Lockers_Sequence.nextval, 'mens', 07);
INSERT INTO Lockers (locker_no, changing_room, no_membership) 
	VALUES ( Lockers_Sequence.nextval, 'mens', 08);
INSERT INTO Lockers (locker_no, changing_room, no_membership) 
	VALUES ( Lockers_Sequence.nextval, 'mens', 10);
INSERT INTO Lockers (locker_no, changing_room, no_membership) 
	VALUES ( Lockers_Sequence.nextval, 'mens', 11);
INSERT INTO Lockers (locker_no, changing_room, no_membership) 
	VALUES ( Lockers_Sequence.nextval, 'mens', 12);
INSERT INTO Lockers (locker_no, changing_room, no_membership) 
	VALUES ( Lockers_Sequence.nextval, 'mens', 15);
INSERT INTO Lockers (locker_no, changing_room, no_membership) 
	VALUES ( Lockers_Sequence.nextval, 'mens', NULL);
INSERT INTO Lockers (locker_no, changing_room, no_membership) 
	VALUES ( Lockers_Sequence.nextval, 'mens', NULL);
INSERT INTO Lockers (locker_no, changing_room, no_membership) 
	VALUES ( Lockers_Sequence.nextval, 'mens', NULL);
INSERT INTO Lockers (locker_no, changing_room, no_membership) 
	VALUES ( Lockers_Sequence.nextval, 'mens', NULL);


/* Teams Table */

-- Create sequence to be used for team_id primary key
CREATE SEQUENCE Teams_Sequence START WITH 1
INCREMENT BY 1
minvalue 1
maxvalue 10000000;

/* 2013 */
INSERT INTO Teams (team_id, team_start_year, team_name, team_division, team_captain) 
	VALUES ( Teams_Sequence.nextval, 2013, 'Mens1', 'MD-Division 1', 'Lin Dan');
INSERT INTO Teams (team_id, team_start_year, team_name, team_division, team_captain) 
	VALUES ( Teams_Sequence.nextval, 2013, 'Mens2', 'MD-Division 2', 'Scott Evans');
INSERT INTO Teams (team_id, team_start_year, team_name, team_division, team_captain) 
	VALUES ( Teams_Sequence.nextval, 2013, 'Ladies1', 'LD-Division 1', 'Chloe Magee');
INSERT INTO Teams (team_id, team_start_year, team_name, team_division, team_captain) 
	VALUES ( Teams_Sequence.nextval, 2013, 'Ladies2', 'LD-Division 2', 'Siobhan Grehan');
INSERT INTO Teams (team_id, team_start_year, team_name, team_division, team_captain) 
	VALUES ( Teams_Sequence.nextval, 2013, 'Mixed1', 'XD-Division 1', 'Grace Webster');

/* 2014 */
INSERT INTO Teams (team_id, team_start_year, team_name, team_division, team_captain) 
	VALUES ( Teams_Sequence.nextval, 2014, 'Mens1', 'MD-Division 1', 'Peter Gade');
INSERT INTO Teams (team_id, team_start_year, team_name, team_division, team_captain) 
	VALUES ( Teams_Sequence.nextval, 2014, 'Mens2', 'MD-Division 2', 'Morten Hansen');
INSERT INTO Teams (team_id, team_start_year, team_name, team_division, team_captain) 
	VALUES ( Teams_Sequence.nextval, 2014, 'Ladies1', 'LD-Division 1', 'Saina Nehwal');
INSERT INTO Teams (team_id, team_start_year, team_name, team_division, team_captain) 
	VALUES ( Teams_Sequence.nextval, 2014, 'Ladies2', 'LD-Division 2', 'Maeve Walsh');
INSERT INTO Teams (team_id, team_start_year, team_name, team_division, team_captain) 
	VALUES ( Teams_Sequence.nextval, 2014, 'Mixed1', 'XD-Division 1', 'Tony Gunawan');


/* Team_Players Junction Table */

/* 2013 */
INSERT INTO Team_Players (no_membership, id_team)
	VALUES (01, 01);
INSERT INTO Team_Players (no_membership, id_team)
	VALUES (02, 01);
INSERT INTO Team_Players (no_membership, id_team)
	VALUES (03, 01);
INSERT INTO Team_Players (no_membership, id_team)
	VALUES (04, 01);

INSERT INTO Team_Players (no_membership, id_team)
	VALUES (05, 02);
INSERT INTO Team_Players (no_membership, id_team)
	VALUES (07, 02);
INSERT INTO Team_Players (no_membership, id_team)
	VALUES (08, 02);
INSERT INTO Team_Players (no_membership, id_team)
	VALUES (10, 02);

INSERT INTO Team_Players (no_membership, id_team)
	VALUES (06, 03);
INSERT INTO Team_Players (no_membership, id_team)
	VALUES (09, 03);
INSERT INTO Team_Players (no_membership, id_team)
	VALUES (13, 03);
INSERT INTO Team_Players (no_membership, id_team)
	VALUES (16, 03);

INSERT INTO Team_Players (no_membership, id_team)
	VALUES (17, 04);
INSERT INTO Team_Players (no_membership, id_team)
	VALUES (18, 04);
INSERT INTO Team_Players (no_membership, id_team)
	VALUES (19, 04);
INSERT INTO Team_Players (no_membership, id_team)
	VALUES (20, 04);

INSERT INTO Team_Players (no_membership, id_team)
	VALUES (05, 05);
INSERT INTO Team_Players (no_membership, id_team)
	VALUES (11, 05);
INSERT INTO Team_Players (no_membership, id_team)
	VALUES (12, 05);
INSERT INTO Team_Players (no_membership, id_team)
	VALUES (15, 05);
INSERT INTO Team_Players (no_membership, id_team)
	VALUES (16, 05);
INSERT INTO Team_Players (no_membership, id_team)
	VALUES (17, 05);
INSERT INTO Team_Players (no_membership, id_team)
	VALUES (18, 05);
INSERT INTO Team_Players (no_membership, id_team)
	VALUES (21, 05);

/* 2014 */
INSERT INTO Team_Players (no_membership, id_team)
	VALUES (01, 06);
INSERT INTO Team_Players (no_membership, id_team)
	VALUES (02, 06);
INSERT INTO Team_Players (no_membership, id_team)
	VALUES (03, 06);
INSERT INTO Team_Players (no_membership, id_team)
	VALUES (04, 06);

INSERT INTO Team_Players (no_membership, id_team)
	VALUES (05, 07);
INSERT INTO Team_Players (no_membership, id_team)
	VALUES (07, 07);
INSERT INTO Team_Players (no_membership, id_team)
	VALUES (08, 07);
INSERT INTO Team_Players (no_membership, id_team)
	VALUES (10, 07);

INSERT INTO Team_Players (no_membership, id_team)
	VALUES (06, 08);
INSERT INTO Team_Players (no_membership, id_team)
	VALUES (09, 08);
INSERT INTO Team_Players (no_membership, id_team)
	VALUES (13, 08);
INSERT INTO Team_Players (no_membership, id_team)
	VALUES (16, 08);

INSERT INTO Team_Players (no_membership, id_team)
	VALUES (17, 09);
INSERT INTO Team_Players (no_membership, id_team)
	VALUES (18, 09);
INSERT INTO Team_Players (no_membership, id_team)
	VALUES (19, 09);
INSERT INTO Team_Players (no_membership, id_team)
	VALUES (20, 09);

INSERT INTO Team_Players (no_membership, id_team)
	VALUES (05, 10);
INSERT INTO Team_Players (no_membership, id_team)
	VALUES (11, 10);
INSERT INTO Team_Players (no_membership, id_team)
	VALUES (12, 10);
INSERT INTO Team_Players (no_membership, id_team)
	VALUES (15, 10);
INSERT INTO Team_Players (no_membership, id_team)
	VALUES (16, 10);
INSERT INTO Team_Players (no_membership, id_team)
	VALUES (17, 10);
INSERT INTO Team_Players (no_membership, id_team)
	VALUES (18, 10);
INSERT INTO Team_Players (no_membership, id_team)
	VALUES (21, 10);


/* Coaches Table */

-- Create sequence to be used for coach_id primary key
CREATE SEQUENCE Coaches_Sequence START WITH 1
INCREMENT BY 1
minvalue 1
maxvalue 10000000;

INSERT INTO Coaches (coach_id, fname, lname, address, email, tel_no, qualification_level, salary) 
	VALUES ( Coaches_Sequence.nextval, 'Des', 'Elliot', '164 Dunluce Rd, Clontarf, Co. Dublin', 'deselliot@gmail.com', '0862583458', 'Level 3', 5000.00);
INSERT INTO Coaches (coach_id, fname, lname, address, email, tel_no, qualification_level, salary) 
	VALUES ( Coaches_Sequence.nextval, 'Daniel', 'Magee', '80 Gracefield Ave, Artane, Dublin 5', 'danmagee@gmail.com', '0865873245', 'Level 3', 5000.00);
INSERT INTO Coaches (coach_id, fname, lname, address, email, tel_no, qualification_level, salary) 
	VALUES ( Coaches_Sequence.nextval, 'Mark', 'Topping', '59 Fitzwilliam Sq, Dublin 2', 'marktopping@gmail.com', '0864873258', 'Level 2', 3000.00);
INSERT INTO Coaches (coach_id, fname, lname, address, email, tel_no, qualification_level, salary) 
	VALUES ( Coaches_Sequence.nextval, 'Chris', 'Fusco', '2 Pinebrook Cres, Artane, Dublin 5', 'chrisfusco@gmail.com', '0864583248', 'Level 2', 3000.00);
INSERT INTO Coaches (coach_id, fname, lname, address, email, tel_no, qualification_level, salary) 
	VALUES ( Coaches_Sequence.nextval, 'Karen', 'Bing', '114 Phibsboro Rd, Phibsboro, Dublin 7', 'karenbing@gmail.com', '0864873214', 'Level 2', 3000.00);
INSERT INTO Coaches (coach_id, fname, lname, address, email, tel_no, qualification_level, salary) 
	VALUES ( Coaches_Sequence.nextval, 'Jenny', 'King', '72 Bannow Rd, Cabra, Dublin 7', 'jennyking@gmail.com', '0862983195', 'Level 2', 3000.00);
INSERT INTO Coaches (coach_id, fname, lname, address, email, tel_no, qualification_level, salary) 
	VALUES ( Coaches_Sequence.nextval, 'Sian', 'Williams', '25 Brookville Park, Blackrock, Co. Dublin', 'sianwilliams@gmail.com', '0862593648', 'Level 2', 3000.00);
INSERT INTO Coaches (coach_id, fname, lname, address, email, tel_no, qualification_level, salary) 
	VALUES ( Coaches_Sequence.nextval, 'Niall', 'Tierney', '9 Clarinda Park Nth, Dun Laoghaire, Co Dublin', 'nialltierney@gmail.com', '0862325869', 'Level 2', 3000.00);
INSERT INTO Coaches (coach_id, fname, lname, address, email, tel_no, qualification_level, salary) 
	VALUES ( Coaches_Sequence.nextval, 'Keelin', 'Fox', '30 Drogheda St, Balbriggan, Co. Dublin', 'keelinfox@gmail.com', '0862549831', 'Level 2', 3000.00);
INSERT INTO Coaches (coach_id, fname, lname, address, email, tel_no, qualification_level, salary) 
	VALUES ( Coaches_Sequence.nextval, 'William', 'Lacey', '2 Abington Wood, Swords Rd, Malahide, Co. Dublin', 'willlacey@gmail.com', '0868569712', 'Level 2', 3000.00);
INSERT INTO Coaches (coach_id, fname, lname, address, email, tel_no, qualification_level, salary) 
	VALUES ( Coaches_Sequence.nextval, 'Stephen', 'OMahony', '2 Cromcastle Road, Coolock, Co. Dublin', 'stephenomahony@gmail.com', '0862159836', 'Level 3', 1500.00);
INSERT INTO Coaches (coach_id, fname, lname, address, email, tel_no, qualification_level, salary) 
	VALUES ( Coaches_Sequence.nextval, 'Brian', 'MacNamara', '7 St Agnes Road, Crumlin, Dublin 12', 'brianmac@gmail.com', '0862581359', 'Level 3', 1500.00);
INSERT INTO Coaches (coach_id, fname, lname, address, email, tel_no, qualification_level, salary) 
	VALUES ( Coaches_Sequence.nextval, 'Aisling', 'Arnold', '70 Marrowbane Lane, Dublin 8', 'asharnold@gmail.com', '0862459345', 'Level 4', 1000.00);


/* Team_Coaching_Sessions Table */

-- Create sequence to be used for coaching_session_id primary key
CREATE SEQUENCE Tcs_Sequence START WITH 1
INCREMENT BY 1
minvalue 1
maxvalue 10000000;

INSERT INTO Team_Coaching_Sessions (coaching_session_id, coaching_session_datetime, id_team, id_coach) 
	VALUES ( Tcs_Sequence.nextval, to_timestamp('2014-03-31 20:00', 'YYYY-MM-DD HH24:MI'), 06, 01);
INSERT INTO Team_Coaching_Sessions (coaching_session_id, coaching_session_datetime, id_team, id_coach) 
	VALUES ( Tcs_Sequence.nextval, to_timestamp('2014-03-31 20:00', 'YYYY-MM-DD HH24:MI'), 07, 02);
INSERT INTO Team_Coaching_Sessions (coaching_session_id, coaching_session_datetime, id_team, id_coach) 
	VALUES ( Tcs_Sequence.nextval, to_timestamp('2014-04-02 20:00', 'YYYY-MM-DD HH24:MI'), 08, 03);
INSERT INTO Team_Coaching_Sessions (coaching_session_id, coaching_session_datetime, id_team, id_coach) 
	VALUES ( Tcs_Sequence.nextval, to_timestamp('2014-04-03 20:00', 'YYYY-MM-DD HH24:MI'), 09, 04);
INSERT INTO Team_Coaching_Sessions (coaching_session_id, coaching_session_datetime, id_team, id_coach) 
	VALUES ( Tcs_Sequence.nextval, to_timestamp('2014-04-05 18:00', 'YYYY-MM-DD HH24:MI'), 06, 02);
INSERT INTO Team_Coaching_Sessions (coaching_session_id, coaching_session_datetime, id_team, id_coach) 
	VALUES ( Tcs_Sequence.nextval, to_timestamp('2014-04-06 20:00', 'YYYY-MM-DD HH24:MI'), 07, 06);
INSERT INTO Team_Coaching_Sessions (coaching_session_id, coaching_session_datetime, id_team, id_coach) 
	VALUES ( Tcs_Sequence.nextval, to_timestamp('2014-04-07 18:00', 'YYYY-MM-DD HH24:MI'), 06, 08);
INSERT INTO Team_Coaching_Sessions (coaching_session_id, coaching_session_datetime, id_team, id_coach) 
	VALUES ( Tcs_Sequence.nextval, to_timestamp('2014-04-08 20:00', 'YYYY-MM-DD HH24:MI'), 09, 07);
INSERT INTO Team_Coaching_Sessions (coaching_session_id, coaching_session_datetime, id_team, id_coach) 
	VALUES ( Tcs_Sequence.nextval, to_timestamp('2014-04-09 20:00', 'YYYY-MM-DD HH24:MI'), 06, 01);
INSERT INTO Team_Coaching_Sessions (coaching_session_id, coaching_session_datetime, id_team, id_coach) 
	VALUES ( Tcs_Sequence.nextval, to_timestamp('2014-04-10 18:00', 'YYYY-MM-DD HH24:MI'), 08, 05);
INSERT INTO Team_Coaching_Sessions (coaching_session_id, coaching_session_datetime, id_team, id_coach) 
	VALUES ( Tcs_Sequence.nextval, to_timestamp('2014-04-11 18:00', 'YYYY-MM-DD HH24:MI'), 07, 04);
INSERT INTO Team_Coaching_Sessions (coaching_session_id, coaching_session_datetime, id_team, id_coach) 
	VALUES ( Tcs_Sequence.nextval, to_timestamp('2014-04-12 20:00', 'YYYY-MM-DD HH24:MI'), 06, 07);


/* Courts Table */

INSERT INTO Courts (court_no)
	VALUES (01);
INSERT INTO Courts (court_no)
	VALUES (02);


/* Court_Sessions_Table */

/* 
This table stores each 2 hour booking slot, for each day in a week, for each of the 2 courts
owned by the club. For the purposes of this first phase of the implementation of the database
a 1 week period is input into the database. The next phase would be to implement a trigger that
would add a new week of court sessions to the Court_Sessions Table on a weekly basis. This is as
per the business rule that members may not book court sessions further than 1 week in advance
*/

-- Create sequence to be used for court_session_id primary key
CREATE SEQUENCE Court_Sessions_Sequence START WITH 1
INCREMENT BY 1
minvalue 1
maxvalue 10000000;

/* Day 1 */
INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-03-31 10:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-03-31 12:00', 'YYYY-MM-DD HH24:MI'), 'Y', 01);
INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-03-31 10:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-03-31 12:00', 'YYYY-MM-DD HH24:MI'), 'Y', 02);

INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-03-31 12:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-03-31 14:00', 'YYYY-MM-DD HH24:MI'), 'Y', 01);
INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-03-31 12:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-03-31 14:00', 'YYYY-MM-DD HH24:MI'), 'Y', 02);

INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-03-31 14:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-03-31 16:00', 'YYYY-MM-DD HH24:MI'), 'Y', 01);
INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-03-31 14:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-03-31 16:00', 'YYYY-MM-DD HH24:MI'), 'Y', 02);

INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-03-31 16:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-03-31 18:00', 'YYYY-MM-DD HH24:MI'), 'Y', 01);
INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-03-31 16:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-03-31 18:00', 'YYYY-MM-DD HH24:MI'), 'N', 02);

INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-03-31 18:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-03-31 20:00', 'YYYY-MM-DD HH24:MI'), 'N', 01);
INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-03-31 18:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-03-31 20:00', 'YYYY-MM-DD HH24:MI'), 'N', 02);

INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-03-31 20:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-03-31 22:00', 'YYYY-MM-DD HH24:MI'), 'Y', 01);
INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-03-31 20:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-03-31 22:00', 'YYYY-MM-DD HH24:MI'), 'Y', 02);

/* Day 2 */
INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-04-01 10:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-01 12:00', 'YYYY-MM-DD HH24:MI'), 'Y', 01);
INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-04-01 10:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-01 12:00', 'YYYY-MM-DD HH24:MI'), 'N', 02);

INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-04-01 12:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-01 14:00', 'YYYY-MM-DD HH24:MI'), 'N', 01);
INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-04-01 12:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-01 14:00', 'YYYY-MM-DD HH24:MI'), 'N', 02);

INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-04-01 14:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-01 16:00', 'YYYY-MM-DD HH24:MI'), 'Y', 01);
INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-04-01 14:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-01 16:00', 'YYYY-MM-DD HH24:MI'), 'Y', 02);

INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-04-01 16:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-01 18:00', 'YYYY-MM-DD HH24:MI'), 'Y', 01);
INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-04-01 16:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-01 18:00', 'YYYY-MM-DD HH24:MI'), 'Y', 02);

INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-04-01 18:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-01 20:00', 'YYYY-MM-DD HH24:MI'), 'Y', 01);
INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-04-01 18:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-01 20:00', 'YYYY-MM-DD HH24:MI'), 'Y', 02);

INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-04-01 20:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-01 22:00', 'YYYY-MM-DD HH24:MI'), 'Y', 01);
INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-04-01 20:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-01 22:00', 'YYYY-MM-DD HH24:MI'), 'Y', 02);

/* Day 3 */
INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-04-02 10:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-02 12:00', 'YYYY-MM-DD HH24:MI'), 'Y', 01);
INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-04-02 10:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-02 12:00', 'YYYY-MM-DD HH24:MI'), 'Y', 02);

INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-04-02 12:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-02 14:00', 'YYYY-MM-DD HH24:MI'), 'Y', 01);
INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-04-02 12:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-02 14:00', 'YYYY-MM-DD HH24:MI'), 'Y', 02);

INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-04-02 14:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-02 16:00', 'YYYY-MM-DD HH24:MI'), 'Y', 01);
INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-04-02 14:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-02 16:00', 'YYYY-MM-DD HH24:MI'), 'N', 02);

INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-04-02 16:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-02 18:00', 'YYYY-MM-DD HH24:MI'), 'N', 01);
INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-04-02 16:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-02 18:00', 'YYYY-MM-DD HH24:MI'), 'N', 02);

INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-04-02 18:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-02 20:00', 'YYYY-MM-DD HH24:MI'), 'Y', 01);
INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-04-02 18:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-02 20:00', 'YYYY-MM-DD HH24:MI'), 'Y', 02);

INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-04-02 20:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-02 22:00', 'YYYY-MM-DD HH24:MI'), 'Y', 01);
INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-04-02 20:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-02 22:00', 'YYYY-MM-DD HH24:MI'), 'Y', 02);

/* Day 4 */
INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-04-03 10:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-03 12:00', 'YYYY-MM-DD HH24:MI'), 'Y', 01);
INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-04-03 10:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-03 12:00', 'YYYY-MM-DD HH24:MI'), 'Y', 02);

INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-04-03 12:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-03 14:00', 'YYYY-MM-DD HH24:MI'), 'Y', 01);
INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-04-03 12:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-03 14:00', 'YYYY-MM-DD HH24:MI'), 'Y', 02);

INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-04-03 14:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-03 16:00', 'YYYY-MM-DD HH24:MI'), 'Y', 01);
INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-04-03 14:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-03 16:00', 'YYYY-MM-DD HH24:MI'), 'Y', 02);

INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-04-03 16:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-03 18:00', 'YYYY-MM-DD HH24:MI'), 'Y', 01);
INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-04-03 16:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-03 18:00', 'YYYY-MM-DD HH24:MI'), 'Y', 02);

INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-04-03 18:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-03 20:00', 'YYYY-MM-DD HH24:MI'), 'Y', 01);
INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-04-03 18:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-03 20:00', 'YYYY-MM-DD HH24:MI'), 'N', 02);

INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-04-03 20:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-03 22:00', 'YYYY-MM-DD HH24:MI'), 'N', 01);
INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-04-03 20:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-03 22:00', 'YYYY-MM-DD HH24:MI'), 'N', 02);

/* Day 5 */
INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-04-04 10:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-04 12:00', 'YYYY-MM-DD HH24:MI'), 'Y', 01);
INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-04-04 10:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-04 12:00', 'YYYY-MM-DD HH24:MI'), 'Y', 02);

INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-04-04 12:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-04 14:00', 'YYYY-MM-DD HH24:MI'), 'Y', 01);
INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-04-04 12:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-04 14:00', 'YYYY-MM-DD HH24:MI'), 'N', 02);

INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-04-04 14:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-04 16:00', 'YYYY-MM-DD HH24:MI'), 'N', 01);
INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-04-04 14:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-04 16:00', 'YYYY-MM-DD HH24:MI'), 'N', 02);

INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-04-04 16:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-04 18:00', 'YYYY-MM-DD HH24:MI'), 'Y', 01);
INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-04-04 16:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-04 18:00', 'YYYY-MM-DD HH24:MI'), 'Y', 02);

INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-04-04 18:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-04 20:00', 'YYYY-MM-DD HH24:MI'), 'Y', 01);
INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-04-04 18:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-04 20:00', 'YYYY-MM-DD HH24:MI'), 'Y', 02);

INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-04-04 20:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-04 22:00', 'YYYY-MM-DD HH24:MI'), 'Y', 01);
INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-04-04 20:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-04 22:00', 'YYYY-MM-DD HH24:MI'), 'Y', 02);

/* Day 6 */
INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-04-05 10:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-05 12:00', 'YYYY-MM-DD HH24:MI'), 'Y', 01);
INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-04-05 10:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-05 12:00', 'YYYY-MM-DD HH24:MI'), 'Y', 02);

INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-04-05 12:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-05 14:00', 'YYYY-MM-DD HH24:MI'), 'Y', 01);
INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-04-05 12:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-05 14:00', 'YYYY-MM-DD HH24:MI'), 'Y', 02);

INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-04-05 14:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-05 16:00', 'YYYY-MM-DD HH24:MI'), 'Y', 01);
INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-04-05 14:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-05 16:00', 'YYYY-MM-DD HH24:MI'), 'Y', 02);

INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-04-05 16:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-05 18:00', 'YYYY-MM-DD HH24:MI'), 'Y', 01);
INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (68, to_timestamp('2014-04-05 16:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-05 18:00', 'YYYY-MM-DD HH24:MI'), 'Y', 02);

INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-04-05 18:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-05 20:00', 'YYYY-MM-DD HH24:MI'), 'N', 01);
INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-04-05 18:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-05 20:00', 'YYYY-MM-DD HH24:MI'), 'N', 02);

INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-04-05 20:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-05 22:00', 'YYYY-MM-DD HH24:MI'), 'N', 01);
INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-04-05 20:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-05 22:00', 'YYYY-MM-DD HH24:MI'), 'Y', 02);

/* Day 7 */
INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-04-06 10:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-06 12:00', 'YYYY-MM-DD HH24:MI'), 'Y', 01);
INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-04-06 10:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-06 12:00', 'YYYY-MM-DD HH24:MI'), 'Y', 02);

INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-04-06 12:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-06 14:00', 'YYYY-MM-DD HH24:MI'), 'Y', 01);
INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-04-06 12:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-06 14:00', 'YYYY-MM-DD HH24:MI'), 'Y', 02);

INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-04-06 14:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-06 16:00', 'YYYY-MM-DD HH24:MI'), 'Y', 01);
INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-04-06 14:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-06 16:00', 'YYYY-MM-DD HH24:MI'), 'N', 02);

INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-04-06 16:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-06 18:00', 'YYYY-MM-DD HH24:MI'), 'N', 01);
INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-04-06 16:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-06 18:00', 'YYYY-MM-DD HH24:MI'), 'N', 02);

INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-04-06 18:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-06 20:00', 'YYYY-MM-DD HH24:MI'), 'Y', 01);
INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-04-06 18:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-06 20:00', 'YYYY-MM-DD HH24:MI'), 'Y', 02);

INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-04-06 20:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-06 22:00', 'YYYY-MM-DD HH24:MI'), 'Y', 01);
INSERT INTO Court_Sessions (court_session_id, court_session_start_datetime, court_session_end_datetime, court_session_available_yn, no_court)
	VALUES (Court_Sessions_Sequence.nextval, to_timestamp('2014-04-06 20:00', 'YYYY-MM-DD HH24:MI'), to_timestamp('2014-04-06 22:00', 'YYYY-MM-DD HH24:MI'), 'Y', 02);


/* Court_Bookings Table */
/*
As for phase 1 in the implementation of the database, a one week period of court sessions has been
input, the court bookings table will be limited to sessions available within that same 1 week period
*/

-- Create sequence to be used for court_booking_id primary key
CREATE SEQUENCE Court_Bookings_Sequence START WITH 1
INCREMENT BY 1
minvalue 1
maxvalue 10000000;

/* Day 1 */
INSERT INTO Court_Bookings (court_booking_id, id_court_session, no_membership)
	VALUES (Court_Bookings_Sequence.nextval, 08, 01);
INSERT INTO Court_Bookings (court_booking_id, id_court_session, no_membership)
	VALUES (Court_Bookings_Sequence.nextval, 09, 04);
INSERT INTO Court_Bookings (court_booking_id, id_court_session, no_membership)
	VALUES (Court_Bookings_Sequence.nextval, 10, 14);

/* Day 2 */
INSERT INTO Court_Bookings (court_booking_id, id_court_session, no_membership)
	VALUES (Court_Bookings_Sequence.nextval, 14, 09);
INSERT INTO Court_Bookings (court_booking_id, id_court_session, no_membership)
	VALUES (Court_Bookings_Sequence.nextval, 15, 11);
INSERT INTO Court_Bookings (court_booking_id, id_court_session, no_membership)
	VALUES (Court_Bookings_Sequence.nextval, 16, 21);

/* Day 3 */
INSERT INTO Court_Bookings (court_booking_id, id_court_session, no_membership)
	VALUES (Court_Bookings_Sequence.nextval, 30, 14);
INSERT INTO Court_Bookings (court_booking_id, id_court_session, no_membership)
	VALUES (Court_Bookings_Sequence.nextval, 31, 06);
INSERT INTO Court_Bookings (court_booking_id, id_court_session, no_membership)
	VALUES (Court_Bookings_Sequence.nextval, 32, 11);

/* Day 4 */
INSERT INTO Court_Bookings (court_booking_id, id_court_session, no_membership)
	VALUES (Court_Bookings_Sequence.nextval, 46, 13);
INSERT INTO Court_Bookings (court_booking_id, id_court_session, no_membership)
	VALUES (Court_Bookings_Sequence.nextval, 47, 22);
INSERT INTO Court_Bookings (court_booking_id, id_court_session, no_membership)
	VALUES (Court_Bookings_Sequence.nextval, 48, 21);

/* Day 5 */
INSERT INTO Court_Bookings (court_booking_id, id_court_session, no_membership)
	VALUES (Court_Bookings_Sequence.nextval, 52, 03);
INSERT INTO Court_Bookings (court_booking_id, id_court_session, no_membership)
	VALUES (Court_Bookings_Sequence.nextval, 53, 08);
INSERT INTO Court_Bookings (court_booking_id, id_court_session, no_membership)
	VALUES (Court_Bookings_Sequence.nextval, 54, 11);

/* Day 6 */
INSERT INTO Court_Bookings (court_booking_id, id_court_session, no_membership)
	VALUES (Court_Bookings_Sequence.nextval, 69, 14);
INSERT INTO Court_Bookings (court_booking_id, id_court_session, no_membership)
	VALUES (Court_Bookings_Sequence.nextval, 70, 19);
INSERT INTO Court_Bookings (court_booking_id, id_court_session, no_membership)
	VALUES (Court_Bookings_Sequence.nextval, 71, 17);

/* Day 7 */
INSERT INTO Court_Bookings (court_booking_id, id_court_session, no_membership)
	VALUES (Court_Bookings_Sequence.nextval, 78, 14);
INSERT INTO Court_Bookings (court_booking_id, id_court_session, no_membership)
	VALUES (Court_Bookings_Sequence.nextval, 79, 19);
INSERT INTO Court_Bookings (court_booking_id, id_court_session, no_membership)
	VALUES (Court_Bookings_Sequence.nextval, 80, 17);


------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------

/* Q2. 4 Inner Join Queries

General Note:
Views are used throughout queries created in database to improve security - views can 
be made accessible to users while the underlying tables are not directly accessible, 
and for simplicity - views can be used to hide and reuse complex queries.
In accordance with best practice views are removed after they have been used.
Aliases are used throughout queries created in database in order to improve legibility
and to shorten the length of queries. 
*/

/*
Query 1 - Inner Join Query using Team_Players Junction table between Members 
Table and Teams Table to allow the club to display all teams and their players 
for 2014 season
*/
CREATE OR REPLACE VIEW vw_TeamsList AS
SELECT team_name, fname, lname 
FROM Team_Players tp
JOIN Members m ON tp.no_membership = m.membership_no
JOIN Teams t ON tp.id_team = t.team_id
WHERE t.team_start_year = 2014
ORDER BY t.team_name;

/* Select statement run on view */
SELECT * FROM vw_TeamsList;

------------------------------------------------------------------------------------------------

/*
Query 2 - Inner Join Query to display names of all members who have paid their 
subscription for 2014 and what date they paid on
*/
CREATE OR REPLACE VIEW vw_Paid_Members_2014 AS
SELECT fname, lname, date_paid
FROM Members m JOIN Annual_Member_Payments amp 
ON m.membership_no = amp.no_membership
WHERE amp.membership_year = 2014
ORDER BY amp.date_paid ASC;

/* Select statement run on view */
SELECT * FROM vw_Paid_Members_2014;

------------------------------------------------------------------------------------------------

/*
Query 3 - Inner Join Query to display names of all members who are using a 
locker along with their locker number and its location
*/
CREATE OR REPLACE VIEW vw_Member_Lockers AS
SELECT locker_no, changing_room, fname, lname
FROM Members m JOIN Lockers l 
ON m.membership_no = l.no_membership
ORDER BY l.locker_no;

/* Select statement run on view */
SELECT * FROM vw_Member_Lockers;

------------------------------------------------------------------------------------------------

/*
Query 4 - Inner Join Query to display the membership type assigned
to each member along with the name and address of each member displayed
by membership type, with member surnames in alphabetical order 
*/
CREATE OR REPLACE VIEW vw_Member_Types AS
SELECT membership_description, fname, lname, address
FROM Membership_Types mt JOIN Members m 
ON mt.membership_type_code = m.code_membership_type
ORDER BY mt.membership_type_code, m.lname ASC;

/* Select statement run on view */
SELECT * FROM vw_Member_Types;

------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------

/*
Q3. 6 Outer Join Queries

Query 1 - Left Outer Join Query to display all bookable court sessions
along with court bookings which will show which session slots have not been
booked in a given week period
*/
CREATE OR REPLACE VIEW vw_Booked_Court_Sessions AS
SELECT court_session_start_datetime, court_session_end_datetime, 
	no_court, no_membership
FROM Court_Sessions cs LEFT OUTER JOIN Court_Bookings cb 
ON cs.court_session_id = cb.id_court_session
WHERE court_session_start_datetime BETWEEN to_timestamp('2014-03-31 10:00', 'YYYY-MM-DD HH24:MI')
	AND to_timestamp('2014-04-06 20:00', 'YYYY-MM-DD HH24:MI')
ORDER BY cs.court_session_id;

/* Select statement run on view */
SELECT * FROM vw_Booked_Court_Sessions;

------------------------------------------------------------------------------------------------

/*
Query 2 - Left Outer Join to display all members and annual member payments for
2014 which will include any members who have not yet paid their annual subscription
*/
CREATE OR REPLACE VIEW vw_Members_Status_2014 AS
SELECT fname, lname, date_paid
FROM Members m LEFT OUTER JOIN Annual_Member_Payments amp 
ON m.membership_no = amp.no_membership AND amp.membership_year = 2014
ORDER BY amp.date_paid ASC;

/* Select statement run on view */
SELECT * FROM vw_Members_Status_2014;

------------------------------------------------------------------------------------------------

/* 
Query 3 - Right Outer Join to display list of members and their associated
membership type which will show any membership types that have not been 
assigned to any members
*/
CREATE OR REPLACE VIEW vw_All_Member_Types AS
SELECT fname, lname, membership_description
FROM Members m RIGHT OUTER JOIN Membership_Types mt 
ON m.code_membership_type = mt.membership_type_code
ORDER BY mt.membership_type_code;

/* Select statement run on view */
SELECT * FROM vw_All_Member_Types;

------------------------------------------------------------------------------------------------

/*
Query 4 - Right Outer Join to display court bookings and members
for a given 1 week period that will show all members including those
who have not made any court bookings
*/
CREATE OR REPLACE VIEW vw_Member_Bookings AS
SELECT court_session_start_datetime, fname, lname
FROM Court_Bookings cb 
JOIN Court_Sessions cs ON cs.court_session_id = cb.id_court_session AND 
	court_session_start_datetime BETWEEN to_timestamp('2014-03-31 10:00', 'YYYY-MM-DD HH24:MI')
		AND to_timestamp('2014-04-06 20:00', 'YYYY-MM-DD HH24:MI')
RIGHT OUTER JOIN Members m ON cb.no_membership = m.membership_no
ORDER BY m.membership_no;

/* Select statement run on view */
SELECT * FROM vw_Member_Bookings;

------------------------------------------------------------------------------------------------

/* 
Query 5 - Full Outer Join to display all members and lockers that will show 
any members who do not have a locker assigned to them and also any lockers that 
have yet to be assigned to members
*/
CREATE OR REPLACE VIEW vw_All_Members_Lockers AS
SELECT locker_no, changing_room, fname, lname
FROM Members m FULL OUTER JOIN Lockers l 
ON m.membership_no = l.no_membership
ORDER BY l.locker_no;

/* Select statement run on view */
SELECT * FROM vw_All_Members_Lockers;

------------------------------------------------------------------------------------------------

/*
Query 6 - Full Outer Join to display Team Coaching Sessions along with all 2014 teams and 
all coaches which will include any teams who have not been involved in any coaching sessions 
and any coaches who have not taken any coaching sessions.
This is achieved by carrying out a full outer join between the teams table and the team 
coaching sessions table, and the coaches table and the team coaching sessions table, adding
the specified time period to the JOIN ON condition for both full outer joins
*/
CREATE OR REPLACE VIEW vw_Teams_Coaches AS
SELECT team_name, lname, fname, coaching_session_datetime
FROM Team_Coaching_Sessions tcs 
FULL OUTER JOIN Teams t ON t.team_id = tcs.id_team AND 
	tcs.coaching_session_datetime BETWEEN to_timestamp('2014-03-31 20:00', 'YYYY-MM-DD HH24:MI')
		AND to_timestamp('2014-04-12 20:00', 'YYYY-MM-DD HH24:MI')
FULL OUTER JOIN Coaches c ON c.coach_id = tcs.id_coach AND
	tcs.coaching_session_datetime BETWEEN to_timestamp('2014-03-31 20:00', 'YYYY-MM-DD HH24:MI')
		AND to_timestamp('2014-04-12 20:00', 'YYYY-MM-DD HH24:MI')
ORDER BY t.team_name, c.lname;

/* Select statement run on view */
SELECT * FROM vw_Teams_Coaches;

------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------

/*
Q4. 1 CUBE Query 

Cube query used to summarise number of coaches employed at each qualification level and salaries
paid out for each qualification level
*/

CREATE OR REPLACE VIEW vw_Coach_Salary_Summary AS
SELECT qualification_level, count(qualification_level) AS no_of_coaches, 
	SUM (salary) AS total_salaries
FROM Coaches
GROUP BY CUBE (qualification_level);


/* Select statement run on view */
SELECT * FROM vw_Coach_Salary_Summary;

------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------

/*
Q5. 5 Sub-Queries

Sub-Query 1 - Sub-Query used in query to display members who are playing on 2 teams in 2014. 
A sub-query is used to select member names (first name and surname are piped together), team 
years and to count how many times each membership number appears in the team_players junction table.
The team_players junction table and members table are then joined where membership numbers
match and the junction table and teams table are joined where team ids match, and the team
year is 2014. The outer query then displays results from the sub-query where the total teams
count is greater than or equal to two
*/

CREATE OR REPLACE VIEW vw_Dual_Players AS
SELECT player_name, year, total_teams
FROM
(SELECT m.fname||' '||m.lname AS player_name, t.team_start_year AS year, 
	COUNT(tp.no_membership) AS total_teams 
	FROM Team_Players tp
	JOIN Members m ON tp.no_membership = m.membership_no 
	JOIN Teams t ON tp.id_team = t.team_id AND t.team_start_year = 2014
	GROUP BY m.fname, m.lname, t.team_start_year
	ORDER BY m.lname
)
WHERE total_teams >= 2;

/* Select statement run on view */
SELECT * FROM vw_Dual_Players;

--------------------------------------------------------------------------------------------------

/*
Sub-Query 2 - Sub-Query used in query to display Coaches who have run at least 2 
coaching sessions in a 2 week period. A sub-query is used to select 
coach names (first name and surname are piped together) and to count
how many times each coach id is present within the coaching sessions table.
The coaches table and coaching sessions tables are then joined where coach ids
are matching and between the 2 week period, and the results of the sub-query are
returned in descending order of number of sessions. The outer query then displays
results from the sub-query where the number of sessions is greater than or equal
to 2
*/
CREATE OR REPLACE VIEW vw_Coach_History AS
SELECT Coach_Name, Total_Sessions
FROM 
(SELECT c.fname||' '||c.lname AS Coach_Name, COUNT(tcs.id_coach) AS Total_Sessions 
	FROM Team_Coaching_Sessions tcs 
	JOIN Coaches c
	ON tcs.id_coach = c.coach_id AND tcs.coaching_session_datetime 
		BETWEEN to_timestamp('2014-03-31 20:00', 'YYYY-MM-DD HH24:MI')
		AND to_timestamp('2014-04-12 20:00', 'YYYY-MM-DD HH24:MI')
	GROUP BY c.fname, c.lname
	ORDER BY COUNT(tcs.id_coach) DESC
)
WHERE Total_Sessions >= 2;

/* Select statement run on view */
SELECT * FROM vw_Coach_History;

--------------------------------------------------------------------------------------------------

/*
Sub-Query 3 - Sub-Query used in query to display the members(s) who paid their annual
subscription for 2014 earliest. The outer query is used to select member names 
(first name and surname are piped together) and the payment date. The members
table and annual member payments tables are joined on matching membership numbers,
where the date paid is the result of the sub-query. The sub-query then returns 
the earliest date a subscription was paid in 2014.
*/
CREATE OR REPLACE VIEW vw_Prompt_Members AS
SELECT m.fname||' '||m.lname AS member_name, amp.date_paid AS payment_date
FROM Members m 
JOIN Annual_Member_Payments amp
ON m.membership_no = amp.no_membership
WHERE amp.date_paid = (SELECT MIN(date_paid) FROM Annual_Member_Payments 
	WHERE membership_year = 2014)
ORDER BY m.lname;

/* Select statement run on view */
SELECT * FROM vw_Prompt_Members;

--------------------------------------------------------------------------------------------------

/*
Sub-Query 4 - Sub-Query used in query to display the last assigned locker in the Ladies 
Changing Room. The outer query is used to select the locker number and changing room from 
the Lockers table where the locker number is the result of the sub-query. The sub-query 
returns the highest locker number from the lockers table that is located in the ladies 
changing room and that has a not-null value for membership number, i.e. the highest 
locker number that has been assigned a membership number.
*/
CREATE OR REPLACE VIEW vw_Last_Ladies_Locker AS
SELECT l.locker_no AS Last_Assigned_Locker, l.changing_room
FROM Lockers l 
WHERE l.locker_no = (SELECT MAX(locker_no) FROM Lockers
	WHERE changing_room = 'ladies' AND no_membership IS NOT NULL);

/* Select statement run on view */
SELECT * FROM vw_Last_Ladies_Locker;

--------------------------------------------------------------------------------------------------

/*
Sub-Query 5 - Sub-Query used in query to display the highest paid coaches. The outer query
is used to select coach names (first name and surname are piped together) and their salary
from the Coaches table where the salary is the result of the sub-query. The sub-query returns
the highest salary in the coaches table.
*/
CREATE OR REPLACE VIEW vw_Highest_Paid_Coaches AS
SELECT c.fname||' '||c.lname AS Coach_Name, c.salary
FROM Coaches c 
WHERE salary = (SELECT MAX(salary) FROM Coaches)
ORDER BY c.lname;

/* Select statement run on view */
SELECT * FROM vw_Highest_Paid_Coaches;

--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------

/*
Q.6 - 5 PL/SQL Procedures as part of one package
*/

-- Specification
CREATE OR REPLACE PACKAGE club_admin_pkg AS
	-- Define procedure headers with parameters where applicable
	PROCEDURE New_Member_Proc (input_fname IN NVARCHAR2, input_lname IN NVARCHAR2,
		input_address IN NVARCHAR2, input_email IN NVARCHAR2, input_tel_no IN NVARCHAR2,
		input_code_membership_type IN NUMBER);
	PROCEDURE Member_Payment_Proc (input_no IN NUMBER);
	PROCEDURE ShowUnpaidFeesProc;
	PROCEDURE Get_Member_Proc (input_membership_no IN NUMBER);
	PROCEDURE Show_Coach_Level_Proc (input_qual_level IN NVARCHAR2);
END;
/

-- Package Body is location of code of public functions
CREATE OR REPLACE PACKAGE BODY club_admin_pkg AS
	
	-- Procedure 1 - Procedure that takes in relevant data and adds a new member to the database */
	PROCEDURE New_Member_Proc (input_fname IN NVARCHAR2, input_lname IN NVARCHAR2,
		input_address IN NVARCHAR2, input_email IN NVARCHAR2, input_tel_no IN NVARCHAR2,
		input_code_membership_type IN NUMBER)
	IS
		-- Declare variables for each field that will be input into new row
		v_membership_no NUMBER(10);
		v_fname NVARCHAR2(20) := input_fname;
		v_lname NVARCHAR2(20) := input_lname;
		v_address NVARCHAR2(250) := input_address;
		v_email NVARCHAR2(60) := input_email;
		v_tel_no VARCHAR(20) := input_tel_no;
		v_date_joined DATE;
		v_fees_paid_yn CHAR(1);
		v_code_membership_type NUMBER := input_code_membership_type;
	BEGIN
	    -- Create savepoint
	    SAVEPOINT save_members;

	    -- Assign next value from previously created member payments id sequence to v_payment_id
	    SELECT Members_Sequence.nextval INTO v_membership_no FROM DUAL;
	    
	    -- Assign current date into v_date_joined variable
		SELECT to_date (CURRENT_DATE, 'YYYY-MM-DD') INTO v_date_joined FROM dual;

		-- Assign Y into v_fees_paid_yn variable
		SELECT 'Y' INTO v_fees_paid_yn FROM dual;

		-- Insert variable values into a new row in the Members table
		INSERT INTO Members (membership_no, fname, lname, address, email, tel_no, date_joined, fees_paid_yn, code_membership_type) 
		VALUES (v_membership_no, v_fname, v_lname, v_address, v_email, v_tel_no, v_date_joined, v_fees_paid_yn, v_code_membership_type);

	/*
	Create exception to output error message and rollbackl to savepoint if invalid membership 
	number is passed to procedure
	*/
	EXCEPTION
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE('ERROR: Incorrect data entered'); 
			ROLLBACK TO save_members;
	END New_Member_Proc;

	
	/* 
	Procedure 2 Procedure that takes in a member's membership number and adds an annual member 
	payment to the database for that member
	*/
	PROCEDURE Member_Payment_Proc (input_no IN NUMBER)
	IS
		-- Declare variables for each field that will be input into new row
		v_payment_id NUMBER(10);
		v_payment_amount NUMBER(10,2);
		v_membership_year NUMBER(4);
		v_date_paid DATE;
		v_no_membership NUMBER := input_no;
	BEGIN
	    -- Create savepoint
	    SAVEPOINT save_payments;

	    -- Assign next value from previously created member payments id sequence to v_payment_id
	    SELECT Amp_Sequence.nextval INTO v_payment_id FROM DUAL;
	    
	    /* Insert relevant payment amount for the current member depending on their membership 
	    type if no payment amount is entered using a join between membership types and 
	    members tables to access the appropriate amount  */
	    SELECT mt.annual_subscription_amount INTO v_payment_amount
	    FROM Membership_Types mt
	    	JOIN Members m
	        	ON mt.membership_type_code = m.code_membership_type
	    WHERE v_no_membership = m.membership_no;  

	    -- Assign current year into v_membership_year variable
	    SELECT to_number (EXTRACT(YEAR FROM sysdate)) INTO v_membership_year FROM dual;

	    -- Assign current date into v_date_paid variable
		SELECT to_date (CURRENT_DATE, 'YYYY-MM-DD') INTO v_date_paid FROM dual;

		-- Insert variable values into a new row in the Annual Member Payments table
		INSERT INTO Annual_Member_Payments (payment_id, payment_amount, membership_year, date_paid, no_membership) 
		VALUES (v_payment_id, v_payment_amount, v_membership_year, v_date_paid, v_no_membership);

	/* 
	Create exception to output error message if invalid membership number is passed to procedure
	and rollback to savepoint before insert of data
	*/
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			DBMS_OUTPUT.PUT_LINE('ERROR: The membership number entered is not valid'); 
			ROLLBACK TO save_payments;
	END Member_Payment_Proc;


	-- Procedure 3 - Procedure to display members who have not yet paid their fees for the current year
	PROCEDURE ShowUnpaidFeesProc
	IS
		-- Declare cursor
		CURSOR cur_members IS SELECT membership_no, fname, lname, fees_paid_yn FROM Members;
		-- Declare variables to store result from query of cursor, and current year
		v_member_row cur_members%ROWTYPE;
		v_membership_year NUMBER(4);

	BEGIN
		-- Assign current year into v_membership_year variable
	    SELECT to_number (EXTRACT(YEAR FROM sysdate)) INTO v_membership_year FROM dual;

		OPEN cur_members;
		FETCH cur_members INTO v_member_row;
		WHILE cur_members%FOUND LOOP
		-- Only display members who have not paid
		IF v_member_row.fees_paid_yn = 'N' THEN
		DBMS_OUTPUT.PUT_LINE(v_member_row.fname||' '||v_member_row.lname||' has not yet paid annual subscription for '||v_membership_year);
		END IF;
		-- Check next row
		FETCH cur_members INTO v_member_row;
		-- End loop when all rows have been checked
		END LOOP;
		-- Close cursor
		CLOSE cur_members;
	
	EXCEPTION
		WHEN OTHERS THEN
			RAISE_APPLICATION_ERROR(-20001, 'An error ocurred - '||SQLCODE||' -ERROR- '||SQLERRM);
	END ShowUnpaidFeesProc;


	-- Procedure 4 - Procedure that takes in member's membership number and returns member's details
	PROCEDURE Get_Member_Proc (input_membership_no IN NUMBER)
	IS

		-- Declare variables for each field that will be displayed
		v_membership_no NUMBER := input_membership_no;
		v_fname NVARCHAR2(20);
		v_lname NVARCHAR2(20);
		v_address NVARCHAR2(250);
		v_email NVARCHAR2(60);
		v_tel_no VARCHAR(20);
		v_date_joined DATE;
		v_fees_paid_yn CHAR(1);

	BEGIN
		-- Select fields from memebrs table and assign to variab;es
		SELECT m.fname INTO v_fname FROM Members m WHERE m.membership_no = v_membership_no;
		SELECT m.lname INTO v_lname FROM Members m WHERE m.membership_no = v_membership_no;
		SELECT m.address INTO v_address FROM Members m WHERE m.membership_no = v_membership_no;
		SELECT m.email INTO v_email FROM Members m WHERE m.membership_no = v_membership_no;
		SELECT m.tel_no INTO v_tel_no FROM Members m WHERE m.membership_no = v_membership_no;
		SELECT m.date_joined INTO v_date_joined FROM Members m WHERE m.membership_no = v_membership_no;
		SELECT m.fees_paid_yn INTO v_fees_paid_yn FROM Members m WHERE m.membership_no = v_membership_no;
		
		-- Display details for member
		DBMS_OUTPUT.PUT_LINE('Membership No: ' || v_membership_no);
		DBMS_OUTPUT.PUT_LINE('Name: ' || v_fname || ' ' || v_lname);
		DBMS_OUTPUT.PUT_LINE('Address: ' || v_address);
		DBMS_OUTPUT.PUT_LINE('Email: ' || v_email);
		DBMS_OUTPUT.PUT_LINE('Telephone: ' || v_tel_no);
		DBMS_OUTPUT.PUT_LINE('Date Joined: ' || v_date_joined);
		DBMS_OUTPUT.PUT_LINE('Fees Paid: ' || v_fees_paid_yn);

	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			DBMS_OUTPUT.PUT_LINE('ERROR MESSAGE: This membership number does not exist.');
			
	END Get_Member_Proc;


	/*
	Procedure 5 - Procedure that takes in a coaching qualification and returns name, telephone
	number and email address for all of the coaches employed who are in possession of that 
	qualification level
	*/
	PROCEDURE Show_Coach_Level_Proc (input_qual_level IN NVARCHAR2)
	IS
		-- Declare cursor
		CURSOR cur_coaches IS SELECT fname, lname, email, tel_no, qualification_level FROM Coaches;
		-- Declare variables to store result from query of cursor, and inputted qualification level
		v_coaches_row cur_coaches%ROWTYPE;
		v_qual_level NVARCHAR2(20) := input_qual_level;
	BEGIN
		OPEN cur_coaches;
		FETCH cur_coaches INTO v_coaches_row;
		WHILE cur_coaches%FOUND LOOP
		-- Only display coaches with inputted qualification level
		IF v_coaches_row.qualification_level = v_qual_level THEN
		DBMS_OUTPUT.PUT_LINE(v_qual_level || '. Name: ' || v_coaches_row.fname || ' ' || v_coaches_row.lname 
			|| '. Email: ' || v_coaches_row.email || '. Tel: ' || v_coaches_row.tel_no);
		END IF;
		-- Check next row
		FETCH cur_coaches INTO v_coaches_row;
		-- End loop when all rows have been checked
		END LOOP;
		-- Close cursor
		CLOSE cur_coaches;

	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			DBMS_OUTPUT.PUT_LINE('ERROR MESSAGE: Qualification level entered incorrectly.');
			DBMS_OUTPUT.PUT_LINE('Please enter as per this format: "Level 3"');
			DBMS_OUTPUT.PUT_LINE('The possible coaching levels are Level 2, Level 3, Level 4 and Level 5.');
	END Show_Coach_Level_Proc;


	-- Package Initialisation Message
	BEGIN
		DBMS_OUTPUT.PUT_LINE('Initialising package...');
	END;
	/


---------------------------------------------------------------------------------------------------------

-- Test procedures in package

---------------------------------------------------------------------------------------------------------
-- Test Procedure 1 - Add new member
-- Select Statement to return all member payments for 2014 before procedure is called
SELECT * FROM Members;

/* Call Procedure with valid membership number */
BEGIN
	club_admin_pkg.New_Member_Proc('Chris', 'Brownill', '7 The Oaks, Clonskeagh, Dublin 16', 'chrisbrownill@gmail.com',
		0864783215, 01);
END;
/

-- Use Select Statement to return all member payments for 2014 after procedure is called
SELECT * FROM Members;
---------------------------------------------------------------------------------------------------------

-- Test Proecdure 2 - Add a member payment
-- Call Procedure with invalid data number to test exception handling */
BEGIN
	club_admin_pkg.Member_Payment_Proc(47);
END;
/

-- Select Statement to return all member payments for 2014 before procedure is called
SELECT * FROM Annual_Member_Payments WHERE membership_year = 2014;

/* Call Procedure with valid membership number */
BEGIN
	club_admin_pkg.Member_Payment_Proc(21);
END;
/

-- Select Statement to return all member payments for 2014 after procedure is called
SELECT * FROM Annual_Member_Payments WHERE membership_year = 2014;

-- Restore database to previous state
DELETE FROM Annual_Member_Payments WHERE no_membership = 21 AND membership_year = 2014;
---------------------------------------------------------------------------------------------------------

-- Test Procedure 3 - FInd members with unpaid fees
/* Call Procedure */
BEGIN
	club_admin_pkg.ShowUnpaidFeesProc();
END;
/

--------------------------------------------------------------------------------------------

-- Test Procedure 4 - Get member details
/* Call Procedure with valid membership number */
BEGIN
	club_admin_pkg.Get_Member_Proc(5);
END;
/

/* Call Procedure with invalid membership number */
BEGIN
	club_admin_pkg.Get_Member_Proc(87);
END;
/

--------------------------------------------------------------------------------------------

-- Test Procedure 5
/* Call Procedure */
BEGIN
	club_admin_pkg.Show_Coach_Level_Proc('Level 4');
END;
/

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------

/*
Q.7 - 2 PL/SQL Functions

Function 1 - Takes user input of a membership number and returns the number of year
that the member associated with that membership number has been a member
*/
CREATE OR REPLACE FUNCTION LengthOfMembershipFunc (input_id IN NUMBER)
RETURN NUMBER 
IS
/* Declare variables for inputted membership number and total_years */
given_id NUMBER := input_id;
total_years NUMBER := 0;
BEGIN
	/* 
	select years of membership using sub-query to extract years from a subtraction of year 
	the member joined from the system date and store the result in the total_years variable
	for the inputted membership number
	*/
	SELECT (EXTRACT(YEAR FROM sysdate) - EXTRACT(YEAR FROM m.date_joined))
	INTO total_years 
	FROM Members m
	WHERE m.membership_no = given_id;
	DBMS_OUTPUT.PUT_LINE
	/* return result of above query */
	RETURN total_years;

EXCEPTION
	/* error message that will be output if no data is returned */
	WHEN NO_DATA_FOUND THEN
		DBMS_OUTPUT.PUT_LINE('ERROR MESSAGE: Coaching level entered incorrectly. Please enter either Level');

END LengthOfMembershipFunc;
/

/* Call function on valid membership number */
SELECT LengthOfMembershipFunc(06) FROM dual;

/* Call function on invalid membership number */
SELECT LengthOfMembershipFunc(52) FROM dual;

------------------------------------------------------------------------------------------------------

/* Function 2 - Uses COUNT to return the number of members in the badminton club */

CREATE OR REPLACE FUNCTION NoOfMembersFunc
RETURN NUMBER 
IS
/* Declare variable for total_members */
total_members NUMBER := 0;
BEGIN
	/* 
	select number of members using COUNT to count the number of rows with membership
	numbers in the Members table and store the result in the total_members variable
	*/
	SELECT COUNT(m.membership_no)
	INTO total_members 
	FROM Members m;
	RETURN total_members;

EXCEPTION
	/* error message that will be output if error is encountered */
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('ERROR MESSAGE: An error was encountered.');

END NoOfMembersFunc;
/

/* Call function to display number of members */
SELECT NoOfMembersFunc() FROM DUAL;

------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------

/* Q.8 - Triggers

Trigger 1 - Before trigger that fires when a new Annual Member Payment is added and updates the
fees_paid_yn column in the Members table for the corresponding member
*/
CREATE OR REPLACE TRIGGER Update_fees_paid
  BEFORE INSERT ON Annual_Member_Payments
  FOR EACH ROW

DECLARE
	-- Declare variable for membership number
    v_no_membership NUMBER;
BEGIN
	-- store the membership number associated with new member payment in the variable
    v_no_membership  := :NEW.no_membership;

    /*
    update the fees_paid_yn column in the members table of the membership no. stored in the 
    variable to Y 
    */
    UPDATE Members
    SET fees_paid_yn = 'Y'
    WHERE membership_no = v_no_membership;
END;
/

/*
Select statement to return data for member no. 21 from Members table, we see that they have not yet paid
their annual subscription for 2014 (fees_paid_yn column is returning N)
*/
SELECT * FROM Members WHERE membership_no = 21;

-- Add a new Annual Member Payment for membership_no 21 (who has not yet paid their fees)
INSERT INTO Annual_Member_Payments (payment_id, payment_amount, membership_year, date_paid, no_membership) 
	VALUES ( Amp_Sequence.nextval, 500.00, 2014, to_date('2014-02-24', 'YYYY-MM-DD'), 21);

/*
Select statement to return data for member no. 21 from Members table to test if trigger has fired after
the insert of a new row in Annual_Member_Payments for that member and we see that fees_paid_yn column 
has been updated to Y
*/
SELECT * FROM Members WHERE membership_no = 21;

-- Restore database to previous state
DELETE FROM Annual_Member_Payments WHERE payment_id = 46;

---------------------------------------------------------------------------------------------------------------

/*
Trigger 2 - After trigger that fires when a coaches salary is changed and displays the salary differential
from the coaches previous salary to the user
*/
CREATE OR REPLACE TRIGGER Log_Coach_Salary_Changes
	AFTER UPDATE OF salary ON Coaches
	FOR EACH ROW 
DECLARE 
	-- declare variable for salary difference
	salary_diff NUMBER;
BEGIN
	/* 
	variable is assigned the result of the salary before the salary update query minus the 
	salary after the salary update query
	*/
	salary_diff := :NEW.salary - :OLD.salary;
	--Output a summary of previous salary, proposed salary and difference to screen
	DBMS_OUTPUT.PUT_LINE('Salary changed for Coach: ' || :OLD.fname || ' ' || :OLD.lname);
	DBMS_OUTPUT.PUT_LINE('Previous salary: ' || :OLD.salary);
	DBMS_OUTPUT.PUT_LINE('New salary: ' || :NEW.salary);
	DBMS_OUTPUT.PUT_LINE('Salary difference: ' || salary_diff);
END;
/

/* Update salary for a coach to fire trigger */
UPDATE Coaches
SET salary = 1500
WHERE coach_id = 13;

/* Return database to previous state */
UPDATE Coaches
SET salary = 1000
WHERE coach_id = 13;

----------------------------------------------------------------------------------------

/*
Trigger 3 - Before Trigger that informs the user if the year they have entered for a new
annual member payment is incorrect, i.e. not the current year
*/

CREATE OR REPLACE TRIGGER Annual_Payment_Wrong_Year
    BEFORE INSERT ON Annual_Member_Payments
    FOR EACH ROW
DECLARE
	-- Declare variable for current year
	v_current_year NUMBER(4);
BEGIN
    -- Assign current year to variable using sysdate
	SELECT to_number (EXTRACT(YEAR FROM sysdate)) INTO v_current_year FROM DUAL;
    -- Compare year entered with v_current_year
    IF :NEW.membership_year <> v_current_year THEN
    	DBMS_OUTPUT.PUT_LINE('Incorrect Membership Year, the current Membership Year is: ' || v_current_year);
    END IF; 
END;
/

/* 
Test trigger by inserting a new Annual Member Payment for membership_no 22
with incorrect year supplied
*/
INSERT INTO Annual_Member_Payments (payment_id, payment_amount, membership_year, date_paid, no_membership) 
	VALUES ( Amp_Sequence.nextval, 500.00, 2016, to_date('2013-02-21', 'YYYY-MM-DD'), 22);


-- Return database to previous state
DELETE FROM Annual_Member_Payments WHERE membership_year = 2016;

------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------


