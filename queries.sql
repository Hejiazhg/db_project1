-- Query 1: Join the Reservation, Customer, and Restaurant tables to get a list of reservations, including customer names and restaurant details.
SELECT r.ID as ReservationID, c.Name as CustomerName, res.Name as RestaurantName, res.Location as RestaurantLocation
FROM Reservation r
JOIN Customer c ON r.CustomerID = c.ID
JOIN Restaurant res ON r.RestaurantID = res.ID;

-- Query 2: Using a Subquery to find all restaurants that have received a review with a rating of 5
SELECT DISTINCT r.Name as RestaurantName, r.Location as RestaurantLocation
FROM Restaurant r
WHERE EXISTS (
    SELECT 1
    FROM Menu m
    JOIN CustomerReview cr ON m.RestaurantID = cr.CustomerID
    JOIN Review rev ON cr.ReviewID = rev.ID
    WHERE m.RestaurantID = r.ID AND rev.Rating = 5
);

-- Query 3: Group by with a having clause: Group the reviews by restaurant and find the restaurants that have an average rating higher than 4
SELECT r.Name as RestaurantName, AVG(rev.Rating) as AverageRating
FROM Restaurant r
JOIN Menu m ON r.ID = m.RestaurantID
JOIN CustomerReview cr ON m.RestaurantID = cr.CustomerID
JOIN Review rev ON cr.ReviewID = rev.ID
GROUP BY r.ID
HAVING AVG(rev.Rating) > 4;

-- Query 4: Complex search criterion: Find all customers who have made a reservation for more than 3 people at an American restaurant
SELECT c.Name as CustomerName, r.Name as RestaurantName, res.NumberOfPeople, r.Location as RestaurantLocation
FROM Customer c
JOIN Reservation res ON c.ID = res.CustomerID
JOIN Restaurant r ON res.RestaurantID = r.ID
WHERE res.NumberOfPeople > 3 AND r.CuisineType = 'American';

-- Query 5: Experiment with advanced query mechanisms: Use PARTITION BY to rank restaurants within each cuisine type based on their average review rating
SELECT r.Name as RestaurantName, r.CuisineType, AVG(rev.Rating) as AverageRating,
       RANK() OVER(PARTITION BY r.CuisineType ORDER BY AVG(rev.Rating) DESC) as CuisineTypeRank
FROM Restaurant r
JOIN Menu m ON r.ID = m.RestaurantID
JOIN CustomerReview cr ON m.RestaurantID = cr.CustomerID
JOIN Review rev ON cr.ReviewID = rev.ID
GROUP BY r.ID, r.CuisineType;