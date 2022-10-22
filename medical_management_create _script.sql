--  **************************************************************************************
--  We first check if the database exists, and drop it if it does.
--  Setting the active database to the built in 'master' database ensures that we are not trying to drop the currently active database.
--  Setting the database to 'single user' mode ensures that any other scripts currently using the database will be disconnectetd.
--  This allows the database to be deleted, instead of giving a 'database in use' error when trying to delete it.

IF DB_ID('medical_management') IS NOT NULL             
	BEGIN
		PRINT 'Database exists - dropping.';
		
		USE master;		
		ALTER DATABASE medical_management SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
		
		DROP DATABASE medical_management;
	END

GO

--  Now that we are sure the database does not exist, we create it.

PRINT 'Creating database.';

CREATE DATABASE medical_management;

GO

--  Now that an empty database has been created, we will make it the active one.
--  The table creation statements that follow will therefore be executed on the 
--  newly created database.

USE medical_management;

GO



--  **************************************************************************************
--  We now create the tables in the database.
--  **************************************************************************************



--  **************************************************************************************
--  Create the treatment table to hold information for prescription. 
--  The prescription table has a foreign key referencing this table.
--  A constraint treatment_pk PRYMARY KEY has been created to uniquely
--  indetifies each of the records.
--  IDENTITY has been added to auto-increasing the treatment_id of the table
--  and it has to increment 1 with seed 1.
--  Values on each field must be NOT NULL and have a value.

PRINT 'Creating treatment table...';

CREATE TABLE treatment 
( treatment_id		INT NOT NULL IDENTITY(1,1), 
  type_treatment	VARCHAR(50) NOT NULL, 
  length_treatment	VARCHAR(25) NOT NULL, 
  
  CONSTRAINT tratement_pk PRIMARY KEY (treatment_id),
);


--  **************************************************************************************
--  Create the medicine table to hold medicines information for prescription.
--  The prescription table has a foreign key referencing this table.
--  A constraint medicine_pk PRYMARY KEY has been created to uniquely
--  indetifies each of the records.
--  IDENTITY has been added to auto-increasing the medicine_id of the table.
--  CHECK constraint is used with cost greater or equal to zero to limit the value
--  range to positive numbers.
--  Values on each field must be NOT NULL and have a value.

PRINT 'Creating medicine table...';

CREATE TABLE medicine 
( medicine_id	INT NOT NULL IDENTITY,
  name			VARCHAR(25) NOT NULL, 
  type_medicine	VARCHAR(50) NOT NULL,
  manufacturer	VARCHAR(25) NOT NULL, 
  cost			MONEY NOT NULL, 
  
  CONSTRAINT medicine_pk PRIMARY KEY (medicine_id),
  CONSTRAINT cost_money_min CHECK (cost >= 0),
);

--  **************************************************************************************
--  Create the adminsitrative_staff table to hold the management employee personnel 
--  information for the medical management system.
--  The appoinment table will have a foreign key referencing this table.
--  A constraint administrative_pk PRYMARY KEY has been created to uniquely
--  indetifies each of the records.
--  CHECK constraint is used with gender equal to Male or Female to limit the values
--  UNIQUE constraint is used for email considering that all values in this column
--  have to be different.
--  Values on each field must be NOT NULL and have a value.

PRINT 'Creating administrative_staff table...';

CREATE TABLE administrative_staff
( administrative_id INT NOT NULL,
  first_name		VARCHAR(25) NOT NULL,
  last_name			VARCHAR(25) NOT NULL,
  gender			CHAR(1) NOT NULL,
  email				VARCHAR(25) NOT NULL,
  phone_number		VARCHAR(20) NOT NULL,
  department_id		SMALLINT NOT NULL,
  
  CONSTRAINT administrative_pk PRIMARY KEY (administrative_id),
  CONSTRAINT administrative_gender_char CHECK (gender IN ('M', 'F')),
  CONSTRAINT administrative_email_uk UNIQUE (email)
);




