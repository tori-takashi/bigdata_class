# Hadoop streaming
Hadoop streaming is a jar that enable to bridge among input, mapper, reducer and output, by using stdin and stdout.

we can download jar from MVN repository.

## ver.3.2
[hadoop streaming v3.2](https://mvnrepository.com/artifact/org.apache.hadoop/hadoop-streaming/3.2.0)

## other version
[hadoop streaming](https://mvnrepository.com/artifact/org.apache.hadoop/hadoop-streaming)

## how to use

1. download hadoop streaming v3.2
you're available to download script.
```
$ ./download_hadoopstreaming-3.2.sh
```

2. launch
```
$ ./invindex.sh
```

## details
Mapper and reducer uses python3 and it's declare at the top of **.py

Please refer to ./invindex.sh if you want to know the way to launch mapper and reducer with hadoop streaming.
