--  **************************************************************************************

USE medical_management;

/*	Query 1 

Most Prescript Medicine query that selects the medicine name, medicine type that are more 
prescript for the patients and it cost less than 50 AUD. Order the results by cost.
	
*/

SELECT DISTINCT m.name, m.type_medicine, m.cost
FROM prescription AS p 
	INNER JOIN  medicine AS m
	ON  p.medicine_id=m.medicine_id
WHERE cost<50
ORDER BY cost;


/*	Query 2

A Room 101 Search query which selects the full name, appoinment date, and city name 
of all patients who booked an appointment in room 101. Order the results by time/date, 
in descending order.

*/

SELECT CONCAT(p.first_name, ' ',p.last_name) AS 'Full Name', a.appointment_date, p.city
FROM appointment AS a 
	INNER JOIN patient AS p 
	ON a.patient_id = p.patient_id
WHERE a.appointment_room = '101'


/*	Query 3 

Patient Stats query that selects the full names (by concatenating their first 
name and last name) of all patients in the patient table, how many appointments 
they have each booked. Order the results by age, in descending order.

*/

SELECT DISTINCT p.first_name + p.last_name AS 'full name', p.age
FROM appointment AS a 
	INNER JOIN patient AS p
	ON a.patient_id = p.patient_id
ORDER BY p.age DESC


/*	Query 4

The most busiest day of appointment that select appointment date. By counting 
the number of patients each day to determine the busiest day. Order by time. 
    
*/

SELECT a.appointment_date,
COUNT(p.patient_id) AS 'patients per day'  
FROM appointment as a 
	INNER JOIN patient as p
	ON a.patient_id = p.patient_id
GROUP BY a.appointment_date
ORDER BY COUNT(p.patient_id) DESC;


/*	Query 5

The COVID-related case query that selects the appointment ID, date, patient name,
doctor full name, treatment type and length. Result has to be between 1st of Jan,
  2021 and 1st of November, 2021. Order by date in descending order.

*/

SELECT a.appointment_id, a.appointment_date, CONCAT(p.first_name,' ',p.last_name) AS 'Patient full name',
CONCAT(d.first_name,' ',d.last_name) AS 'doctor full name', prescription_type, type_treatment,length_treatment
FROM patient AS p 
	INNER JOIN appointment AS a
	ON p.patient_id = a.patient_id
	INNER JOIN doctor AS d 
	ON a.doctor_id=d.doctor_id
	INNER JOIN prescription AS pr 
	ON pr.appointment_id=a.appointment_id
	INNER JOIN treatment AS t 
	ON t.treatment_id=pr.treatment_id
WHERE appointment_reason='COVID' AND (appointment_date BETWEEN '2021-01-01' AND '2021-12-31')
ORDER BY appointment_date DESC;


/*	Query 6 

Most popular doctor query that selects the full name, gender, specialty, department 
name, by using number of appointments to determine the most popular doctor, and
showing the total cost of medicines prescript.

*/

SELECT TOP 1 d.doctor_id, d.first_name, d.last_name, d.gender, d.specialty, d.department_name,
	COUNT(a.appointment_id) AS 'Number of appoinments', SUM(m.cost) AS 'Total cost prescript'
FROM appointment AS a 
	INNER JOIN doctor AS d
	ON a.doctor_id = d.doctor_id
	FULL OUTER JOIN prescription AS pr
	ON a.appointment_id = pr.appointment_id
	LEFT OUTER JOIN medicine AS m
	ON pr.medicine_id = m.medicine_id
GROUP BY d.doctor_id, d.first_name, d.last_name, d.gender, d.specialty, d.department_name
ORDER BY COUNT(a.appointment_id) DESC


/*	Query 7 

Create an Appointment Search query that selects the appointment id, patient full 
name, appointment date, appointment time, appointment reason, appointment room, 
prescription type, doctor full name (from doctor table), and of all appointments
settled before or the day 15 of May 2021. Order the results by appointment time
in descending order.
    
*/

SELECT a.appointment_id, a.appointment_date, a.appointment_time, 
a.appointment_room, a.appointment_reason, pr.prescription_type,
CONCAT(p.first_name,' ',p.last_name) AS 'Patient name',
CONCAT(d.first_name,' ',d.last_name) AS 'Doctor name'
FROM appointment as a 
FULL OUTER JOIN patient as p
	ON a.patient_id = p.patient_id
FULL OUTER JOIN doctor as d
	ON a.doctor_id = d.doctor_id
INNER JOIN prescription as pr
	ON a.appointment_id = pr.appointment_id
WHERE a.appointment_date <= '2021-05-15' 
ORDER BY a.appointment_time DESC;


/*	Query 8 

Create an Average Medication Cost query that selects the Patient Name,
medication manufacturer, and average cost spent in Bio Farma, and Bayer
manufacturers by the patient, involving the view pres_medication group 
by Patient Name and Manufacturer.

*/

SELECT pres.[Patient Name], pres.manufacturer, 
AVG(m.cost) AS 'Average Cost Medication'
FROM pres_medication AS pres
	INNER JOIN medicine AS m
	ON pres.medicine_id = m.medicine_id
WHERE m.cost IN (SELECT DISTINCT cost
				FROM medicine
				WHERE manufacturer IN ('Bio Farma', 'Bayer'))
GROUP BY pres.[Patient Name], pres.manufacturer


/*	Query 9 

Create a Doctors attending Females with Flu and Covid Cases query 
that selects the Doctor full name, and average age of patients, 
involving the view patient_history group by doctor name.

*/

SELECT [Doctor Name], AVG(age) AS 'Average age of Patients'
FROM patient_history
WHERE gender IN (SELECT gender
				FROM patient
				WHERE gender = 'F')
AND appointment_reason IN (SELECT appointment_reason
				FROM appointment
				WHERE appointment_reason IN ('COVID','Flu'))
GROUP BY [Doctor Name]




