CREATE DATABASE EmployeeManagementSystem;
USE EmployeeManagementSystem;



-- Departments Table
CREATE TABLE Departments (
    DepartmentID INT AUTO_INCREMENT PRIMARY KEY,
    DepartmentName VARCHAR(50),
    ManagerID INT -- This can reference an employee later
);

-- Job Roles Table
CREATE TABLE JobRoles (
    JobRoleID INT AUTO_INCREMENT PRIMARY KEY,
    JobTitle VARCHAR(50),
    JobDescription TEXT,
    DepartmentID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);


-- Salaries Table
CREATE TABLE Salaries (
    SalaryID INT AUTO_INCREMENT PRIMARY KEY,
    BaseSalary DECIMAL(10, 2),
    Bonus DECIMAL(10, 2),
    Deductions DECIMAL(10, 2)
);

-- Employees Table
CREATE TABLE Employees (
    EmployeeID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    DOB DATE,
    HireDate DATE,
    DepartmentID INT,
    JobRoleID INT,
    SalaryID INT,
    ManagerID INT,  -- Self-referencing foreign key
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID),
    FOREIGN KEY (JobRoleID) REFERENCES JobRoles(JobRoleID),
    FOREIGN KEY (SalaryID) REFERENCES Salaries(SalaryID),
    FOREIGN KEY (ManagerID) REFERENCES Employees(EmployeeID) -- Self-referencing foreign key
);

ALTER TABLE Departments
ADD CONSTRAINT fk_manager_id
FOREIGN KEY (ManagerID) REFERENCES Employees(EmployeeID);


-- Attendance Table
CREATE TABLE Attendance (
    AttendanceID INT AUTO_INCREMENT PRIMARY KEY,
    EmployeeID INT,
    Date DATE,
    CheckInTime TIME,
    CheckOutTime TIME,
    Status VARCHAR(10), -- e.g., "Present", "Absent", "Leave"
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);

-- Inserting Records into Departments Table
INSERT INTO Departments (DepartmentName, ManagerID) VALUES
('Human Resources', NULL),
('IT', NULL),
('Finance', NULL),
('Marketing', NULL);


-- Inserting Records into JobRoles Table:
INSERT INTO JobRoles (JobTitle, JobDescription, DepartmentID) VALUES
('HR Manager', 'Oversees the HR department.', 1),
('Software Engineer', 'Develops and maintains software applications.', 2),
('Accountant', 'Manages financial records and reports.', 3),
('Marketing Specialist', 'Creates and implements marketing strategies.', 4);

-- Inserting Records into Salaries Table:
INSERT INTO Salaries (BaseSalary, Bonus, Deductions) VALUES
(60000, 5000, 2000),
(80000, 7000, 3000),
(55000, 4000, 1500),
(70000, 6000, 2500);

-- Inserting Records into Employees Table:
-- Insert Managers (Without ManagerID Initially):
INSERT INTO Employees (FirstName, LastName, DOB, HireDate, DepartmentID, JobRoleID, SalaryID) VALUES
('Alice', 'Johnson', '1980-05-22', '2010-03-01', 1, 1, 1),
('Bob', 'Smith', '1978-07-14', '2009-07-01', 2, 2, 2),
('Carol', 'Taylor', '1985-11-12', '2012-01-15', 3, 3, 3),
('David', 'Brown', '1982-09-30', '2011-06-20', 4, 4, 4);
INSERT INTO Employees (EmployeeID, FirstName, LastName, DOB, HireDate, DepartmentID, JobRoleID, SalaryID) VALUES
(5, 'Aice', 'Johnson', '1980-05-22', '2020-03-01', 5, 5, 5),
(6, 'Boba', 'Smith', '1998-07-14', '2009-10-01', 6, 6, 6),
(7, 'Carolior', 'Taylor', '1985-11-12', '2019-01-15', 7, 7, 7),
(8, 'Davidhuy', 'Brown', '1988-09-30', '2011-06-20', 8, 8, 8);

-- Disable Safe Update Mode:
SET SQL_SAFE_UPDATES = 0;

