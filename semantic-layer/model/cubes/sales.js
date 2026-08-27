cube(`sales`, {
  sql: `SELECT * FROM FACT_SALES`,

  joins: {
    dim_date: {
      sql: `${CUBE}.date_key = ${dim_date.date_key}`,
      relationship: `belongsTo`
    },

    dim_region: {
      sql: `${CUBE}.region_key = ${dim_region.region_key}`,
      relationship: `belongsTo`
    },

    dim_customer: {
      sql: `${CUBE}.customer_key = ${dim_customer.customer_key}`,
      relationship: `belongsTo`
    },

    dim_product: {
      sql: `${CUBE}.product_key = ${dim_product.product_key}`,
      relationship: `belongsTo`
    }
  },

  measures: {
    revenue: {
      sql: `revenue`,
      type: `sum`
    },

    cost: {
      sql: `total_cost`,
      type: `sum`
    },

    profit: {
      sql: `${revenue} - ${cost}`,
      type: `number`
    },

    margin: {
      sql: `CASE WHEN ${revenue} > 0 THEN (${profit} * 1.0 / ${revenue}) ELSE 0 END`,
      type: `number`
    },
    churn: {
  sql: `CASE WHEN ${dim_customer.customer_type} = 'churned' THEN 1 ELSE 0 END`,
  type: `sum`
},

    count: {
      type: `count`
    }
  },

  dimensions: {
    order_id: {
      sql: `order_id`,
      type: `number`,
      primaryKey: true
    },

    sale_id: {
      sql: `sale_id`,
      type: `number`
    },

    sales_channel: {
      sql: `sales_channel`,
      type: `string`
    }
  }
});