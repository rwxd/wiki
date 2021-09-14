# Tee

With tee you it is possible to read from standard input and write to standard output and files (or commands).

## Usage

Log into file and stdout:  
`foo | tee output.file`

Append to a file:  
`foo | tee -a output.file`

Include stderr:  
`foo 2>&1 | tee output.file`  

`2>&1` redirects channel 2 (stderr/standard error) into channel 1 (stdout/standard output), such that both is written as stdout