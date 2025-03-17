import re
import matplotlib.pyplot as plt

# Function to parse the raw text file
def parse_benchmark_data(file_path):
    factors_data = []
    factors_naive_data = []
    
    with open(file_path, 'r') as file:
        for line in file:
            match_factors = re.match(r"^\│ factors_(\d+)\s+\│\s+([\d_\.]+)ns", line)
            match_factors_naive = re.match(r"^\│ factors_naive_(\d+)\s+\│\s+([\d_\.]+)ns", line)
            
            if match_factors:
                number = int(match_factors.group(1))
                time_ns = float(match_factors.group(2).replace("_", ""))
                factors_data.append((number, time_ns))
            elif match_factors_naive:
                number = int(match_factors_naive.group(1))
                time_ns = float(match_factors_naive.group(2).replace("_", ""))
                factors_naive_data.append((number, time_ns))
    
    return factors_data, factors_naive_data

# Plotting function
def plot_benchmark_data(factors_data, factors_naive_data):
    factors_x, factors_y = zip(*factors_data)
    factors_naive_x, factors_naive_y = zip(*factors_naive_data)
    
    plt.figure(figsize=(12, 6))
    plt.plot(factors_x, factors_y, label='factors', marker='o', linestyle='None')
    plt.plot(factors_naive_x, factors_naive_y, label='factors_naive', marker='x', linestyle='None')
    
    plt.title('Benchmark Evaluation Time for Factors Methods')
    plt.xlabel('Number')
    plt.ylabel('Time (ns)')
    plt.legend()
    plt.grid(True)
    
    plt.show()

file_path = 'final_benches.txt'
factors_data, factors_naive_data = parse_benchmark_data(file_path)

plot_benchmark_data(factors_data, factors_naive_data)
