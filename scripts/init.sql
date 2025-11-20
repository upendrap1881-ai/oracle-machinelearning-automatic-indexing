ALTER SESSION SET CONTAINER = FREEPDB1;

CREATE USER mlindex IDENTIFIED BY Oracle123;
GRANT DBA TO mlindex;
GRANT EXECUTE ON DBMS_DATA_MINING TO mlindex;
GRANT EXECUTE ON DBMS_AUTO_INDEX TO mlindex;

ALTER SESSION SET CURRENT_SCHEMA = MLINDEX;

CREATE TABLE orders (
  order_id         NUMBER PRIMARY KEY,
  customer_id      NUMBER,
  order_date       DATE,
  status           VARCHAR2(20),
  amount           NUMBER(10,2),
  region           VARCHAR2(50),
  product_category VARCHAR2(100)
);

CREATE TABLE index_performance_log (
  run_id            NUMBER GENERATED ALWAYS AS IDENTITY,
  candidate_columns VARCHAR2(1000),
  elapsed_before    NUMBER,
  elapsed_after     NUMBER,
  improvement_ratio NUMBER,
  beneficial        NUMBER(1),
  collected_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
