#!/bin/bash

# Check input arguments
if [ $# -lt 3 ]; then
    echo "Usage: $0 k function_type n1 [n2 ...]"
    exit 1
fi

k=$1
function_type=$2
shift 2
n_values=("$@")

# Start overall timing
start_time=$(date +%s)

echo "Starting the Monte Carlo integration script..."
echo "k = $k"
echo "Function type = $function_type"
echo "n values = ${n_values[@]}"

# Compile the program
echo "Compiling the program..."
make clean
make
if [ $? -ne 0 ]; then
    echo "Compilation failed."
    exit 1
fi
echo "Compilation finished."

# Prepare data files
data_points_file="data_points.dat"
mean_values_file="mean_values.dat"
rm -f $data_points_file $mean_values_file

# Counter for progress indicator
total_n=${#n_values[@]}
current_n=1

for n in "${n_values[@]}"; do
    echo "Processing n=$n ($current_n of $total_n)..."
    temp_file="temp_$n.dat"

    # Start timing for this n
    n_start_time=$(date +%s)

    # Run the Monte Carlo program
    ./montecarlo $k $n $function_type > $temp_file

    # Check if execution was successful
    if [ $? -ne 0 ]; then
        echo "Execution failed for n=$n."
        exit 1
    fi

    # Extract calka values
    grep -v '^#' $temp_file | awk 'NF==2 {print $1, $2}' >> $data_points_file

    # Extract mean value
    mean_line=$(grep -v '^#' $temp_file | awk 'NF==3 {print $1, $2}')
    echo $mean_line >> $mean_values_file

    rm $temp_file

    # End timing for this n
    n_end_time=$(date +%s)
    n_duration=$((n_end_time - n_start_time))
    echo "Finished n=$n in $n_duration seconds."

    current_n=$((current_n + 1))
done

# Determine exact value (dokladnaWartosc)
case $function_type in
    f1)
        dokladnaWartosc=12
        ;;
    f2)
        dokladnaWartosc=2
        ;;
    f3)
    dokladnaWartosc=0.421875
        ;;
    pi)
        dokladnaWartosc=3.1415926536
        ;;
    *)
        echo "Invalid function type: $function_type"
        exit 1
        ;;
esac

# Prepare gnuplot script
echo "Preparing gnuplot script..."
gnuplot_script="plot.gnuplot"

# Define the output plot filename
plot_filename="plot_${function_type}_${k}.png"

cat > $gnuplot_script << EOF
set terminal png size 800,600
set output '$plot_filename'
set xlabel 'n'
set ylabel 'Wynik calkowania'
set title 'Monte Carlo calkowanie (fukncja: $function_type, k: $k)'
set key left top
set style line 1 lc rgb 'blue' pt 7 ps 0.5
set style line 2 lc rgb 'red' pt 7 ps 1.5
set style line 3 lc rgb 'green' lt 1 lw 2

plot \
    '$data_points_file' using 1:2 notitle with points ls 1, \
    '$mean_values_file' using 1:2 title 'srednie wartosci' with points ls 2, \
    $dokladnaWartosc title 'dokladnaWartosc' with lines ls 3
EOF

# Run gnuplot
echo "Generating plot with gnuplot..."
gnuplot $gnuplot_script
if [ $? -ne 0 ]; then
    echo "Gnuplot failed."
    exit 1
fi
echo "Plot generated as $plot_filename."

# Clean up temporary files
echo "Cleaning up temporary files..."
rm $data_points_file $mean_values_file $gnuplot_script

# End overall timing
end_time=$(date +%s)
total_duration=$((end_time - start_time))
echo "Script completed in $total_duration seconds."
