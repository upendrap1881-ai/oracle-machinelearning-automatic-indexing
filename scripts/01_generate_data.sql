-- Generate 500K realistic rows
BEGIN
  FOR i IN 1..500000 LOOP
    INSERT INTO orders (order_id, customer_id, order_date, status, amount, region, product_category)
    VALUES (
      i,
      TRUNC(DBMS_RANDOM.VALUE(1,10000)),
      SYSDATE - DBMS_RANDOM.VALUE(0,365),
      ELT(TRUNC(DBMS_RANDOM.VALUE(1,5)), 'NEW','SHIPPED','DELIVERED','CANCELLED','PENDING'),
      ROUND(DBMS_RANDOM.VALUE(10,5000),2),
      ELT(TRUNC(DBMS_RANDOM.VALUE(1,6)), 'North','South','East','West','Central','International'),
      ELT(TRUNC(DBMS_RANDOM.VALUE(1,9)), 'Electronics','Clothing','Books','Home','Toys','Sports','Beauty','Food','Other')
    );
    IF MOD(i,10000) = 0 THEN COMMIT; END IF;
  END LOOP;
  COMMIT;
END;
/

EXEC DBMS_STATS.GATHER_TABLE_STATS('MLINDEX','ORDERS');
