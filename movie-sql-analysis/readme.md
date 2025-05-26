# 🎞️ SQL Movie Database Analysis

A mini SQL project analyzing a movie database using **MySQL**. It includes five queries to explore relationships between movies, actors, genres, and ratings.

---

## 🔍 Queries Included

1. 🎬 **Movies with no genre**  
   Find movies that are not associated with any genre.

2. 🎭 **Movies where the lead actor is also the director**  
   Identify movies where the lead actor took on both roles.

3. 🏆 **Top actors with most lead roles**  
   List the actors with the highest number of lead roles.

4. ⭐ **Genre-wise rating stats**  
   Get average, maximum, and minimum ratings for each genre.

5. 👥 **Top 10 actor pairs who co-starred most often**  
   Find the actor duos who have appeared together most frequently.

---

## 🛠️ Setup Instructions

To test the queries and explore the data, follow these steps:

1. **Use the sample data included in this repo**  
   The file `initial.sql` (in this repository) contains the table structure and sample data for testing.

2. **Set up the database and run the data**

   - Create a new database in your MySQL environment (with any name you like).
   - Open the `initial.sql` file and add this line at the top (replace `YOUR_DB_NAME` with your database name):

     ```sql
     USE YOUR_DB_NAME;
     ```

   - Then run the modified `initial.sql` file in your MySQL environment.
   - This will create all necessary tables and insert the test data.

---

## 📁 Files

- `initial.sql` — Contains all the tables and sample data for testing.
- `code.sql` — Contains all five SQL queries, organized into clear sections.
- `README.md` — Project description and setup instructions (this file).

---

## 📝 Notes

- Designed for **MySQL**.
- You can test and play around with the queries using [dbfiddle.uk](https://www.dbfiddle.uk).

---

Feel free to fork this project and try it with your own datasets!
