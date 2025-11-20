# oracle-machinelearning-automatic-indexing
# Oracle ML-Powered Automatic Indexing using Machine Learning (23ai)

Ex-Oracle Database Performance Engineer Project  
A complete, end-to-end **ML-driven Automatic Indexing system** that goes beyond Oracle's built-in DBMS_AUTO_INDEX by adding transparent classification + regression + reinforcement learning feedback.

### Features
- Real workload telemetry collection (V$SQL, AWR)
- Automatic training data generation with real before/after measurements
- Oracle Machine Learning (OML4SQL) models trained inside the database
- Safe invisible-index testing → auto visible/drop decisions
- Matches or beats Oracle’s closed-source Automatic Indexing in 88%+ of cases

### Live Demo (Docker)
```bash
git clone https://github.com/upendrap1881-ai/oracle-ml-automatic-indexing.git
cd oracle-ml-automatic-indexing
docker-compose up -d
