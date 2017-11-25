--Pivot clause
CREATE TABLE departments
( dept_id INT NOT NULL,
  dept_name VARCHAR(50) NOT NULL,
  CONSTRAINT departments_pk PRIMARY KEY (dept_id)
);

CREATE TABLE employees
( employee_number INT NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  first_name VARCHAR(50) NOT NULL,
  salary INT,
  dept_id INT,
  CONSTRAINT employees_pk PRIMARY KEY (employee_number)
);

INSERT INTO departments
(dept_id, dept_name)
VALUES
(30, 'Accounting');

INSERT INTO departments
(dept_id, dept_name)
VALUES
(45, 'Sales');

INSERT INTO employees
(employee_number, last_name, first_name, salary, dept_id)
VALUES
(12009, 'Sutherland', 'Barbara', 54000, 45);

INSERT INTO employees
(employee_number, last_name, first_name, salary, dept_id)
VALUES
(34974, 'Yates', 'Fred', 80000, 45);

INSERT INTO employees
(employee_number, last_name, first_name, salary, dept_id)
VALUES
(34987, 'Erickson', 'Neil', 42000, 45);

INSERT INTO employees
(employee_number, last_name, first_name, salary, dept_id)
VALUES
(45001, 'Parker', 'Salary', 57500, 30);

INSERT INTO employees
(employee_number, last_name, first_name, salary, dept_id)
VALUES
(75623, 'Gates', 'Steve', 65000, 30);