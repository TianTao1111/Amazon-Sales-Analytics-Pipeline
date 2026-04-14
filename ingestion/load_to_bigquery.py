import pandas as pd
from pathlib import Path
from google.cloud import bigquery

#Directory setting
THIS_DIR = Path(__file__).resolve().parent
PROJECT_ROOT = THIS_DIR.parent


RAW_PATH = PROJECT_ROOT/"data"/"raw"

# BigQuery setting
PROJECT_ID = "amazon-sales-490621"
DATASET_ID = "ecommerce"
TABLE_NAME = "raw_amazon_sales"

client = bigquery.Client(project=PROJECT_ID)


#Read data
df = pd.read_csv(RAW_PATH/"Amazon Sale Report.csv")

# Clean
df.columns = df.columns.str.lower().str.replace(" ", "_")

#Write into BigQuery
table_id = f"{PROJECT_ID}.{DATASET_ID}.{TABLE_NAME}"

job = client.load_table_from_dataframe(df,table_id)
job.result()

print(f"\n🎉 Loaded {len(df)} rows into {table_id}\n")