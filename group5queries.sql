USE Dental_Med_Sys
GO

--1. Show the appointments for a doctor for tomorrow.

SELECT CONCAT(d.First_Name,' ',d.Last_Name) AS Dentist_Name,a.Date AS Appointment_Date, 
CONVERT(VARCHAR(15),CAST(a.Time AS time),100) AS Appointment_Time 
FROM Appointment a join Dentist d
ON a.Dentist_ID=d.Dentist_ID 
WHERE a.DATE =CONVERT(DATE, GETDATE()+1) and d.Dentist_ID=1 --HERE WE ADD ONE TO THE DATE RETURNED FROM THE SYSTEM
GO

--2. Show me a patients next appointment.

SELECT TOP 1 CONCAT(p.First_Name,' ',p.Last_Name) AS Patient_Name,a.Date AS Appointment_Date,
CONVERT(VARCHAR(15),CAST(a.Time AS TIME),100) AS Appointment_Time,a.Room_ID AS Room_Number,
l.Street_Name,l.City  
FROM Appointment a join Patient p ON
a.Patient_ID=p.Patient_ID join Room r ON a.Room_ID=r.Room_ID join Location l ON r.Location_ID=l.Location_ID 
WHERE  Date > GETDATE() and p.Patient_ID=1 
GO

--3. How many teeth does a patient have

SELECT CONCAT(p.First_Name,' ',p.Last_Name) AS Patient_Name, COUNT(Tooth_ID) AS Number_of_Teeth 
FROM Present_no_of_Teeth pot join Present_Mouth_Condition pmc ON
pot.Mouth_Condition_ID=pmc.Mouth_Condition_ID join Patient p ON
p.Patient_ID= pmc.Patient_ID 
WHERE pot.Mouth_Condition_ID=1
GROUP BY CONCAT(p.First_Name,' ',p.Last_Name)
GO

--4. Show an invoice

SELECT i.Invoice_Number,i.Invoice_Amount,i.Date_Of_Generation,a.Date,
CONVERT(VARCHAR(15),CAST(a.Time as time),100) AS Appointment_Time,
CONCAT(d.First_Name,' ',d.Last_Name) AS Dentist_Name,
p.First_Name AS Patient_FirstName,p.Last_Name AS Patient_LastName,tc.Treatment_Name 
FROM invoice i join Appointment a ON i.Appointment_ID=a.Appointment_ID join Dentist d ON
i.Dentist_ID=d.Dentist_ID join Patient p ON i.Patient_ID=p.Patient_ID join Treatment t ON
t.Invoice_Number=i.Invoice_Number join Treatment_Catalog tc ON
t.Treatment_Catalog_ID=tc.Treatment_Catalog_ID
ORDER BY Invoice_Number ASC 

--5. Show the treatments associated with an appointment

SELECT tc.Treatment_Name 
FROM Appointment a join Problem_Detected pd ON
a.Appointment_ID=pd.Appointment_ID join Treatment t ON 
pd.Treatment_ID=t.Treatment_ID join Treatment_Catalog tc ON
tc.Treatment_Catalog_ID=t.Treatment_Catalog_ID 
WHERE a.Appointment_ID=10
GO

--6. Show the treatments that make up an invoice

SELECT i.Invoice_Number,i.Invoice_Amount,i.Date_Of_Generation,a.Date,
CONVERT(varchar(15),CAST(a.Time as time),100) AS Appointment_Time,
CONCAT(d.First_Name,' ',d.Last_Name) AS Dentist_Name, --concatinating first & lastname as Dentist_Name
CONCAT(p.First_Name,' ',p.Last_Name) AS Patient_Name,tc.Treatment_Name --concatinating first & lastname as Patient_Name
FROM invoice i join Appointment a ON i.Appointment_ID=a.Appointment_ID join Dentist d ON
i.Dentist_ID=d.Dentist_ID join Patient p ON i.Patient_ID=p.Patient_ID join Treatment t ON
t.Invoice_Number=i.Invoice_Number join Treatment_Catalog tc ON
t.Treatment_Catalog_ID=tc.Treatment_Catalog_ID WHERE i.Invoice_Number=2 --we are considering invoice ID 2
GO
