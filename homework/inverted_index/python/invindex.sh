#!/bin/bash

hadoop jar ./hadoop-streaming-3.2.0.jar \
	-input testfile.txt testfile2.txt \
	-output i \
	-mapper 'inverted_index_mapper.py' \
	-reducer 'inverted_index_reducer.py' \
	-file inverted_index_mapper.py \
	-file inverted_index_reducer.py \
	-file testfile.txt \
	-file testfile2.txt \
