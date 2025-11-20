CREATE OR REPLACE VIEW index_perf_features AS
SELECT
  run_id,
  candidate_columns,
  improvement_ratio,
  beneficial,
  LENGTH(candidate_columns) - LENGTH(REPLACE(candidate_columns,',')) + 1 AS num_columns,
  (SELECT num_rows FROM user_tables WHERE table_name = 'ORDERS') AS table_rows
FROM index_performance_log;

BEGIN DBMS_DATA_MINING.DROP_MODEL('AUTO_IDX_CLASSIFIER', TRUE); END;
/

BEGIN
  DBMS_DATA_MINING.CREATE_MODEL(
    model_name => 'AUTO_IDX_CLASSIFIER',
    mining_function => DBMS_DATA_MINING.CLASSIFICATION,
    data_table_name => 'INDEX_PERF_FEATURES',
    case_id_column_name => 'RUN_ID',
    target_column_name => 'BENEFICIAL'
  );
END;
/

BEGIN DBMS_DATA_MINING.DROP_MODEL('AUTO_IDX_REGRESSION', TRUE); END;
/

BEGIN
  DBMS_DATA_MINING.CREATE_MODEL(
    model_name => 'AUTO_IDX_REGRESSION',
    mining_function => DBMS_DATA_MINING.REGRESSION,
    data_table_name => 'INDEX_PERF_FEATURES',
    case_id_column_name => 'RUN_ID',
    target_column_name => 'IMPROVEMENT_RATIO'
  );
END;
/
