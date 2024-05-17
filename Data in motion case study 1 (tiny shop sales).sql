**Database Setup and Case Study**

Let me guide you through setting up the database and tables for the Tiny Shop Sales case study. We'll create the necessary tables and insert sample data to address various business questions using SQL.

**Database and Table Creation**

First, create the database and switch to it:

```sql
CREATE DATABASE Tiny_shop_sales;
USE Tiny_shop_sales;
```

Next, create the tables: `customers`, `products`, `orders`, and `order_items`:

```sql
CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(100)
);

CREATE TABLE products (
    product_id INTEGER PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL
);

CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER,
    order_date DATE
);

CREATE TABLE order_items (
    order_id INTEGER,
    product_id INTEGER,
    quantity INTEGER
);
```

**Inserting Sample Data**

Insert sample data into the tables:

```sql
INSERT INTO customers (customer_id, first_name, last_name, email) VALUES
(1, 'John', 'Doe', 'johndoe@email.com'),
(2, 'Jane', 'Smith', 'janesmith@email.com'),
(3, 'Bob', 'Johnson', 'bobjohnson@email.com'),
(4, 'Alice', 'Brown', 'alicebrown@email.com'),
(5, 'Charlie', 'Davis', 'charliedavis@email.com'),
(6, 'Eva', 'Fisher', 'evafisher@email.com'),
(7, 'George', 'Harris', 'georgeharris@email.com'),
(8, 'Ivy', 'Jones', 'ivyjones@email.com'),
(9, 'Kevin', 'Miller', 'kevinmiller@email.com'),
(10, 'Lily', 'Nelson', 'lilynelson@email.com'),
(11, 'Oliver', 'Patterson', 'oliverpatterson@email.com'),
(12, 'Quinn', 'Roberts', 'quinnroberts@email.com'),
(13, 'Sophia', 'Thomas', 'sophiathomas@email.com');

INSERT INTO products (product_id, product_name, price) VALUES
(1, 'Product A', 10.00),
(2, 'Product B', 15.00),
(3, 'Product C', 20.00),
(4, 'Product D', 25.00),
(5, 'Product E', 30.00),
(6, 'Product F', 35.00),
(7, 'Product G', 40.00),
(8, 'Product H', 45.00),
(9, 'Product I', 50.00),
(10, 'Product J', 55.00),
(11, 'Product K', 60.00),
(12, 'Product L', 65.00),
(13, 'Product M', 70.00);

INSERT INTO orders (order_id, customer_id, order_date) VALUES
(1, 1, '2023-05-01'),
(2, 2, '2023-05-02'),
(3, 3, '2023-05-03'),
(4, 1, '2023-05-04'),
(5, 2, '2023-05-05'),
(6, 3, '2023-05-06'),
(7, 4, '2023-05-07'),
(8, 5, '2023-05-08'),
(9, 6, '2023-05-09'),
(10, 7, '2023-05-10'),
(11, 8, '2023-05-11'),
(12, 9, '2023-05-12'),
(13, 10, '2023-05-13'),
(14, 11, '2023-05-14'),
(15, 12, '2023-05-15'),
(16, 13, '2023-05-16');

INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 1, 2),
(1, 2, 1),
(2, 2, 1),
(2, 3, 3),
(3, 1, 1),
(3, 3, 2),
(4, 2, 4),
(4, 3, 1),
(5, 1, 1),
(5, 3, 2),
(6, 2, 3),
(6, 1, 1),
(7, 4, 1),
(7, 5, 2),
(8, 6, 3),
(8, 7, 1),
(9, 8, 2),
(9, 9, 1),
(10, 10, 3),
(10, 11, 2),
(11, 12, 1),
(11, 13, 3),
(12, 4, 2),
(12, 5, 1),
(13, 6, 3),
(13, 7, 2),
(14, 8, 1),
(14, 9, 2),
(15, 10, 3),
(15, 11, 1),
(16, 12, 2),
(16, 13, 3);
```

**SQL Queries for Business Questions**

1. **Which product has the highest price?**

```sql
SELECT product_name, MAX(price) AS highest_price
FROM products
GROUP BY product_name
ORDER BY highest_price DESC
LIMIT 1;
```

2. **Which customer has made the most orders?**

```sql
SELECT c.first_name, c.last_name, a.customer_id AS customer_info, MAX(b.quantity) AS most_orders
FROM orders a
JOIN order_items b ON b.order_id = a.order_id
JOIN customers c ON c.customer_id = a.customer_id
GROUP BY a.customer_id
ORDER BY most_orders DESC
LIMIT 1;
```

3. **What’s the total revenue per product?**

```sql
SELECT product_name, SUM(price * quantity) AS total_revenue
FROM products
JOIN order_items ON order_items.product_id = products.product_id
GROUP BY product_name
ORDER BY total_revenue DESC;
```

4. **Find the day with the highest revenue.**

```sql
SELECT o.order_date AS day, SUM(p.price * q.quantity) AS highest_revenue
FROM orders o
JOIN order_items q ON q.order_id = o.order_id
JOIN products p ON p.product_id = q.product_id
GROUP BY order_date
ORDER BY highest_revenue DESC
LIMIT 1;
```

5. **Find the first order (by date) for each customer.**

```sql
SELECT customer_id, MIN(order_date) AS first_order_date
FROM orders
GROUP BY customer_id;
```

6. **Find the top 3 customers who have ordered the most distinct products.**

```sql
SELECT x.customer_id AS customer, COUNT(DISTINCT z.product_name) AS most_distinct_products
FROM orders x
JOIN order_items y ON y.order_id = x.order_id
JOIN products z ON z.product_id = y.product_id
GROUP BY customer
ORDER BY most_distinct_products DESC
LIMIT 3;
```

7. **Which product has been bought the least in terms of quantity?**

```sql
SELECT d.product_name AS product, SUM(e.quantity) AS least_bought
FROM products d
JOIN order_items e ON e.product_id = d.product_id
GROUP BY product
ORDER BY least_bought ASC
LIMIT 1;
```

8. **What is the median order total?**

Calculating the median in SQL can be complex as SQL does not have a built-in function for median. One approach is to use a window function to find the median.

```sql
SELECT AVG(order_total) AS median_order_total
FROM (
    SELECT order_total, 
           ROW_NUMBER() OVER (ORDER BY order_total) AS row_num,
           COUNT(*) OVER () AS total_rows
    FROM (
        SELECT order_id, SUM(price * quantity) AS order_total
        FROM order_items
        JOIN products ON products.product_id = order_items.product_id
        GROUP BY order_id
    ) AS order_totals
) AS ranked_totals
WHERE row_num IN (FLOOR((total_rows + 1) / 2), CEIL((total_rows + 1) / 2));
```

These queries will help gain valuable insights from the Tiny Shop Sales data.
