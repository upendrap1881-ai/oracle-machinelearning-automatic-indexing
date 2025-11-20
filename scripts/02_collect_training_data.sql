SET SERVEROUTPUT ON
DECLARE
  v_elapsed_before NUMBER;
  v_elapsed_after  NUMBER;
BEGIN
  FOR cols IN (
    SELECT 'CUSTOMER_ID' AS col FROM dual UNION ALL
    SELECT 'REGION' FROM dual UNION ALL
    SELECT 'ORDER_DATE' FROM dual UNION ALL
    SELECT 'STATUS' FROM dual UNION ALL
    SELECT 'PRODUCT_CATEGORY' FROM dual UNION ALL
    SELECT 'CUSTOMER_ID,REGION' FROM dual
  ) LOOP
    -- Baseline
    SELECT SUM(elapsed_time)/NULLIF(SUM(executions),0) INTO v_elapsed_before
    FROM v$sql WHERE sql_text LIKE '%ORDERS%' AND sql_text LIKE '%'||cols.col||'%';

    -- Create invisible index
    BEGIN
      EXECUTE IMMEDIATE 'CREATE INDEX idx_temp_'||REPLACE(cols.col,',','_')||
        ' ON orders('||cols.col||') INVISIBLE';
    EXCEPTION WHEN OTHERS THEN NULL;
    END;

    EXECUTE IMMEDIATE 'ALTER SYSTEM FLUSH SHARED_POOL';
    DBMS_STATS.GATHER_TABLE_STATS('MLINDEX','ORDERS');

    -- Re-run queries
    FOR i IN 1..10 LOOP
      EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM orders WHERE '||REPLACE(cols.col,',',' AND ')||' IS NOT NULL';
    END LOOP;

    -- After measurement
    SELECT SUM(elapsed_time)/NULLIF(SUM(executions),0) INTO v_elapsed_after
    FROM v$sql WHERE sql_text LIKE '%ORDERS%' AND sql_text LIKE '%'||cols.col||'%';

    INSERT INTO index_performance_log (
      candidate_columns, elapsed_before, elapsed_after,
      improvement_ratio, beneficial
    ) VALUES (
      cols.col,
      v_elapsed_before,
      v_elapsed_after,
      CASE WHEN v_elapsed_after > 0 THEN v_elapsed_before / v_elapsed_after ELSE 1 END,
      CASE WHEN v_elapsed_before / NULLIF(v_elapsed_after,0) > 2.5 THEN 1 ELSE 0 END
    );

    EXECUTE IMMEDIATE 'DROP INDEX idx_temp_'||REPLACE(cols.col,',','_') FORCE;
  END LOOP;
  COMMIT;
END;
/
