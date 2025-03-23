import pandas as pd
import matplotlib.pyplot as plt

# Read the CSV file
df = pd.read_csv('test2.csv')

# Strip whitespace from column names (in case there are any extra spaces)
df.columns = df.columns.str.strip()

# Remove the trailing 's' from the time_elapsed values and convert them to floats
df['time_elapsed'] = df['time_elapsed'].str.rstrip('s').astype(float)

# Create the plot with smaller markers
plt.figure(figsize=(10, 6))
plt.plot(df['senders'], df['time_elapsed'], marker='o', markersize=1, linestyle='-')
plt.xlabel('Senders')
plt.ylabel('Time Elapsed (s)')
plt.title('Senders vs. Time Elapsed')
plt.grid(True)

# Save the plot as a PNG file
plt.savefig('graph.png')
plt.close()

print("Graph saved as 'graph.png'")