--  **************************************************************************************
--  Create the patient table to hold the patients information for the medical management system.
--  The appoinment table will have a foreign key referencing this table.
--  A constraint patient_pk PRYMARY KEY has been created to uniquely
--  indetifies each of the records.
--  CHECK constraint is used with gender equal to Male or Female to limit the values
--  UNIQUE constraint is used for email considering that all values in this column
--  have to be different.
--  Values on each field must be NOT NULL and have a value.

PRINT 'Creating patient table...';

CREATE TABLE patient
( patient_id						INT NOT NULL,
  first_name						VARCHAR(25) NOT NULL,
  last_name							VARCHAR(25) NOT NULL,
  gender							CHAR(1) NOT NULL,
  age								SMALLINT NOT NULL,
  email								VARCHAR(25) NOT NULL,
  street_address					VARCHAR(50) NOT NULL,
  postal_code						VARCHAR(15) NOT NULL,
  city								VARCHAR(30) NOT NULL,
  state_province					VARCHAR(25) NOT NULL,
  phone_number						VARCHAR(20) NOT NULL,
  emergency_contact_name			VARCHAR(50) NOT NULL,
  emergency_contact_phone_number	VARCHAR(20) NOT NULL,
  
  CONSTRAINT patient_pk PRIMARY KEY (patient_id),
  CONSTRAINT patient_gender_char CHECK (gender IN ('M', 'F')),
  CONSTRAINT patient_email_uk UNIQUE (email)
);



--  **************************************************************************************
--  Create the nurse table to hold the nursery information for the medical management system.
--  The appointment table will have a foreign key referencing this table.
--  A constraint nurse_pk PRYMARY KEY has been created to uniquely
--  indetifies each of the records.
--  CHECK constraint is used with gender equal to Male or Female to limit the values
--  UNIQUE constraint is used for email considering that all values in this column
--  have to be different.
--  Values on each field must be NOT NULL and have a value.

PRINT 'Creating nurse table...';

CREATE TABLE nurse
( nurse_id							INT NOT NULL,
  first_name						VARCHAR(25) NOT NULL,
  last_name							VARCHAR(25) NOT NULL,
  gender							CHAR(1) NOT NULL,
  email                             VARCHAR(25) NOT NULL,
  phone_number						VARCHAR(20) NOT NULL,							
  department_name		            VARCHAR(25) NOT NULL,
   
  
  CONSTRAINT nurse_pk PRIMARY KEY (nurse_id),
  CONSTRAINT nurse_gender_char CHECK (gender IN ('M', 'F')),
  CONSTRAINT nurse_email_uk UNIQUE (email)
);


--  **************************************************************************************
--  Create the doctor table to hold the doctors information for the medical management system.
--  The appointment table will have a foreign key referencing this table.
--  A constraint doctor_pk PRYMARY KEY has been created to uniquely
--  indetifies each of the records.
--  CHECK constraint is used with gender equal to Male or Female to limit the values
--  UNIQUE constraint is used for email considering that all values in this column
--  have to be different.
--  Values on each field must be NOT NULL and have a value.

PRINT 'Creating doctor table...';

CREATE TABLE doctor
( doctor_id						    INT NOT NULL,
  first_name						VARCHAR(25) NOT NULL,
  last_name							VARCHAR(25) NOT NULL,
  gender							CHAR(1) NOT NULL,
  email                             VARCHAR(25) NOT NULL,
  phone_number						VARCHAR(20) NOT NULL,							
  department_name		            VARCHAR(25) NOT NULL,
  specialty                         VARCHAR(25) NOT NULL,
  
  
  CONSTRAINT doctor_pk PRIMARY KEY (doctor_id),
  CONSTRAINT doctor_gender_char CHECK (gender IN ('M', 'F')),
  CONSTRAINT doctor_email_uk UNIQUE (email)
);


--  **************************************************************************************
--  Create the appointment table to hold medical management system information.
--  The prescription table has foreign keys referencing this table.
--  IDENTITY has been added to auto-increasing the appointment_id of the table.
--  A constraint appointment_pk PRYMARY KEY has been created to uniquely
--  indetifies each of the records.
--  This table has a foreign key constraint on doctor_id, referencing the doctor table (doctor_id)
--  This table has a foreign key constraint on nurse_id, referencing the nurse table (nurse_id)
--  This table has a foreign key constraint on patient_id, referencing the patient table (patient_id)
--  This table has a foreign key constraint on administrative_id, referencing the administrative table (administrative_id)
--  Values on each field for id, date, time, patient, doctor, room, reason, must be NOT NULL and have a value
--  and the appoinment can not be created witout those values.
--  Values on each field for nurse, and adminsitrative IDs could be NULL
--  considering a appoinment can be created witout the information of them. 

