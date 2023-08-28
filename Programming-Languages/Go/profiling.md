# Profiling in Go

## CPU Profiling

### Generate data

```go
import (
    "runtime/pprof"
)

func main {
    f, err := os.Create("my-tool.prof")
    if err != nil {
        log.Fatal(err)
    }
    pprof.StartCPUProfile(f)
    defer pprof.StopCPUProfile()

    // CPU Intensive code
}
```

### View data

```bash
go tool pprof my-tool.prof
```

```bash
# view top 10 functions
(pprof) top

# view top 20 functions
(pprof) top20

# view top 10 functions in a graph
(pprof) top --cum

# Visualize graph through web browser
(pprof) web

# Output graph as a svg
(pprof) svg
```

## Memory Profiling

Go comes with a built-in profiling tool called pprof that can provide detailed information about your application's runtime memory usage.

### Generate data

```go
import _ "net/http/pprof"
```

Then, add the following code to start a new HTTP server that will serve the pprof endpoints:

```go
go func() {
    log.Println(http.ListenAndServe("localhost:6060", nil))
}()
```

With the above setup, you can access various profiling data by navigating to http://localhost:6060/debug/pprof/ while your application is running. For memory-related insights, http://localhost:6060/debug/pprof/heap is of particular interest.

### Capture Heap Dump

Once you have pprof set up and your application is running:

Allow your application to run until you suspect a memory leak.  
Capture a heap profile by executing:

```bash
curl -s http://localhost:6060/debug/pprof/heap -o mem.pprof
```

### Analyze data

```bash
go tool pprof mem.pprof
```

* Use the top command to get an overview of the functions consuming the most memory.
* To see detailed memory allocations for a specific function, use the list command followed by the function name.
* For a visual representation, web or svg commands can be used to generate graphs showcasing memory allocations.
