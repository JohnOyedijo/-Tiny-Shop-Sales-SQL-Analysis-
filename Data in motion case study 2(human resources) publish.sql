## Overview of the Project

This script sets up a `human_resources` database with tables for departments, employees, and projects. It also includes sample data inserts and SQL queries to address specific business problems.

### Creating and Using the Database

```sql
CREATE DATABASE human_resources;

USE human_resources;
```

### Creating Tables

- **Departments Table**
```sql
CREATE TABLE departments (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    manager_id INT
);
```

- **Employees Table**
```sql
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    hire_date DATE,
    job_title VARCHAR(50),
    department_id INT REFERENCES departments(id)
);
```

- **Projects Table**
```sql
CREATE TABLE projects (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    start_date DATE,
    end_date DATE,
    department_id INT REFERENCES departments(id)
);
```

### Inserting Data

- **Departments Data**
```sql
INSERT INTO departments (name, manager_id)
VALUES ('HR', 1), ('IT', 2), ('Sales', 3);
```

- **Employees Data**
```sql
INSERT INTO employees (name, hire_date, job_title, department_id)
VALUES 
('John Doe', '2018-06-20', 'HR Manager', 1),
('Jane Smith', '2019-07-15', 'IT Manager', 2),
('Alice Johnson', '2020-01-10', 'Sales Manager', 3),
('Bob Miller', '2021-04-30', 'HR Associate', 1),
('Charlie Brown', '2022-10-01', 'IT Associate', 2),
('Dave Davis', '2023-03-15', 'Sales Associate', 3);
```

- **Projects Data**
```sql
INSERT INTO projects (name, start_date, end_date, department_id)
VALUES 
('HR Project 1', '2023-01-01', '2023-06-30', 1),
('IT Project 1', '2023-02-01', '2023-07-31', 2),
('Sales Project 1', '2023-03-01', '2023-08-31', 3);
```

### Updating Manager IDs

```sql
UPDATE departments
SET manager_id = (SELECT id FROM employees WHERE name = 'John Doe')
WHERE name = 'HR';

UPDATE departments
SET manager_id = (SELECT id FROM employees WHERE name = 'Jane Smith')
WHERE name = 'IT';

UPDATE departments
SET manager_id = (SELECT id FROM employees WHERE name = 'Alice Johnson')
WHERE name = 'Sales';
```

### Case Study Questions

#### 1. Find the longest ongoing project for each department

```sql
SELECT b.department_id, a.name, DATEDIFF(a.end_date, a.start_date) AS Project_Days
FROM projects a
JOIN employees b ON b.department_id = a.department_id
GROUP BY b.department_id, a.name
ORDER BY Project_Days DESC;
```

#### 2. Find all employees who are not managers

```sql
SELECT e.name, e.job_title
FROM employees e
LEFT JOIN departments d ON e.id = d.manager_id
WHERE d.manager_id IS NULL;
```

#### 3. Find all employees hired after the start of a project in their department

```sql
SELECT e.name, e.hire_date
FROM employees e
WHERE e.hire_date > (
    SELECT MIN(p.start_date)
    FROM projects p
    WHERE p.department_id = e.department_id
);
```

#### 4. Rank employees within each department based on their hire date

```sql
SELECT e.name, e.hire_date, RANK() OVER(PARTITION BY e.department_id ORDER BY e.hire_date) AS ranking_per_department
FROM employees e;
```

#### 5. Find the duration between the hire date of each employee and the next employee hired in the same department

```sql
SELECT d.name, e.name, DATEDIFF(e.hire_date, LAG(e.hire_date) OVER(PARTITION BY e.department_id ORDER BY e.hire_date)) AS hire_duration_days
FROM employees e
JOIN departments d ON e.department_id = d.id;
```
