/* ----------------------------------------------------------------------------------------------
Homework Assignment- Week 9 - SQL queries using Sakila database
-------------------------------------------------------------------------------------------------*/

-- The database - Sakila
USE sakila;

-- Question 1a. Display the first and last names of all actors from the table `actor`.
SELECT 
    first_name, last_name
FROM
    actor;
-- -------------------------------------

-- Question 1b. Display the first and last name of each actor in a single column in upper case letters. 
-- Name the column `Actor Name`.
SELECT 
    UPPER(CONCAT(first_name, ' ', last_name)) AS 'Actor Name'
FROM
    actor;
-- --------------------------------------

 -- Question 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 
 -- What is one query would you use to obtain this information?
SELECT 
    actor_id, first_name, last_name
FROM
    actor
WHERE
    first_name LIKE 'Joe';
-- --------------------------------------

-- Question 2b. Find all actors whose last name contain the letters `GEN`: 
SELECT 
    actor_id, first_name, last_name
FROM
    actor
WHERE
    last_name LIKE '%GEN%';
-- --------------------------------------

-- Question 2c. Find all actors whose last names contain the letters `LI`. 
-- This time, order the rows by last name and first name, in that order:
SELECT 
    first_name, last_name
FROM
    actor
WHERE
    last_name LIKE '%LI%'
    ORDER BY last_name, first_name;
-- --------------------------------------

--  Question 2d. Using `IN`, display the `country_id` and `country` columns of the 
-- following countries: Afghanistan, Bangladesh, and China:
SELECT 
    country_id, country
FROM
    country
WHERE
    country IN ('Afghanistan' , 'Bangladesh', 'China');
-- --------------------------------------

--  Question 3a. Create a column in the table `actor` named `description` and use the data type `BLOB` 
ALTER TABLE actor 
ADD COLUMN  description  BLOB;
SELECT 
    *
FROM
    actor;
-- --------------------------------------

-- Question 3b. Very quickly you realize that entering descriptions for each actor is too much effort. 
-- Delete the description column.
ALTER TABLE actor 
DROP COLUMN description;
SELECT 
    *
FROM
    actor;
-- --------------------------------------

-- Question 4a. List the last names of actors, as well as how many actors have that last name
SELECT 
    last_name AS 'Actor Last Name',
    COUNT(last_name) AS 'Actor Last Name Count'
FROM
    actor
GROUP BY last_name;
-- --------------------------------------	

-- Question 4b. List last names of actors and the number of actors who have that last name, 
-- but only for names that are shared by at least two actors
SELECT 
    last_name AS 'Actor Last Name',
    COUNT(last_name) AS 'Actor Last Name Count'
FROM
    actor
GROUP BY last_name
HAVING COUNT(last_name) > 1;
-- --------------------------------------

-- Question 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. 
-- Write a query to fix the record.
-- First check for 'GROUCHO WILLIAMS'
SELECT 
    first_name, last_name
FROM
    actor
WHERE
    first_name = 'GROUCHO'
        AND last_name = 'WILLIAMS';
    
--  Update  the actor name GROUCHO WILLIAMS to HARPO WILLIAMS
UPDATE actor 
SET 
    first_name = 'HARPO'
WHERE
    first_name = 'GROUCHO';
    
-- recheck for the name change
	SELECT 
    first_name, last_name
FROM
    actor
WHERE
    first_name = 'HARPO'
        AND last_name = 'WILLIAMS';
/*---------------------------------------

Question 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. 
 It turns out that GROUCHO was the correct name after all! In a single query, 
if the first name of the actor is currently HARPO, change it to GROUCHO.
Update  the actor name HARPO WILLIAMS to GROUCHO WILLIAMS*/
UPDATE actor 
SET 
    first_name = 'GROUCHO'
WHERE
    first_name = 'HARPO';
-- Check for the correction
SELECT 
    first_name, last_name
FROM
    actor
WHERE
    first_name = 'GROUCHO'
        AND last_name = 'WILLIAMS';
-- --------------------------------------

-- Question 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
SHOW CREATE TABLE address;
-- --------------------------------------

-- Question 6a. Use JOIN to display the first and last names, as well as the address, of each staff member.
--  Use the tables staff and address:
SELECT 
    s.first_name AS 'First Name', s.last_name AS 'Last Name', a.address AS 'Address'
FROM
    staff AS s 
        INNER JOIN
    address AS a ON a.address_id = s.address_id;
-- --------------------------------------

-- Question 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. 
-- Use tables staff and payment
SELECT 
    CONCAT(s.first_name, ' ', s.last_name) AS 'Staff Name',
    SUM(p.amount) AS 'Gross Amount'
FROM
    payment AS p
        INNER JOIN
    staff AS s ON (p.staff_id = s.staff_id)
WHERE
    p.payment_date LIKE '2005-08-%'
GROUP BY p.staff_id;
-- --------------------------------------

-- Question 6c. List each film and the number of actors who are listed for that film. 
-- Use tables film_actor and film. Use inner join.
SELECT 
    f.title AS 'Film Title',
    COUNT(actor_id) AS 'Number of Actors'
FROM
    film AS f
        INNER JOIN
    film_actor AS a ON (f.film_id = a.film_id)
GROUP BY f.title;
-- --------------------------------------

-- Question 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT 
    f.title AS 'Film Title', COUNT(i.film_id) AS 'Copies of Film'
