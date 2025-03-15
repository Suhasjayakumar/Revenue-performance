# Revenue Performance Dashboard

This repository contains SQL queries and DAX measures used to create the **Revenue Performance Dashboard** in Power BI. The dashboard provides insights into total revenue, revenue by region, revenue by department, top clients, and month-on-month revenue growth.

---
## 📌 SQL Queries

### 1️⃣ Fetching All Data
```sql
SELECT * FROM branch_data;
SELECT * FROM service_data;
```

### 2️⃣ Revenue by Region
```sql
SELECT branch_data.region, ROUND(SUM(service_data.total_revenue), 2) AS total_revenue
FROM service_data
JOIN branch_data ON service_data.branch_id = branch_data.branch_id
GROUP BY branch_data.region
ORDER BY total_revenue DESC;
```

### 3️⃣ Revenue by Department
```sql
SELECT service_data.department, SUM(service_data.total_revenue) AS total_revenue
FROM service_data
GROUP BY service_data.department
ORDER BY total_revenue DESC;
```

### 4️⃣ Revenue by Client
```sql
SELECT service_data.client_name, SUM(service_data.total_revenue) AS total_revenue
FROM service_data
GROUP BY service_data.client_name
ORDER BY total_revenue DESC;
```

### 5️⃣ Total Hours Worked
```sql
SELECT SUM(hours) AS total_time FROM service_data;
```

### 6️⃣ Total Revenue
```sql
SELECT SUM(total_revenue) AS revenue FROM service_data;
```

### 7️⃣ Revenue Percentage Contribution by Department
```sql
SELECT
    department,
    SUM(total_revenue) AS department_revenue,
    (SUM(total_revenue) / (SELECT SUM(total_revenue) FROM service_data) * 100) AS revenue_percentage
FROM service_data
GROUP BY department;
```

### 8️⃣ Month-on-Month Revenue Increase
```sql
WITH monthly_revenue AS (
    SELECT
        FORMAT(service_date, 'yy-MM') AS month,
        SUM(total_revenue) AS revenue
    FROM service_data
    GROUP BY FORMAT(service_date, 'yy-MM')
),
revenue_comparison AS (
    SELECT
        month,
        revenue,
        LAG(revenue) OVER (ORDER BY month) AS previous_month_revenue
    FROM monthly_revenue
)
SELECT
    month,
    previous_month_revenue,
    ((revenue - previous_month_revenue) / previous_month_revenue) * 100 AS revenue_percentage_increase
FROM revenue_comparison
WHERE previous_month_revenue IS NOT NULL;
```

---
## 📌 DAX Measures for Power BI

### 1️⃣ Total Revenue
```DAX
Total Revenue = SUM(service_data[total_revenue])
```

### 2️⃣ Total Hours Worked
```DAX
Total Hours = SUM(service_data[hours])
```

### 3️⃣ Revenue by Region
```DAX
Revenue by Region = SUMX(VALUES(branch_data[region]), CALCULATE(SUM(service_data[total_revenue])))
```

### 4️⃣ Revenue by Department
```DAX
Revenue by Department = SUMX(VALUES(service_data[department]), CALCULATE(SUM(service_data[total_revenue])))
```

### 5️⃣ Top 5 Clients by Revenue
```DAX
Top 5 Clients =
VAR RankedClients =
    ADDCOLUMNS(
        SUMMARIZE(service_data, service_data[client_name], "Total Revenue", SUM(service_data[total_revenue])),
        "Rank", RANKX(ALL(service_data[client_name]), [Total Revenue], , DESC)
    )
RETURN
    FILTER(RankedClients, [Rank] <= 5)
```

### 6️⃣ Revenue Percentage Contribution by Department
```DAX
Revenue % by Department =
DIVIDE(
    SUM(service_data[total_revenue]),
    CALCULATE(SUM(service_data[total_revenue]), ALL(service_data)),
    0
) * 100
```

### 7️⃣ Month-on-Month Revenue Growth
```DAX
Revenue MoM Growth =
VAR PrevMonthRevenue =
    CALCULATE(SUM(service_data[total_revenue]), DATEADD(service_data[service_date], -1, MONTH))
RETURN
IF(NOT ISBLANK(PrevMonthRevenue), (SUM(service_data[total_revenue]) - PrevMonthRevenue) / PrevMonthRevenue, BLANK())
```

### 8️⃣ Cumulative Revenue (YTD)
```DAX
Cumulative Revenue =
CALCULATE(
    SUM(service_data[total_revenue]),
    DATESYTD(service_data[service_date])
)
```

---
## 📊 Dashboard Features
- **Total Revenue & Total Hours** displayed prominently.
- **Revenue Breakdown** by **Region, Department, and Client**.
- **Month-on-Month Revenue Growth** for tracking trends.
- **Top 5 Clients by Revenue** for identifying key contributors.
- **Revenue % by Department** to compare department-wise contributions.

---
## 🔥 How to Use
1. **Run the SQL queries** to extract the required data.
2. **Import data into Power BI**.
3. **Use the DAX measures** to create visuals and insights.
4. **Customize and enhance** as per business requirements.

---
## 🚀 Next Steps
- Add more granular **time-based revenue trends**.
- Incorporate **forecasting models** using DAX.
- Improve **data visuals and interactivity** in Power BI.

---
### 🎯 **Need Help?**
Feel free to reach out if you have any questions or need modifications! 🚀

