print_top() {
  local input="$1"

  echo "$input" | while read -r count value; do
    echo "$value - $count requests"
  done
}

top_request_ips=$(awk '{print $1}' nginx-access.log | sort | uniq -c | sort -rn | head -5)

echo "Top 5 IP addresses with the most requests:"
print_top "$top_request_ips"
echo

top_request_paths=$(awk '{print $7}' nginx-access.log | sort | uniq -c | sort -rn | head -5)

echo "Top 5 most requested paths:"
print_top "$top_request_paths"
echo

top_status_codes=$(awk '{print $9}' nginx-access.log | grep '^[0-9]' | sort | uniq -c | sort -rn | head -5)

echo "Top 5 response status codes:"
print_top "$top_status_codes"
