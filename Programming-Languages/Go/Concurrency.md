# Concurrency in Go

## Mutex

Safely access data across multiple goroutines

```go
func doIOOnFile(path string, mu *mutex){
	mu.Lock()
	defer mu.Unlock()
	// I/O stuff
}
```
