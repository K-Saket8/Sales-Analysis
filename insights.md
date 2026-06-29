# Insights - Business Analysis

## 📋 Executive Summary

This report presents key business insights derived from the sales dataset using SQL. The analysis focuses on identifying revenue drivers, customer purchasing behavior, and market concentration to better understand the factors influencing business performance.

The findings reveal that revenue is highly concentrated across a small number of countries and customer segments. While the United States generates revenue through a large customer base, Australia achieves comparable revenue through significantly higher-value purchases. Customer segmentation further shows that spending is heavily concentrated among a relatively small proportion of customers, indicating that product mix and purchasing behavior have a greater impact on revenue than purchase frequency.


## Q1: Revenue Concentration by Country

The customer base spans 7 countries, but revenue is heavily concentrated in just two: 


| Country   | Revenue Share | Driver               |
| --------- | ------------: | -------------------- |
| US        |        31.21% | Customer volume      |
| Australia |        30.86% | High-value purchases |
| UK        |        11.55% | Moderate volume      |

The remaining 4 countries together account for roughly 26% of revenue.

This concentration is driven by two different mechanisms depending on 
the country:

- **United States** leads in customer count (**40.48%** of all customers) 
  but its revenue share (**31.21%**) is proportionally lower . Its revenue 
  contribution is driven by **customer volume**, not high spend per 
  customer.
- **Australia** has far fewer customers (**19.43%** of the base) but 
  contributes nearly as much revenue (**30.86%**) as the US - driven by a 
  significantly higher **average sale value per item and per order** 
  (avg. revenue per order: ~1,348 vs. ~993 for the US).

  This traces back 
  to Australian customers purchasing proportionally more from the 
  high-value **Bikes** category (avg. ~$1,800–2,160 per item) rather 
  than lower-cost Accessories/Clothing.

**Key Insight:** revenue concentration in the US reflects market size; 
revenue concentration in Australia reflects purchase value. Both 
markets are critical to total revenue, but for different underlying 
reasons.

---

## Q2: Customer Spend Segmentation

Customers were split into three equal-sized tiers 
- Low 
- Medium 
- High
by total spend. 

Despite each tier containing roughly the same number of 
customers (~6,161 each), revenue contribution is dramatically uneven:

| Tier   | Customers | Revenue Share | Avg Spend/Customer | Avg Orders/Customer | Avg Revenue/Order |
|--------|-----------|----------------|---------------------|------------------------|---------------------|
| High   | 6,161     | 87.48%         | $4,168.49           | 1.93                   | $2,159.06           |
| Medium | 6,161     | 11.77%         | $560.94             | 1.49                   | $376.38             |
| Low    | 6,162     | 0.74%          | $35.42              | 1.07                   | $33.16              |

The top third of customers generates **87.5% of total revenue**, while 
the bottom third contributes under 1%.

Critically, this gap is **not** driven by purchase frequency- High-tier 
customers order only ~80% more often than Low-tier customers (1.93 vs. 
1.07 orders on average). The gap is driven almost entirely by **order 
value**: High-tier customers spend roughly **65x more per order** than 
Low-tier customers ($2,159 vs. $33).

**Key Insight:** customer value is concentrated through what customers buy, 
not how often they buy. This points to product mix (premium vs. 
low-cost items) as the likely driver, and suggests retention efforts 
should prioritize the High tier, while the Low tier may represent 
low-engagement, one-time buyers worth a separate investigation.