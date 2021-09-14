# Tee

## Usage

Log into file and stdout:  
`foo | tee output.file`

Append to a file:  
`foo | tee -a output.file`

Include stderr:  
`foo 2>&1 | tee output.file`  

`2>&1` redirects channel 2 (stderr/standard error) into channel 1 (stdout/standard output), such that both is written as stdout