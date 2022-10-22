--  **************************************************************************************


USE medical_management;
GO

/*	View 1
	
Create a Prescribe Medication View that selects the patient�s full name, medicine name,
type, manufacturer and cost, prescription date, and appointment date.

*/

CREATE VIEW pres_medication 
AS SELECT m.medicine_id, m.name AS 'Medication Name', m.type_medicine, m.manufacturer,
CONCAT(p.first_name,' ', p.last_name) AS 'Patient Name',
a.appointment_date, pr.prescription_date
   FROM medicine as m
	INNER JOIN prescription AS pr
	ON m.medicine_id = pr.medicine_id
	INNER JOIN appointment AS a
	ON a.appointment_id = pr.appointment_id
	INNER JOIN patient AS p
	ON a.patient_id = p.patient_id;

GO

SELECT * FROM pres_medication;


/*	View 2 

Create a Patient History View that selects the full Name, Age, Gender, date 
time of patient appointments, with the name of doctor, reason, and treatment. 
This will involve only the use of one patient register and joining the patient, 
appointment, treatment, and doctor tables.

*/

CREATE VIEW patient_history 
AS SELECT CONCAT(p.first_name,' ', p.last_name) AS 'Patient Name',
p.age, p.gender,a.appointment_reason, a.appointment_date, t.type_treatment,
CONCAT(d.first_name,' ', d.last_name) AS 'Doctor Name'
FROM patient AS p
	INNER JOIN appointment AS a
	ON p.patient_id = a.patient_id
	INNER JOIN doctor AS d
	ON a.doctor_id = d.doctor_id
	INNER JOIN prescription AS pr
	ON a.appointment_id = pr.appointment_id 
	INNER JOIN treatment AS t
	ON pr.treatment_id = t.treatment_id 
GO

SELECT * FROM patient_history;
