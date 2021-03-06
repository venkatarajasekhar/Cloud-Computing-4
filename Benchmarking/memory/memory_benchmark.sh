if [ "$#" -lt 2 ]; then
	echo "Usage [iterations] [seconds per iteration]"
	exit 125
fi
make
./evaluate_memory $1 $2
gnuplot <<- EOF
	set autoscale
	set xlabel "Block Size (Bytes)"
	set ylabel "Throughput (MB/sec)"
	set term png
	set output "plot_by_blocksize.png"
	set title "Memory Copy Performance (1 thread)"
	plot "<(sed -n -e 1p -e 5p -e 9p  'result.csv')"  using 4:xticlabels(1) with linespoints title 'Sequential', "<(sed -n -e 2p -e 6p -e 10p 'result.csv')" using 4:xticlabels(1) with linespoints title 'Random'

	set xlabel "Block Size (Bytes)"
        set ylabel "Latency (MB/sec)"
        set output "latency_by_blocksize.png"
	set yrange [-0.01:]
        set title "Memory Copy Performance (1 thread)"
        plot "<(sed -n -e 1p -e 5p -e 9p  'result.csv')"  using 5:xticlabels(1) with linespoints title 'Sequential', "<(sed -n -e 2p -e 6p -e 10p 'result.csv')" using 5:xticlabels(1) with linespoints title 'Random'
	
	set autoscale
	set xlabel "Threads"
	set output "plot_by_threads.png"
	set title "Memory Copy Performance (Sequential)"
	plot "<(sed -n -e 1p -e 3p 'result.csv')"  using 4:xticlabels(2) with linespoints title '1B', "<(sed -n -e 5p -e 7p 'result.csv')" using 4:xticlabels(2) with linespoints title '1KB', "<(sed -n -e 9p -e 11p 'result.csv')" using 4:xticlabels(2) with linespoints title '1MB'

	set xlabel "Threads"
        set output "latency_by_threads.png"
        set title "Memory Copy Performance (Sequential)"
	set yrange [-0.01:]
        plot "<(sed -n -e 1p -e 3p 'result.csv')"  using 5:xticlabels(2) with linespoints title '1B', "<(sed -n -e 5p -e 7p 'result.csv')" using 5:xticlabels(2) with linespoints title '1KB', "<(sed -n -e 9p -e 11p 'result.csv')" using 5:xticlabels(2) with linespoints title '1MB'
EOF
