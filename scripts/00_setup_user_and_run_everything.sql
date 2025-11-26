-- 00_setup_user_and_run_everything.sql
WHENEVER SQLERROR EXIT FAILURE

ALTER SESSION SET CONTAINER = FREEPDB1;

-- Create user if not exists
BEGIN
  EXECUTE IMMEDIATE 'DROP USER mlindex CASCADE';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

CREATE USER mlindex IDENTIFIED BY Oracle123;
ALTER USER mlindex QUOTA UNLIMITED ON USERS;
GRANT DBA TO mlindex;
GRANT EXECUTE ON DBMS_DATA_MINING TO mlindex;

-- Switch to mlindex and run everything
CONNECT mlindex/Oracle123@//localhost:1521/FREEPDB1

-- Now run all your scripts in correct order
@@/docker-entrypoint-initdb.d/init.sql
@@/docker-entrypoint-initdb.d/01_generate_data.sql
@@/docker-entrypoint-initdb.d/02_collect_training_data.sql
@@/docker-entrypoint-initdb.d/03_train_models.sql
@@/docker-entrypoint-initdb.d/04_ml_auto_index_procedure.sql

EXEC DBMS_OUTPUT.PUT_LINE('ML Automatic Indexing Project Ready!');