PRINT 'Creating appointment table...';

CREATE TABLE appointment
( appointment_id				    INT NOT NULL IDENTITY,
  appointment_date                  DATE NOT NULL,      
  appointment_time					TIME (0) NOT NULL,
  appointment_room	                VARCHAR(25) NOT NULL,
  appointment_reason                VARCHAR(250) NOT NULL,  
  doctor_id                         INT NOT NULL,
  patient_id                        INT NOT NULL,
  nurse_id                          INT NULL,
  administrative_id                 INT NULL,
   
  CONSTRAINT appointment_pk PRIMARY KEY (appointment_id),
  CONSTRAINT appointment_doctor_fk  FOREIGN KEY (doctor_id) REFERENCES doctor(doctor_id),
  CONSTRAINT appointment_patient_fk  FOREIGN KEY (patient_id) REFERENCES patient(patient_id),
  CONSTRAINT appointment_nurse_fk  FOREIGN KEY (nurse_id) REFERENCES nurse(nurse_id),
  CONSTRAINT appointment_admnistrative_fk  FOREIGN KEY (administrative_id) REFERENCES administrative_staff(administrative_id),
);



--  **************************************************************************************
--  Create the appointment table to hold medical management system information.
--  The prescription table has foreign keys referencing this table.
--  A constraint prescription_pk PRYMARY KEY has been created to uniquely
--  indetifies each of the records. 
--  IDENTITY has been added to auto-increasing the prescription_id of the table.
--  This table has a foreign key constraint on appointment_id, referencing the appointment table (appointment_id)
--  This table has a foreign key constraint on meidicine_id, referencing the medicine table (meidicine_id)
--  This table has a foreign key constraint on treatment_id, referencing the treatment table (treatment_id)
--  Values on each field must be NOT NULL and have a value.

PRINT 'Creating prescription table...';

CREATE TABLE prescription 
( prescription_id				    INT NOT NULL IDENTITY,
  prescription_date                 DATE NOT NULL,      
  prescription_time					TIME (0) NOT NULL,
  prescription_type	                VARCHAR(10) NOT NULL,
  appointment_id                    INT NOT NULL,
  medicine_id                       INT NOT NULL,
  treatment_id                      INT NOT NULL,
  
  CONSTRAINT prescription_pk PRIMARY KEY (prescription_id),
  CONSTRAINT prescription_appointment_fk  FOREIGN KEY (appointment_id) REFERENCES appointment(appointment_id),
  CONSTRAINT prescription_medicine_fk  FOREIGN KEY (medicine_id) REFERENCES medicine(medicine_id),
  CONSTRAINT prescription_treatment_fk  FOREIGN KEY (treatment_id) REFERENCES treatment(treatment_id),
  
);


--  **************************************************************************************
--  Now that the database tables have been created, we can populate them with data
--  **************************************************************************************



--  **************************************************************************************
--  Populate the treatment table.
--  Since the primary key uses IDENTITY, we don't specify a value for that column.
PRINT 'Populating treatment table...';

INSERT INTO treatment 
VALUES	('Cognitive-behavioral therapy','28 days'),
		('Dialectical behavior therapy','10 days'),
		('Eye movement desensitization','2 months'),
		('Exposure therapy','1 year'),
		('Interpersonal therapy','2 days'),
		('Mentalization-based therapy','2 years'),
		('Psychodynamic therapy','10 days'),
		('Animal-assisted therapy','10 years');


--  **************************************************************************************
--  Populate the medicine table.
--  Since the primary key uses IDENTITY, we don't specify a value for that column.
PRINT 'Populating treatment table...';

