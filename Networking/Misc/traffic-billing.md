# Traffic Billing

## 95th Percentile Billing

The 95th percentile is a commonly used statistical measure to discard the top 5% of the highest values in a dataset. In network traffic calculation, it's a method used to determine the bandwidth billing rate, highlighting the regular usage while excluding rare usage spikes.

### How it works

- Every 5 minutes, the traffic flow rate (usually in bits per second) is measured.
- These values are then stored and sorted from lowest to highest over a month.
- The top 5% of the data points (the highest values) are discarded.
- The highest remaining value is the 95th percentile, and this rate is used as the billing rate for the entire month.

### Advantages

- Fairness: It does not penalize customers for infrequent spikes in traffic.
- Predictability: Customers have a more consistent billing rate from month to month.
- Encourages Efficient Use: Users can manage their bandwidth and understand their regular usage without the fear of occasional spikes in traffic inflating their bills.

### Disadvantages

- Potentially Confusing: Those unfamiliar with the method may find their billing unpredictable initially.
- Not Reflective of Total Volume: It doesn't bill based on the total amount of data transferred, only the regular rate of transfer.

### Example

```python3
def calculate_95th_percentile(data):
    data.sort()  # Step 1: Sort the data
    index = 0.95 * len(data)  # Step 2: Determine the 95th percentile index
    
    # Step 3: Get the value
    if index.is_integer():
        return data[int(index)-1]  # Python indices are 0-based
    else:
        return data[int(round(index))-1]

# Example data: Traffic measurements (in Mbps) every 5 minutes for a day (288 measurements for 24 hours)
traffic_data = [random.randint(50, 200) for _ in range(288)]  # Random traffic data between 50 Mbps and 200 Mbps

percentile_value = calculate_95th_percentile(traffic_data)
print(f"95th Percentile Value: {percentile_value} Mbps")
```