FROM
    inventory AS i
        JOIN
    film AS f ON (f.film_id = i.film_id)
WHERE
    f.title = 'Hunchback Impossible';
-- --------------------------------------

-- Question 6e. Using the tables payment and customer and the JOIN command, 
-- list the total paid by each customer. 
-- List the customers alphabetically by last name:
SELECT 
    c.first_name,
    c.last_name,
    SUM(p.amount) AS 'Total Amount Paid'
FROM
    payment AS p
        INNER JOIN
    customer AS c ON (c.customer_id = p.customer_id)
GROUP BY c.customer_id
ORDER BY c.last_name ASC;

-- --------------------------------------
/*Question 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
As an unintended consequence, films starting with the letters K and Q have also soared in popularity. 
Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.*/
SELECT 
    title AS 'Title'
FROM
    film
WHERE
    language_id IN (SELECT 
            language_id
        FROM
            language
        WHERE
           name = 'English' AND  title LIKE 'K%' OR title LIKE 'Q%');
-- --------------------------------------

-- Question 7b. Use subqueries to display all actors who appear in the film Alone Trip
SELECT 
    CONCAT(first_name, ' ', last_name) AS 'Actors in film Alone Trip'
FROM
    actor
WHERE
    actor_id IN (SELECT 
            actor_id
        FROM
            film_actor
        WHERE
            film_id IN (SELECT 
                    film_id
                FROM
                    film
                WHERE
                    title = 'Alone Trip'));
/* --------------------------------------

Question 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. 
Use joins to retrieve this information.*/
SELECT 
    CONCAT(c.first_name, ' ', c.last_name) AS 'Customer Name',
    c.email AS 'Email Address'
FROM
    customer AS c
        INNER JOIN
    address AS a ON (c.address_id = a.address_id)
        INNER JOIN
    city AS ct ON (a.city_id = ct.city_id)
        INNER JOIN
    country AS cy ON (ct.country_id = cy.country_id)
WHERE
    country = 'Canada';
/* --------------------------------------

 Question 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
 Identify all movies categorized as family films.*/
SELECT 
    title AS 'Family Films'
FROM
    film_list
WHERE
   category = 'Family';
-- --------------------------------------

--   Question 7e. Display the most frequently rented movies in descending order.
SELECT 
    f.title AS 'Film Title',
    COUNT(r.rental_date) AS 'Count of Rented Movies'
FROM
    film AS f
        INNER JOIN
    inventory AS i ON (i.film_id = f.film_id)
        INNER JOIN
    rental AS r ON (i.inventory_id = r.inventory_id)
GROUP BY f.title
ORDER BY COUNT(r.rental_date) DESC;
-- --------------------------------------
    
--  Question 7f. Write a query to display how much business, in dollars, each store brought in
SELECT 
    store_id AS 'Store ID', SUM(amount) AS 'Gross in Dollars'
FROM
    store
        INNER JOIN
    inventory USING (store_id)
        INNER JOIN
    rental USING (inventory_id)
        INNER JOIN
    payment USING (rental_id)
GROUP BY (store_id);
-- OR
select store as 'Store', total_sales as 'Total Sales' from sales_by_store;
-- --------------------------------------

-- Question 7g. Write a query to display for each store its store ID, city, and country.
SELECT 
    s.store_id AS 'Store ID',
    ct.city AS 'City',
    cy.country AS 'Country'
FROM
    store AS s
        INNER JOIN
    customer cr ON (s.store_id = cr.store_id)
        INNER JOIN
    address AS a ON (cr.address_id = a.address_id)
        INNER JOIN
    city AS ct ON (ct.city_id = a.city_id)
        INNER JOIN
    country AS cy ON (ct.country_id = cy.country_id);
-- --------------------------------------

 -- Question 7h. List the top five genres in gross revenue in descending order.
SELECT 
    c.name AS 'Film Category', SUM(p.amount) AS 'Gross Revenue'
FROM
    category AS c
        INNER JOIN
    film_category AS f ON (c.category_id = f.category_id)
        INNER JOIN
    inventory AS i ON (f.film_id = i.film_id)
        INNER JOIN
    rental AS r ON (r.inventory_id = i.inventory_id)
        INNER JOIN
    payment AS p ON (p.rental_id = r.rental_id)
GROUP BY c.name
ORDER BY SUM(p.amount) DESC
LIMIT 5;
-- --------------------------------------	

/*8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue.
 Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view. */
CREATE VIEW top_five_genres AS
 SELECT 
    c.name AS 'Film Category', SUM(p.amount) AS 'Gross Revenue'
FROM
    category AS c
        INNER JOIN
    film_category AS f ON (c.category_id = f.category_id)
        INNER JOIN
    inventory AS i ON (f.film_id = i.film_id)
        INNER JOIN
    rental AS r ON (r.inventory_id = i.inventory_id)
        INNER JOIN
    payment AS p ON (p.rental_id = r.rental_id)
GROUP BY c.name
ORDER BY SUM(p.amount) DESC
LIMIT 5;
-- --------------------------------------

-- 8b. How would you display the view that you created in 8a?
SELECT 
    *
FROM
    top_five_genres;
-- --------------------------------------

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW top_five_genres;
-- -----------------------------------------------------------------
-- End of all the queries on the database 'Sakila'
-- ---------------------------------------------------------------------