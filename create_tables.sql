-- 1. Restaurant Table
CREATE TABLE Restaurant (
    ID INTEGER PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Location VARCHAR(255) NOT NULL,
    CuisineType VARCHAR(50),
    PriceRange VARCHAR(10),
    ContactInfo VARCHAR(50)
);

-- 2. Customer Table
CREATE TABLE Customer (
    ID INTEGER PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100),
    PhoneNumber VARCHAR(15)
);

-- 3. Reservation Table
CREATE TABLE Reservation (
    ID INTEGER PRIMARY KEY,
    Date DATE NOT NULL,
    Time TIME NOT NULL,
    NumberOfPeople INTEGER NOT NULL,
    CustomerID INTEGER,
    RestaurantID INTEGER,
    FOREIGN KEY (CustomerID) REFERENCES Customer(ID),
    FOREIGN KEY (RestaurantID) REFERENCES Restaurant(ID)
);

-- 4. Review Table
CREATE TABLE Review (
    ID INTEGER PRIMARY KEY,
    Rating INTEGER CHECK(Rating >= 1 AND Rating <= 5),
    Comment TEXT,
    Date DATE NOT NULL
);

-- 5. Menu Table
CREATE TABLE Menu (
    ID INTEGER PRIMARY KEY,
    DishName VARCHAR(100) NOT NULL,
    Price DECIMAL(10, 2) NOT NULL,
    CuisineType VARCHAR(50),
    RestaurantID INTEGER,
    FOREIGN KEY (RestaurantID) REFERENCES Restaurant(ID)
);

-- 6. CustomerReview Table
CREATE TABLE CustomerReview (
    CustomerID INTEGER,
    ReviewID INTEGER,
    PRIMARY KEY (CustomerID, ReviewID),
    FOREIGN KEY (CustomerID) REFERENCES Customer(ID),
    FOREIGN KEY (ReviewID) REFERENCES Review(ID)
);
