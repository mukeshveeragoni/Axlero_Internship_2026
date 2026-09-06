/** @type{ import('@cubejs-backend/server-core').CreateOptions } */
module.exports = {
  driverFactory: () => {
    const SqliteDriver = require('@cubejs-backend/sqlite-driver');

    return new SqliteDriver({
      database: process.env.CUBEJS_DB_FILE
    });
  }
};