# import pandas as pd

# df = pd.read_csv('data/raw/sales.csv', encoding='latin1')
# print("Initial data loaded successfully!")

# df.dropna(inplace=True)

# # robust date parsing with error handling (If some rows have mixed formats or bad values)
# df['Order Date'] = pd.to_datetime(
#     df['Order Date'],
#     format='%d/%m/%Y',
#     errors='coerce'
# )

# # remove invalid rows
# df = df.dropna(subset=['Order Date']) 

# df['Year'] = df['Order Date'].dt.year
# df['Month'] = df['Order Date'].dt.month

# df.to_csv('data/processed/cleaned_sales.csv', index=False)

# print("Data cleaned and saved successfully!")


#--------------- Updated Version with more robust date parsing and error handling ----------------

import pandas as pd

# Load raw data
df = pd.read_csv('data/raw/sales.csv', encoding='latin1', low_memory=False)
print(len(df))
print(df.head())
print(df.dtypes)

# Clean text
def clean_text(x):
    if isinstance(x, str):
        return x.encode('utf-8', 'ignore').decode('utf-8').strip()
    return x

df = df.apply(lambda col: col.map(clean_text))

# Standardize column names
df.columns = [col.strip().replace(' ', '_').lower() for col in df.columns]

# ✅ FIX DATE FORMAT (CRITICAL)
df['order_date'] = pd.to_datetime(df['order_date'], errors='coerce')
df['ship_date'] = pd.to_datetime(df['ship_date'], errors='coerce')

# Convert to MySQL format
df['order_date'] = df['order_date'].dt.strftime('%Y-%m-%d')
df['ship_date'] = df['ship_date'].dt.strftime('%Y-%m-%d')

# ✅ FIX POSTAL CODE (IMPORTANT)
df['postal_code'] = df['postal_code'].fillna(0).astype(int)

# ✅ Ensure sales is numeric
df['sales'] = pd.to_numeric(df['sales'], errors='coerce')

# Check before Deleting bad rows
print(df.isnull().sum()) # Check for missing values after cleaning

# Drop bad rows
#  df = df.dropna()                               #Delete ANY row that has a missing value in ANY column
df.dropna(subset=['order_date'], inplace=True)  # Delete rows with missing order dates

# Save clean file (MySQL-safe)
df.to_csv('data/processed/cleaned_sales.csv', index=False, encoding='utf-8')

print("Clean dataset ready")

