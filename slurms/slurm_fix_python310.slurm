#!/bin/bash
#SBATCH --job-name=fix_python310
#SBATCH --output=slurms/slurm_outputs/fix_python310_output.txt
#SBATCH --error=slurms/slurm_outputs/fix_python310_error.txt
#SBATCH --time=00:10:00
#SBATCH --mem-per-cpu=2G
#SBATCH --cpus-per-task=1

# Fix Python 3.10 compatibility by replacing Self type hint imports
# This script modifies all training files to use typing_extensions.Self instead of typing.Self

echo "Starting Python 3.10 compatibility fix..."
echo "Working directory: $(pwd)"

# Define the base directory
BASE_DIR="/cluster/work/sebasrb/zeroth-trainings"

# Function to fix a file
fix_file() {
    local file=$1
    echo "Processing: $file"
    
    # Check if file contains 'from typing import Self'
    if grep -q "from typing import Self" "$file"; then
        # Replace 'from typing import Self' with 'from typing_extensions import Self'
        sed -i 's/from typing import Self/from typing_extensions import Self/g' "$file"
        echo "  ✓ Fixed import in $file"
    else
        echo "  - No changes needed in $file"
    fi
}

# Fix all training variant files
echo ""
echo "Fixing training_variants files..."
for file in "$BASE_DIR"/training_variants/train_walk*.py; do
    if [ -f "$file" ]; then
        fix_file "$file"
    fi
done

# Fix all training files
echo ""
echo "Fixing training files..."
for file in "$BASE_DIR"/training/train_*.py; do
    if [ -f "$file" ]; then
        fix_file "$file"
    fi
done

# Fix main train.py and train_old.py if they exist
echo ""
echo "Fixing main training files..."
if [ -f "$BASE_DIR/train.py" ]; then
    fix_file "$BASE_DIR/train.py"
fi
if [ -f "$BASE_DIR/train_old.py" ]; then
    fix_file "$BASE_DIR/train_old.py"
fi

echo ""
echo "Python 3.10 compatibility fix complete!"
echo "All files have been updated to use typing_extensions.Self"