-- Update Departments with ManagerID:
UPDATE Departments SET ManagerID = (SELECT EmployeeID FROM Employees WHERE FirstName = 'Alice' AND LastName = 'Johnson') WHERE DepartmentName = 'Human Resources';
UPDATE Departments SET ManagerID = (SELECT EmployeeID FROM Employees WHERE FirstName = 'Bob' AND LastName = 'Smith') WHERE DepartmentName = 'IT';
UPDATE Departments SET ManagerID = (SELECT EmployeeID FROM Employees WHERE FirstName = 'Carol' AND LastName = 'Taylor') WHERE DepartmentName = 'Finance';
UPDATE Departments SET ManagerID = (SELECT EmployeeID FROM Employees WHERE FirstName = 'David' AND LastName = 'Brown') WHERE DepartmentName = 'Marketing';

-- Re-enable Safe Update Mode (Optional):
SET SQL_SAFE_UPDATES = 1;

--  Insert Other Employees (Assigning ManagerID):
-- Fetch the Manager IDs into Variables:
SET @AliceID = (SELECT EmployeeID FROM Employees WHERE FirstName = 'Alice' AND LastName = 'Johnson');
SET @BobID = (SELECT EmployeeID FROM Employees WHERE FirstName = 'Bob' AND LastName = 'Smith');
SET @CarolID = (SELECT EmployeeID FROM Employees WHERE FirstName = 'Carol' AND LastName = 'Taylor');
SET @DavidID = (SELECT EmployeeID FROM Employees WHERE FirstName = 'David' AND LastName = 'Brown');
-- Use These Variables in the INSERT Statement:
INSERT INTO Employees (FirstName, LastName, DOB, HireDate, DepartmentID, JobRoleID, SalaryID, ManagerID) VALUES
('Emily', 'Clark', '1990-02-18', '2020-05-01', 1, 1, 1, @AliceID),
('Frank', 'Wright', '1988-03-27', '2018-08-10', 2, 2, 2, @BobID),
('Grace', 'Hall', '1992-06-15', '2019-09-05', 3, 3, 3, @CarolID),
('Henry', 'Adams', '1995-12-04', '2021-02-12', 4, 4, 4, @DavidID);

SELECT DepartmentID, DepartmentName FROM Departments;
INSERT INTO Departments (DepartmentID, DepartmentName, ManagerID)
VALUES
(5, 'Human Resources', NULL),
(6, 'IT', NULL),
(7, 'Marketing', NULL),
(8, 'Finance', NULL);


SELECT JobRoleID, JobDescription FROM JobRoles;
INSERT INTO JobRoles (JobRoleID, JobTitle, JobDescription, DepartmentID)
VALUES
(5, 'Software Tester', 'Test the Software', 5),
(6, 'IT Specialist', 'Manages the whole work', 6),
(7, 'Marketing Director', 'Manages the marketing desk', 7),
(8, 'Finance Analyst',  'Checks the Finacial part', 8);

SELECT SalaryID, BaseSalary, Bonus, Deductions FROM Salaries;
INSERT INTO Salaries (SalaryID, BaseSalary, Bonus, Deductions)
VALUES
(5, 55000, 5000, 2000),
(6, 60000, 6000, 2500),
(7, 70000, 7000, 3000),
(8, 80000, 8000, 3500);

INSERT INTO Employees (FirstName, LastName, DOB, HireDate, DepartmentID, JobRoleID, SalaryID)
VALUES
('Aice', 'Johnson', '1980-05-22', '2020-03-01', 5, 5, 5),
('Boba', 'Smith', '1998-07-14', '2009-10-01', 6, 6, 6),
('Carolior', 'Taylor', '1985-11-12', '2019-01-15', 7, 7, 7),
('Davidhuy', 'Brown', '1988-09-30', '2011-06-20', 8, 8, 8);

INSERT INTO Attendance (EmployeeID, Date, CheckInTime, CheckOutTime, Status)
VALUES
(1, '2024-08-01', '09:00:00', '17:00:00', 'Present'),
(2, '2024-08-01', '09:00:00', '17:00:00', 'Present'),
(3, '2024-08-01', '09:15:00', '17:15:00', 'Present'),
(4, '2024-08-01', '09:30:00', '17:30:00', 'Present'),
(5, '2024-08-01', '09:00:00', '17:00:00', 'Present'),
(6, '2024-08-01', '09:00:00', '17:00:00', 'Present'),
(7, '2024-08-01', '09:00:00', '17:00:00', 'Present'),
(8, '2024-08-01', '09:00:00', '17:00:00', 'Present');



