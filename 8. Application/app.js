const express = require('express');
const sqlite3 = require('sqlite3').verbose();
const bodyParser = require('body-parser');
const path = require('path');

const app = express();
const port = 3000;

// Set up SQLite database connection
const db = new sqlite3.Database('../database.db', (err) => {
  if (err) {
    console.error(err.message);
  } else {
    console.log('Connected to the SQLite database.');
  }
});

// Set up EJS
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));

// Parse application/x-www-form-urlencoded
app.use(bodyParser.urlencoded({ extended: true }));

// Routes
app.get('/', (req, res) => {
  res.render('index');
});

app.listen(port, () => {
  console.log(`App running at http://localhost:${port}`);
});

app.get('/restaurants', (req, res) => {
  const sql = 'SELECT * FROM Restaurant';
  db.all(sql, [], (err, rows) => {
    if (err) {
      res.send("Error retrieving restaurants");
    } else {
      res.render('list-restaurants', { restaurants: rows });
    }
  });
});


app.get('/add-restaurant', (req, res) => {
    res.render('add-restaurant');
}); 

app.post('/add-restaurant', (req, res) => {
const { name, location, cuisineType, priceRange, contactInfo } = req.body;
const sql = 'INSERT INTO Restaurant (Name, Location, CuisineType, PriceRange, ContactInfo) VALUES (?, ?, ?, ?, ?)';
const params = [name, location, cuisineType, priceRange, contactInfo];

db.run(sql, params, function (err) {
    if (err) {
        res.status(400).send("Error adding restaurant");
        } else {
        res.redirect('/restaurants');
        }
    });
});
  
app.get('/delete-restaurant/:id', (req, res) => {
    const sql = 'DELETE FROM Restaurant WHERE ID = ?';
    db.run(sql, req.params.id, function (err) {
      if (err) {
        res.status(400).send("Error deleting restaurant");
      } else {
        res.redirect('/restaurants');
      }
    });
});

app.get('/delete-review/:id', (req, res) => {
    const sql = 'DELETE FROM Review WHERE ID = ?';
    db.run(sql, req.params.id, function (err) {
      if (err) {
        res.status(400).send("Error deleting review");
      } else {
        res.redirect('/reviews');
      }
    });
});

app.get('/reviews', (req, res) => {
    const sql = 'SELECT * FROM Review';
    db.all(sql, [], (err, rows) => {
      if (err) {
        res.send("Error retrieving reviews");
      } else {
        res.render('list-reviews', { reviews: rows });
      }
    });
});
  
  
app.get('/update-restaurant/:id', (req, res) => {
    const sql = 'SELECT * FROM Restaurant WHERE ID = ?';
    db.get(sql, req.params.id, (err, row) => {
      if (err) {
        res.status(400).send("Error finding restaurant");
      } else {
        res.render('update-restaurant', { restaurant: row });
      }
    });
});

app.post('/update-restaurant/:id', (req, res) => {
    const { name, location, cuisineType, priceRange, contactInfo } = req.body;
    const sql = `
      UPDATE Restaurant
      SET Name = ?, Location = ?, CuisineType = ?, PriceRange = ?, ContactInfo = ?
      WHERE ID = ?
    `;
    const params = [name, location, cuisineType, priceRange, contactInfo, req.params.id];
  
    db.run(sql, params, function (err) {
      if (err) {
        res.status(400).send("Error updating restaurant");
      } else {
        res.redirect('/restaurants');
      }
    });
});
  