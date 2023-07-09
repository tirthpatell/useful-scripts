import pandas as pd
from datetime import datetime

# function to extract the starting time from time period
def extract_time(row):
    interval = row.split(' to ')
    start_time = interval[0].strip()
    return datetime.strptime(start_time, "%Y-%m-%d %H:%M") if start_time != '' else None

# import data from csv file
df = pd.read_csv('yourfile.csv')

# Extract the starting time and convert it to datetime
df[' Energy consumption time period'] = df[' Energy consumption time period'].apply(extract_time)

# Remove rows with None value in time period column
df = df.dropna(subset=[' Energy consumption time period'])

# Filter the rows for time between 15:00 to 20:00
filtered_df = df.set_index(' Energy consumption time period').between_time('15:00', '20:00').reset_index()

# Calculate the sums
total_usage = df['Usage(Real energy in kilowatt-hours)'].sum()
usage_sum = filtered_df['Usage(Real energy in kilowatt-hours)'].sum()

# Calculate the difference
diff = total_usage - usage_sum

# Calculate the cost for each plan
plan_one_cost = total_usage * 0.113926
plan_two_cost = usage_sum * 0.199717 + diff * 0.076105 

# Print the usage, the difference, and the cost under each plan in a formatted style
print('------------------------------------------------')
print('             Energy Consumption Report          ')
print('------------------------------------------------')
print(f"Total Usage: {total_usage:.2f} kWh")
print(f"Peak Hours Usage (15:00 - 20:00): {usage_sum:.2f} kWh")
print(f"Off-Peak Hours Usage: {diff:.2f} kWh")
print('------------------------------------------------')
print('                      Costs                     ')
print('------------------------------------------------')
print(f"Cost under Plan One (flat rate): ${plan_one_cost:.2f}")
print(f"Cost under Plan Two (variable rate): ${plan_two_cost:.2f}")
print('------------------------------------------------')