-- Trigger to Update Department Headcount:
DELIMITER //

CREATE TRIGGER UpdateDepartmentHeadcount
AFTER INSERT ON Employees
FOR EACH ROW
BEGIN
    UPDATE Departments
    SET Headcount = Headcount + 1
    WHERE DepartmentID = NEW.DepartmentID;
END //

DELIMITER ;

-- Trigger to Reduce Department Headcount:
DELIMITER //

CREATE TRIGGER ReduceDepartmentHeadcount
AFTER DELETE ON Employees
FOR EACH ROW
BEGIN
    UPDATE Departments
    SET Headcount = Headcount - 1
    WHERE DepartmentID = OLD.DepartmentID;
END //

DELIMITER ;

-- Procedure to Calculate Payroll:

DELIMITER $$

CREATE PROCEDURE CalculatePayroll(IN emp_id INT)
BEGIN
    DECLARE total_salary DECIMAL(10, 2);
    
    -- Ensure you are selecting the correct columns and using the correct table
    SELECT (s.BaseSalary + s.Bonus - s.Deductions) INTO total_salary
    FROM Salaries s
    JOIN Employees e ON e.SalaryID = s.SalaryID
    WHERE e.EmployeeID = emp_id;
    
    SELECT total_salary AS 'Total Salary for Employee';
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE CalculatePayroll(IN emp_id INT)
BEGIN
    DECLARE total_salary DECIMAL(10, 2);
    
    -- Ensure you are selecting the correct columns and using the correct table
    SELECT (s.BaseSalary + s.Bonus - s.Deductions) INTO total_salary
    FROM Salaries s
    JOIN Employees e ON e.SalaryID = s.SalaryID
    WHERE e.EmployeeID = emp_id;
    
    SELECT total_salary AS 'Total Salary for Employee';
END $$

DELIMITER ;

-- Procedure to Generate Department Performance Report:
DELIMITER //

CREATE PROCEDURE DepartmentPerformance(IN department_id INT)
BEGIN
    SELECT DepartmentName, COUNT(*) AS TotalEmployees, AVG(BaseSalary) AS AvgSalary
    FROM Employees
    JOIN Salaries ON Employees.SalaryID = Salaries.SalaryID
    JOIN Departments ON Employees.DepartmentID = Departments.DepartmentID
    WHERE Employees.DepartmentID = department_id
    GROUP BY DepartmentName;
END //

DELIMITER ;

-- Function to Calculate Total Salary:

SET GLOBAL log_bin_trust_function_creators = 1;

DELIMITER //

CREATE FUNCTION CalculateTotalSalary(emp_id INT) RETURNS DECIMAL(10, 2)
BEGIN
    DECLARE total_salary DECIMAL(10, 2);
    SELECT (BaseSalary + Bonus - Deductions) INTO total_salary
    FROM Salaries
    WHERE EmployeeID = emp_id;
    RETURN total_salary;
END //

DELIMITER ;

DELIMITER //

-- Function to Calculate Attendance Percentage:
CREATE FUNCTION AttendancePercentage(emp_id INT) RETURNS DECIMAL(5, 2)
BEGIN
    DECLARE total_days INT;
    DECLARE present_days INT;
    DECLARE attendance_percent DECIMAL(5, 2);

    SELECT COUNT(*) INTO total_days FROM Attendance WHERE EmployeeID = emp_id;
    SELECT COUNT(*) INTO present_days FROM Attendance WHERE EmployeeID = emp_id AND Status = 'Present';

    SET attendance_percent = (present_days / total_days) * 100;
    RETURN attendance_percent;
END //

DELIMITER ;

-- Transfer an Employee to Another Department:
UPDATE Employees
SET DepartmentID = 2
WHERE EmployeeID = 1;

-- Calculate Payroll for an Employee:
CALL CalculatePayroll(1);

-- Get Departmental Performance Report:
CALL DepartmentPerformance(1);

-- Creating Indexes for Performance Improvement:
CREATE INDEX idx_employee_department ON Employees(DepartmentID);
ALTER TABLE Salaries ADD COLUMN EmployeeID INT;
CREATE INDEX idx_salary_employee ON Salaries(EmployeeID);
CREATE INDEX idx_attendance_employee ON Attendance(EmployeeID);


SELECT * FROM ATTENDANCE;

