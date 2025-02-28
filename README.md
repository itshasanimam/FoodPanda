# Restaurant and Customer Analysis Project : FoodPanda

This project focuses on analyzing restaurant and customer data to derive insights into customer demographics, restaurant performance, and food preferences. The dataset includes information about customers (age, gender, income, occupation, etc.), restaurants (name, city, rating, cost, etc.), and menu items (cuisine, price, type, etc.). The analysis is performed using SQL queries to extract meaningful information and trends.

## Dataset Overview

The dataset consists of the following tables:

- **Customer:** Contains customer details such as name, age, gender, marital status, occupation, monthly income, family size, and education level.
- **Restaurant:** Contains restaurant details such as name, city, rating, rating count, cost, and type.
- **Menu:** Contains menu items offered by restaurants, including cuisine, price, and food type.
- **Orders:** Contains order details such as order date, restaurant ID, customer ID, and sales amount.
- **Food:** Contains food item details such as item name and type.

## SQL Queries

The project includes **100 SQL queries** that cover a wide range of analyses, including:

- **Customer Demographics:** Analyzing customer age, gender, income, occupation, and family size.
- **Restaurant Performance:** Analyzing restaurant ratings, cost, and revenue.
- **Food Preferences:** Analyzing popular cuisines, food types, and menu prices.
- **Geographical Analysis:** Analyzing restaurant distribution and performance by city.
- **Correlation Analysis:** Exploring relationships between customer demographics, restaurant ratings, and food preferences.
- **Advanced Analysis:** Covering time series trends, clustering customers, predicting restaurant revenue, and sentiment analysis.

## How to Use

1. **Clone the Repository:** Clone this repository to your local machine.
2. **Database Setup:** Ensure you have a SQL database set up with the relevant tables (Customer, Restaurant, Menu, Orders, Food).
3. **Run Queries:** Execute the SQL queries in your database to perform the analyses.
4. **Explore Insights:** Use the results to gain insights into customer behavior, restaurant performance, and food preferences.

## Future Work

- Complete additional complex queries.
- Perform advanced statistical analyses using Python or R.
- Visualize the results using tools like Tableau or Power BI.
- Develop predictive models to forecast restaurant performance and customer preferences.

## Contribution

Feel free to contribute to this project by adding more queries, improving existing ones, or suggesting new analyses. Open an issue or submit a pull request to collaborate.

---

## GitHub Repository

[[Repository Link](https://github.com/itshasanimam/FoodPanda/)]

```sql
-- Example Query: Total Number of Customers by Gender
SELECT gender, COUNT(*) AS total_customers
FROM Customer
GROUP BY gender;
```

## Industry Alignment: Foodpanda

This project aligns with real-world applications like **Foodpanda**, helping optimize restaurant listings, improve customer segmentation, and enhance overall food delivery experiences through data-driven insights.

