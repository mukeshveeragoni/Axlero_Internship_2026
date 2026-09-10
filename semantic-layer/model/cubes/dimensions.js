cube(`dim_date`, {
  sql: `SELECT * FROM DIM_DATE`,

  dimensions: {
    date_key: {
      sql: `date_key`,
      type: `number`,
      primaryKey: true
    },

    full_date: {
      sql: `full_date`,
      type: `string`
    },

    month_name: {
      sql: `month_name`,
      type: `string`
    },

    quarter: {
      sql: `quarter`,
      type: `string`
    }
  }
});


cube(`dim_region`, {
  sql: `SELECT * FROM DIM_REGION`,

  dimensions: {
    region_key: {
      sql: `region_key`,
      type: `number`,
      primaryKey: true
    },

    region_name: {
      sql: `region_name`,
      type: `string`
    },

    country: {
      sql: `country`,
      type: `string`
    },

    continent: {
      sql: `continent`,
      type: `string`
    }
  }
});


cube(`dim_customer`, {
  sql: `SELECT * FROM DIM_CUSTOMER`,

  dimensions: {
    customer_key: {
      sql: `customer_key`,
      type: `number`,
      primaryKey: true
    },

    customer_id: {
      sql: `customer_id`,
      type: `string`
    },

    customer_name: {
      sql: `customer_name`,
      type: `string`
    },

    customer_type: {
      sql: `customer_type`,
      type: `string`
    }
  }
});


cube(`dim_product`, {
  sql: `SELECT * FROM DIM_PRODUCT`,

  dimensions: {
    product_key: {
      sql: `product_key`,
      type: `number`,
      primaryKey: true
    },

    product_name: {
      sql: `product_name`,
      type: `string`
    },

    category: {
      sql: `category`,
      type: `string`
    },

    sub_category: {
      sql: `sub_category`,
      type: `string`
    }
  }
});