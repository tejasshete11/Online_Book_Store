-- Create Database
CREATE DATABASE OnlineBookstore;


-- Switch to the database
\c OnlineBookstore;


-- Create Tables
DROP TABLE IF EXISTS Books;

CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);


DROP TABLE IF EXISTS CUSTOMERS;

CREATE TABLE CUSTOMERS (
	CUSTOMER_ID SERIAL PRIMARY KEY,
	NAME VARCHAR(100),
	EMAIL VARCHAR(100),
	PHONE VARCHAR(15),
	CITY VARCHAR(50),
	COUNTRY VARCHAR(150)
);


DROP TABLE IFEXISTS ORDERS;

CREATE TABLE ORDERS (
	ORDER_ID SERIAL PRIMARY KEY,
	CUSTOMER_ID INT REFERENCES CUSTOMERS (CUSTOMER_ID),
	BOOK_ID INT REFERENCES BOOKS (BOOK_ID),
	ORDER_DATE DATE,
	QUANTITY INT,
	TOTAL_AMOUNT NUMERIC(10, 2)
);


SELECT* FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;


-- Import Data into Books Table
COPY Books(Book_ID, Title, Author, Genre, Published_Year, Price, Stock) 
FROM 'D:\sql\30 Day - SQL Practice Files\Books.csv' 
CSV HEADER;


-- Import Data into Customers Table
COPY Customers(Customer_ID, Name, Email, Phone, City, Country) 
FROM 'D:\sql\30 Day - SQL Practice Files\Customers.csv' 
CSV HEADER;


-- Import Data into Orders Table
COPY Orders(Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount) 
FROM 'D:\sql\30 Day - SQL Practice Files\Orders.csv' 
CSV HEADER;


-- 1) Retrieve all books in the "Fiction" genre:
SELECT
	*
FROM
	BOOKS
WHERE
	GENRE = 'Fiction';


-- 2) Find books published after the year 1950:
SELECT
	*
FROM
	BOOKS
WHERE
	PUBLISHED_YEAR >= 1950;


-- 3) List all customers from the Canada:
SELECT
	*
FROM
	CUSTOMERS
WHERE
	COUNTRY = 'Canada';

	
-- 4) Show orders placed in November 2023:
SELECT
	*
FROM
	ORDERS
WHERE
	ORDER_DATE BETWEEN '2023-11-01' AND '2023-11-30';

	
-- 5) Retrieve the total stock of books available:
SELECT
	SUM(STOCK) AS TOTAL_STOCKS
FROM
	BOOKS;


-- 6) Find the details of the most expensive book:
SELECT
	*
FROM
	BOOKS
ORDER BY
	PRICE DESC
LIMIT
	1;


-- 7) Show all customers who ordered more than 1 quantity of a book:
SELECT
	*
FROM
	ORDERS
WHERE
	QUANTITY> 1;

	
-- 8) Retrieve all orders where the total amount exceeds $20:
SELECT
	*
FROM
	ORDERS
WHERE
	TOTAL_AMOUNT > 20;


-- 9) List all genres available in the Books table:
SELECT DISTINCT
	GENRE
FROM
	BOOKS;


-- 10) Find the book with the lowest stock:
SELECT
	*
FROM
	BOOKS
ORDER BY
	STOCK ASC
LIMIT
	1;


-- 11) Calculate the total revenue generated from all orders:
SELECT
	SUM(TOTAL_AMOUNT) AS TOTAL_REVENUE
FROM
	ORDERS;

	
-- Advance Questions : 
-- 1) Retrieve the total number of books sold for each genre:
SELECT
	B.GENRE,
	SUM(O.QUANTITY) AS TOTAL_BOOKS_SOLD
FROM
	ORDERS O
	JOIN BOOKS B ON O.BOOK_ID = B.BOOK_ID
GROUP BY
	GENRE;


-- 2) Find the average price of books in the "Fantasy" genre:
SELECT
	AVG(PRICE) AS AVG_PRICE
FROM
	BOOKS
WHERE
	GENRE = 'Fantasy';


-- 3) List customers who have placed at least 2 orders:
SELECT
	O.CUSTOMER_ID,
	C.NAME,
	COUNT(O.QUANTITY) AS ORDER_COUNT
FROM
	ORDERS O
	JOIN CUSTOMERS C ON O.CUSTOMER_ID = C.CUSTOMER_ID
GROUP BY
	O.CUSTOMER_ID,
	C.NAME
HAVING
	COUNT(QUANTITY) >= 2;


-- 4) Find the most frequently ordered book:
SELECT
	O.BOOK_ID,
	B.TITLE,
	COUNT(O.ORDER_ID) AS ORDER_COUNT
FROM
	ORDERS O
	JOIN BOOKS B ON O.ORDER_ID = B.BOOK_ID
GROUP BY
	O.BOOK_ID,
	B.TITLE
ORDER BY
	ORDER_COUNT DESC
LIMIT
	1;


-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :
SELECT
	*
FROM
	BOOKS
WHERE
	GENRE = 'Fantasy'
ORDER BY
	PRICE DESC
LIMIT
	3;


-- 6) Retrieve the total quantity of books sold by each author:
SELECT
	B.AUTHOR,
	SUM(O.QUANTITY) AS TOTAL_QUANTITY
FROM
	ORDERS O
	JOIN BOOKS B ON O.BOOK_ID = B.BOOK_ID
GROUP BY
	B.AUTHOR;

	
-- 7) List the cities where customers who spent over $30 are located:
SELECT DISTINCT
	C.CITY,
	O.TOTAL_AMOUNT
FROM
	ORDERS O
	JOIN CUSTOMERS C ON O.CUSTOMER_ID = C.CUSTOMER_ID
WHERE
	O.TOTAL_AMOUNT > 30;

	
-- 8) Find the customer who spent the most on orders:
SELECT
	C.CUSTOMER_ID,
	C.NAME,
	SUM(O.TOTAL_AMOUNT) AS TOTAL_SPEND
FROM
	ORDERS O
	JOIN CUSTOMERS C ON O.CUSTOMER_ID = C.CUSTOMER_ID
GROUP BY
	C.CUSTOMER_ID,
	C.NAME
ORDER BY
	TOTAL_SPEND DESC LIMIT
	1;

--9) Calculate the stock remaining after fulfilling all orders:
SELECT
	B.BOOK_ID,
	B.TITLE,
	B.STOCK,
	COALESCE(SUM(O.QUANTITY), 0) AS ORDER_QUANTITY,
	B.STOCK - COALESCE(SUM(O.QUANTITY), 0) AS REMAINING_QUANTITY
FROM
	BOOKS B
	LEFT JOIN ORDERS O ON B.BOOK_ID = O.BOOK_ID
GROUP BY
	B.BOOK_ID
ORDER BYB.BOOK_ID;


-- CTE(Common table expression)
WITH Total_amounts AS(
		SELECT genre, AVG(price) AS avg_price
		FROM books
		GROUP BY genre
)
SELECT genre, avg_price
FROM Total_amounts
WHERE avg_price > 25;


-- View
CREATE VIEW total_prices AS 
	SELECT genre, avg(price) AS avg_p
	FROM books
	group by genre;

SELECT * FROM total_prices WHERE avg_p > 25;