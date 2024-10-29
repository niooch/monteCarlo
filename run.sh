#!/bin/bash

# Check for required arguments
if [[ $# -lt 3 ]]; then
    echo "Usage: $0 <k1> <k2> <function (f1|f2|f3)> <n_values (space-separated)>" >&2
    exit 1
fi

# Parse input arguments
k1=$1
k2=$2
func_type=$3
shift 3
n_values=("$@")

# Start total timer
total_start=$(date +%s)

# Compile the program using make
echo "Compiling program..." >&2
compile_start=$(date +%s)
if ! make; then
    echo "Compilation failed. Please check for errors in your source code." >&2
    exit 1
fi
compile_end=$(date +%s)
echo "Compilation completed in $((compile_end - compile_start)) seconds." >&2

# Set exact value for the function
case "$func_type" in
    "f1") exact_value=12 ;;
    "f2") exact_value=2 ;;
    "f3") exact_value=0.4 ;;
    *) echo "Unknown function type" >&2; exit 1 ;;
esac

# Function to run experiments and save mean results for a given k
run_experiment() {
    local k=$1
    local n=$2
    local results=()

    # Debug message for the start of an experiment
    echo "Running experiment for n=$n with k=$k repetitions..." >&2
    exp_start=$(date +%s)

    # Run the Monte Carlo simulation `k` times and collect results
    for ((i = 0; i < k; i++)); do
        result=$(./montecarlo "$k" "$n" "$func_type" | awk 'NR==2 {print $2}')
        results+=("$result")
    done

    # Calculate mean
    mean=$(echo "${results[@]}" | awk '{sum=0; for(i=1;i<=NF;i++) sum+=$i; print sum/NF}')
    # Output the data line: n, mean, and individual results (for the .dat file)
    echo "$n $mean ${results[@]}"

    # Debug message for the end of an experiment
    exp_end=$(date +%s)
    echo "Experiment for n=$n completed in $((exp_end - exp_start)) seconds." >&2
}

# Prepare data files for gnuplot
data_file_k1="${func_type}_data_k1.dat"
data_file_k2="${func_type}_data_k2.dat"
> "$data_file_k1"
> "$data_file_k2"

# Run experiments for each `n` and store results in separate files for k1 and k2
data_gen_start=$(date +%s)
for n in "${n_values[@]}"; do
    run_experiment "$k1" "$n" >> "$data_file_k1"
    run_experiment "$k2" "$n" >> "$data_file_k2"
done
data_gen_end=$(date +%s)
echo "Data generation completed in $((data_gen_end - data_gen_start)) seconds." >&2

# Generate plots with gnuplot
plot_start=$(date +%s)
for k in "$k1" "$k2"; do
    data_file="${func_type}_data_k${k}.dat"
    output_file="plot_${func_type}_k${k}.png"

    # Check if data file exists and has content
    if [[ ! -s "$data_file" ]]; then
        echo "Error: Data file $data_file is empty or missing." >&2
        exit 1
    fi

    echo "Generating plot for k=$k..." >&2

    gnuplot <<-EOF
        set title "Monte Carlo Integration for ${func_type} (k=${k})"
        set xlabel "n (Number of Points)"
        set ylabel "Approximate Integral"
        set key left
        set term pngcairo size 800,600
        set output "${output_file}"

        # Plot individual approximations as blue points, mean as red points, and exact value line
        plot "${data_file}" using 1:3 with points pointtype 7 pointsize 0.5 lc rgb "blue" title "Individual Approximations", \
             "${data_file}" using 1:2 with points pointtype 7 pointsize 1 lc rgb "red" title "Mean Approximation", \
             ${exact_value} with lines lc rgb "green" title "Exact Value"
EOF

    echo "Plot for k=$k saved as ${output_file}." >&2
done
plot_end=$(date +%s)
echo "Plot generation completed in $((plot_end - plot_start)) seconds." >&2

# End total timer
total_end=$(date +%s)
echo "Total script execution time: $((total_end - total_start)) seconds." >&2