INSERT INTO medicine 
VALUES	('Lisinopril','Liquid','Bio Farma',100),
		('Levothyroxine','Capsules','Bayer ',150),
		('Azithromycin', 'Injections', 'Bio Farma',50),
		('Metformin','Injections', 'Bio Farma', 20),
		('Lipitor', 'Liquid','Bayer ', 87),
		('Amlodipine','Injections','Bayer ', 47),
		('Amoxicillin', 'Liquid','Bayer ', 101),
		('Hydrochlorothiazide','Capsules','Bayer ', 200);

--  **************************************************************************************
--  Populate the administrative_staff table.

PRINT 'Populating administrative_staff table...';

INSERT INTO administrative_staff (administrative_id, first_name, last_name, gender, email, phone_number, department_id)
VALUES (4000, 'Steven', 'King', 'M', 'SKING', '515 123 4567', 60),
       (4001,'Neena', 'Kochhar', 'F', 'NKOCHHAR', '515 123 4568', 60),
       (4002,'Lex', 'De Haan', 'M', 'LDEHAAN', '515 123 4569', 60),
       (4003,'Alexander', 'Hunold', 'M', 'AHUNOLD', '590 423 4567', 40),
       (4004,'Bruce', 'Ernst', 'M', 'BERNST', '590 423 4568', 40),
       (4005,'Diana', 'Lorentz', 'F', 'DLORENTZ', '590 423 5567',  40),
       (4006,'Kevin', 'Mourgos', 'F', 'KMOURGOS', '650 123 5234', 30);

--  **************************************************************************************
--  Populate the patient table.

PRINT 'Populating patient table...';

INSERT INTO patient (patient_id, first_name, last_name, gender, age, email, street_address, postal_code, city, state_province, phone_number, emergency_contact_name, emergency_contact_phone_number)
VALUES (2000,'Steffan', 'King', 'M', 20, 'SKING','250 Beufort St.', '6002', 'PERTH','WA', '415 654 7655', 'Kathe Kang', '834 234 4303'),
       (2001,'Raid', 'Mars', 'F', 31, 'RMARS','20 Left St.', '6000', 'PERTH','WA', '421 435 5655', 'Jame Smith', '320 304 0943'),
	   (2002,'Sent', 'Lors', 'M', 35, 'SLORS','10 Right St.', '6020', 'PERTH','WA', '654 564 6546', 'Hodl Chan', '645 348 9834'),
	   (2003,'Diana', 'Worn', 'F', 60, 'DWORN','40 Altona St.', '6100', 'PERTH','WA', '987 456 6765', 'Lin Kin', '678 454 3454'),
	   (2004,'Tera', 'Palm', 'F', 70, 'TPALM','2 Lambda St.', '6200', 'PERTH','WA', '535 435 7866', 'Ler Yop', '504 409 4234'),
	   (2005,'Borian', 'Ter', 'M', 80, 'BTER','56 Renaware St.', '6100', 'PERTH','WA', '698 123 7657', 'Juan Sarm', '424 457 3409');


-- **************************************************************************************
-- Populate nurse table.

PRINT 'Populating nurse table...';

INSERT INTO nurse (nurse_id, first_name, last_name, gender, email, phone_number, department_name)
VALUES	(3000,'Andrew', 'Jones', 'M', 'AJRSP', '5613267891', 70),
		(3001,'Karen', 'Smith', 'F', 'KRMS', '5633536789', 20),
		(3002,'Robert', 'Tomson', 'M', 'ROTYSM', '5457689345', 40),
		(3003,'Alex', 'Jackson', 'M', 'ALTJCK', '4456785678', 30),
		(3004,'Hollie', 'Vanegas', 'M', 'HVTMS', '4456896533', 50);


-- **************************************************************************************
-- Populate doctor table.
PRINT 'Populating doctor table...';

