# End-to-End Q-Commerce Delivery & Sales Analytics Project  
(Python | SQL Server | Power BI)

## 📌 Project Overview  
This project demonstrates an end-to-end data analytics workflow to analyze Q-commerce (quick-commerce) order and delivery performance.  
The objective is to extract insights from raw data and support business decisions related to delivery efficiency, customer experience, platform performance, and revenue optimization.

The project follows a real-world workflow:  
Business Problem → Python (EDA) → SQL Server (Analysis) → Power BI (Dashboard) → Reporting 

---

## 🔁 Project Workflow  
Below is the end-to-end workflow I followed for this project:

![Project Workflow](images/Draw.io_project_flow_diagram.drawio.png)

*(Workflow designed by me using draw.io)*

---

## 🎯 Business Problem  
A Q-commerce company operates across multiple delivery platforms and product categories. Despite high order volumes, the business faces challenges related to delivery delays, inconsistent service quality, refund requests, and uneven performance across platforms and categories.  

The goal is to identify key performance drivers, operational bottlenecks, and high-value customer segments to improve delivery operations, customer satisfaction, and revenue growth.

**Main Objective:**  
Use order, delivery, and customer interaction data to identify trends and provide actionable business recommendations.

---

## 🛠 Tools & Technologies  
- **Python** – Data cleaning, transformation, and EDA  
- **SQL Server** – Data analysis and business metrics  
- **Power BI** – Interactive dashboard and data storytelling  
- **GitHub** – Project version control and portfolio  

---

## 📂 Project Structure  
- data/ → Raw and cleaned dataset  
- notebooks/ → Python EDA & data cleaning notebooks  
- sql/ → SQL Server analysis queries  
- powerbi/ → Power BI dashboard (.pbix)  
- report/ → Business problem statement & domain guide (PDF)  
- presentation/ → Final presentation  
- images/ → Workflow & dashboard screenshots  
- workflow/ → Workflow (draw.io)  

---

## 🔍 What I Did in This Project  

### 1️⃣ Data Preparation & EDA (Python)  
- Loaded Q-commerce order dataset using pandas  
- Renamed columns for consistency and SQL compatibility  
- Handled missing values and data type issues  
- Performed exploratory analysis to understand distributions and patterns  
- Created derived features such as order value segmentation (Budget, Standard, VIP)  

### 2️⃣ Data Analysis (SQL Server)  
- Loaded cleaned data into SQL Server  
- Wrote queries to analyze:  
  - Platform-wise orders and revenue  
  - Product category contribution  
  - Delivery delays and refund requests  
  - Service ratings by platform and category  
  - Customer segmentation and top customers  
  - Part-to-whole contribution analysis  

### 3️⃣ Dashboard (Power BI)  
Below is a preview of the Power BI dashboard created for this project:

![Power BI Dashboard](images/Q_Commerce_Dashboard.png)

The dashboard includes:  
- KPI cards (Total Orders, Total Sales, Avg Delivery Time, Avg Rating, AOV)  
- Orders by product category  
- Delivery delay distribution  
- Orders by service rating  
- Orders by delivery time buckets  
- Order value segmentation with interactive slicers  

---

## 📊 Key Insights  
- Delivery delays are a major friction point and correlate with lower service ratings and higher refund requests  
- Certain platforms contribute a disproportionate share of total orders and revenue  
- High-value (VIP) customers contribute significantly to revenue despite fewer orders  
- Product category performance varies across platforms  

---

## 💡 Business Recommendations  
- Optimize last-mile delivery to reduce delays and improve customer satisfaction  
- Focus operational improvements on platforms with high sales but lower service ratings  
- Prioritize inventory and promotions for top-performing product categories  
- Introduce loyalty benefits for high-value customers to improve retention  

---

## 📎 How to Run This Project  
1. Run the Python notebook to clean and prepare the dataset  
2. Load the cleaned data into SQL Server  
3. Execute SQL queries for business analysis  
4. Connect Power BI to SQL Server and refresh the dashboard  

---

## 👤 Author  
**Name:** Kiran Kalisetti  
**LinkedIn:** https://www.linkedin.com/in/kalisetti-kiran-2370922b1  
**GitHub:** https://github.com/kalisettikiran920-afk  

---

## ⚠️ Disclaimer  
This project is created for learning and portfolio purposes using a public (synthetic) dataset, with custom modifications and insights added by me.
