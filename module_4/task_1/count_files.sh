if [ $# -eq 0 ]; then
  echo "$PWD: $(find "$PWD" -type f | wc -l) files";
else
  echo ""
  echo "Counting..."
  echo ""
  for dir in "$@"; do
    echo "$dir: $(find $dir -type f | wc -l) files";
  done
fi