INSERT INTO doctor (doctor_id,first_name, last_name, gender, email, phone_number, department_name, specialty)
VALUES	(1000,'Sarah', 'Abelson', 'F', 'sarah', '515 256 8906','ENT','Allergist' ),
		(1001,'Hope', 'Barnum', 'F', 'hope', '515 123 7860','Anesthetics', 'Anesthesiologists'),
		(1002,'Thomas', 'Cacciola', 'M', 'thomas', '515 768 9878','Renal Unit', 'Critical Specialist'),
		(1003,'Wendy', 'Dennin', 'F', 'wendy', '578 137 7864','Cardiology','Cardiologist'),
		(1004,'John', 'Farrell', 'M', 'john', '512 170 1786', 'ENT','Audiologist'),
		(1005,'Michael', 'Gabor', 'M', 'michael', '578 119 1789','Dental','Dentist'),
		(1006,'Allen', 'Herr', 'M', 'allen', '719 189 1988','Gnecology','Gynaecologist'),
		(1007,'Donald', 'Jue', 'M', 'donald', '187 189 1736','Physiotherapy','Paediatrician');


-- **************************************************************************************
-- Populate appointment table.
PRINT 'Populating appointment table...';

INSERT INTO appointment(appointment_date, appointment_time, appointment_room, appointment_reason, doctor_id, patient_id, nurse_id, administrative_id)
VALUES ('2021-01-23', '08:00:00', '101', 'Cancer', 1000, 2000, 3000, 4000),
       ('2021-03-13', '10:30:00', '101', 'Diabetes', 1001, 2001, 3001, 4001),
       ('2021-05-15', '12:00:00', '301', 'Heart Attack', 1002, 2002, 3002, 4002),
       ('2021-06-23', '16:30:00', '401', 'Flu', 1003, 2003, 3003, 4003),
       ('2021-12-03', '11:00:00', '501', 'COVID', 1004, 2004, 3004, 4004),
	   ('2021-06-23', '16:30:00', '401', 'Flu', 1003, 2003, 3003, 4003),
	   ('2021-07-21', '16:30:00', '301', 'Flu', 1003, 2003, 3003, 4003),
	   ('2021-08-22', '16:30:00', '201', 'Flu', 1003, 2003, 3003, 4003),
	   ('2021-10-18', '13:30:00', '401', 'Flu', 1003, 2003, 3003, 4003),
	   ('2021-01-17', '16:30:00', '201', 'Flu', 1003, 2003, 3003, 4003),
	   ('2021-02-16', '13:31:00', '401', 'Flu', 1003, 2003, 3003, 4003),
	   ('2021-03-14', '17:31:00', '401', 'Flu', 1003, 2003, 3003, 4003),
	   ('2021-04-01', '15:10:00', '301', 'Flu', 1003, 2003, 3003, 4003),
	   ('2021-05-20', '16:31:00', '401', 'Flu', 1003, 2003, 3003, 4003),
	   ('2021-07-10', '16:30:00', '401', 'Flu', 1003, 2003, 3003, 4003),
	   ('2021-11-11', '16:30:00', '401', 'Flu', 1003, 2003, 3003, 4003),
	   ('2021-12-03', '16:30:00', '401', 'Flu', 1003, 2003, 3003, 4003);

-- **************************************************************************************
-- Populate prescription table.

PRINT 'Populating prescription table...';

INSERT INTO prescription (prescription_date, prescription_time, prescription_type, appointment_id, medicine_id, treatment_id)
VALUES ('2021-01-13', '08:00:00', 'Treatment', 1, 1, 1),
       ('2021-09-21', '10:30:00', 'Medicine', 2, 2, 2),
       ('2021-10-28', '12:00:00', 'Treatment', 3, 3, 3),
       ('2021-02-10', '16:30:00', 'Medicine', 4, 4, 4),
	   ('2021-09-21', '11:00:00', 'Treatment', 5, 5, 5),
	   ('2021-08-21', '10:30:00', 'Medicine', 2, 2, 2),
       ('2021-10-25', '12:00:00', 'Treatment', 12, 3, 3),
       ('2021-03-10', '16:30:00', 'Medicine', 13, 4, 4),
	   ('2021-01-21', '10:30:00', 'Medicine', 14, 2, 2),
       ('2021-11-28', '12:00:00', 'Treatment', 15, 3, 3),
       ('2021-02-19', '16:30:00', 'Medicine', 16, 4, 4),
	   ('2021-10-10', '11:00:00', 'Treatment', 17, 5, 5),
	   ('2021-10-05', '11:00:00', 'Treatment', 11, 5, 5);