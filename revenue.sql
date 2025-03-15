select* from branch_data;
select * from service_data;


--Revenue by Region
select branch_data.region,round(sum(service_data.total_revenue),2) as total_revenue from service_data
join branch_data on
service_data.branch_id=branch_data.branch_id
group by branch_data.region
order by total_revenue desc;

--Revenue by Department
select service_data.department,sum(service_data.total_revenue) as total_revenue from service_data
group by service_data.department
order by total_revenue desc;

--Revenue by client
select service_data.client_name,sum(service_data.total_revenue) as total_revenue from service_data
group by service_data.client_name
order by total_revenue desc;

--total hours
select sum(hours)as total_time from service_data;

--total revenue
select sum(total_revenue)as revenue from service_data;

--Revenue per each department over overall revenue
SELECT 
    department, 
    SUM(total_revenue) AS department_revenue, 
    (SUM(total_revenue) / (SELECT SUM(total_revenue) FROM service_data) * 100) AS revenue_percentage
FROM service_data
GROUP BY department;

--Month on month revenue increase
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

