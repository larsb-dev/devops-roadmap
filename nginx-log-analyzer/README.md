# Nginx Log Analyzer

## Download log file

```bash
curl -O https://gist.githubusercontent.com/kamranahmedse/e66c3b9ea89a1a030d3b739eeeef22d0/raw/77fb3ac837a73c4f0206e78a236d885590b7ae35/nginx-access.log
```

## DRY Don't Repeaet Yourself

```bash
print_top() {
  local input="$1"

  echo "$input" | while read -r count value; do
    echo "$value - $count requests"
  done
}
```

- I print the top 5 requests three times based on different criteria
- A simple function avoids repeating the same code three times

## Filtering logic

```bash
awk '{print $7}' nginx-access.log | sort | uniq -c | sort -rn | head -5
```

- For each row, grab a column value, in this case the seventh
- List equal values one after another
- Count the rows for each set of equal values
- Sort the results numerical in descending order (largest at the top)
- Take the top five values
