import random
from faker import Faker

fake = Faker()

def generate_restaurants(num):
    restaurants = []
    for _ in range(num):
        name = fake.company()
        location = fake.address().replace("\n", ", ")
        cuisine_type = fake.word(ext_word_list=['Italian', 'Chinese', 'Mexican', 'American', 'Indian'])
        price_range = random.choice(['$', '$$', '$$$'])
        contact_info = fake.phone_number()
        restaurants.append((name, location, cuisine_type, price_range, contact_info))
    return restaurants

def generate_customers(num):
    customers = []
    for _ in range(num):
        name = fake.name()
        email = fake.email()
        phone_number = fake.phone_number()
        customers.append((name, email, phone_number))
    return customers

def generate_menus(num, restaurant_ids):
    menus = []
    for _ in range(num):
        dish_name = fake.word()
        price = round(random.uniform(5, 50), 2)
        cuisine_type = fake.word(ext_word_list=['Italian', 'Chinese', 'Mexican', 'American', 'Indian'])
        restaurant_id = random.choice(restaurant_ids)
        menus.append((dish_name, price, cuisine_type, restaurant_id))
    return menus

def generate_reservations(num, customer_ids, restaurant_ids):
    reservations = []
    for _ in range(num):
        date = fake.date_this_decade().strftime('%Y-%m-%d')  
        time = fake.time()
        number_of_people = random.randint(1, 10)
        customer_id = random.choice(customer_ids)
        restaurant_id = random.choice(restaurant_ids)
        reservations.append((date, time, number_of_people, customer_id, restaurant_id))
    return reservations

def generate_reviews(num):
    reviews = []
    for _ in range(num):
        rating = random.randint(1, 5)
        comment = fake.text().replace("'", "''") 
        date = fake.date_this_decade().strftime('%Y-%m-%d')  
        reviews.append((rating, comment, date))
    return reviews

def generate_customer_reviews(num, customer_ids, review_ids):
    customer_reviews = []
    for _ in range(num):
        customer_id = random.choice(customer_ids)
        review_id = random.choice(review_ids)
        customer_reviews.append((customer_id, review_id))
    return customer_reviews

num_records = 50
restaurant_data = generate_restaurants(num_records)
customer_data = generate_customers(num_records)
menu_data = generate_menus(num_records, list(range(1, num_records + 1)))
reservation_data = generate_reservations(num_records, list(range(1, num_records + 1)), list(range(1, num_records + 1)))
review_data = generate_reviews(num_records)
customer_review_data = generate_customer_reviews(num_records, list(range(1, num_records + 1)), list(range(1, num_records + 1)))

# Write to SQL file
with open('populate_database.sql', 'w') as f:
    f.write("INSERT INTO Restaurant (Name, Location, CuisineType, PriceRange, ContactInfo) VALUES ")
    f.write(",\n".join([str(record) for record in restaurant_data]) + ";\n\n")
    
    f.write("INSERT INTO Customer (Name, Email, PhoneNumber) VALUES ")
    f.write(",\n".join([str(record) for record in customer_data]) + ";\n\n")
    
    f.write("INSERT INTO Menu (DishName, Price, CuisineType, RestaurantID) VALUES ")
    f.write(",\n".join([str(record) for record in menu_data]) + ";\n\n")
    
    f.write("INSERT INTO Reservation (Date, Time, NumberOfPeople, CustomerID, RestaurantID) VALUES ")
    f.write(",\n".join([str(record) for record in reservation_data]) + ";\n\n")
    
    f.write("INSERT INTO Review (Rating, Comment, Date) VALUES ")
    f.write(",\n".join([str(record) for record in review_data]) + ";\n\n")
    
    f.write("INSERT INTO CustomerReview (CustomerID, ReviewID) VALUES ")
    f.write(",\n".join([str(record) for record in customer_review_data]) + ";\n\n")

print("Data has been generated and saved to 'populate_database.sql'")
