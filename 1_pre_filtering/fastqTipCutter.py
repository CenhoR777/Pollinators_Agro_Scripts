#!/usr/bin/env python3
# Cuts extra quality scores when quality score alength and DNA sequence length dont match.
import gzip
import sys

with gzip.open(sys.argv[1], "rt") as infile:
    while True:
        header = infile.readline()
        sequence = infile.readline()
        _ = infile.readline()
        qual = infile.readline()
        if len(qual) == len(sequence):
            fq = f"{header}{sequence}+\n{qual}"
            if fq != "+\n":
                print(fq, end="")
            else:
                break
        elif len(qual) < len(sequence):
            nsequence = sequence[:len(qual)-1]
            fq = f"{header}{nsequence}\n+\n{qual}"
            if fq != "+\n":
                print(fq, end="")
            else:
                break
        else:
            nqual = qual[:len(sequence)-1]
            fq = f"{header}{sequence}+\n{nqual}\n"
            if fq != "+\n":
                print(fq, end="")
            else:
                break
