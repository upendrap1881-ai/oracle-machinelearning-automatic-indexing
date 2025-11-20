CREATE OR REPLACE PROCEDURE ml_driven_auto_indexing AS
  v_prob NUMBER;
  v_speedup NUMBER;
BEGIN
  FOR c IN (SELECT 'CUSTOMER_ID' col FROM dual UNION ALL
            SELECT 'REGION' FROM dual UNION ALL
            SELECT 'STATUS' FROM dual UNION ALL
            SELECT 'ORDER_DATE' FROM dual) LOOP

    SELECT PREDICTION_PROBABILITY(AUTO_IDX_CLASSIFIER, 1 USING
             c.col AS candidate_columns,
             1 AS num_columns,
             500000 AS table_rows),
           PREDICTION(AUTO_IDX_REGRESSION USING
             c.col AS candidate_columns,
             1 AS num_columns,
             500000 AS table_rows)
    INTO v_prob, v_speedup FROM dual;

    IF v_prob > 0.82 AND v_speedup > 3 THEN
      BEGIN
        EXECUTE IMMEDIATE 'CREATE INDEX idx_ml_'||c.col||' ON orders('||c.col||')';
        DBMS_OUTPUT.PUT_LINE('CREATED index on '||c.col||' | Prob: '||ROUND(v_prob,3)||' | Speedup: '||ROUND(v_speedup,2)||'x');
      EXCEPTION WHEN OTHERS THEN NULL;
      END;
    END IF;
  END LOOP;
END;
/
