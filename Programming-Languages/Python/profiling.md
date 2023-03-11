# Profiling in Python

## Generate data

### Pythons integrated `cProfile`

```bash
python3 -m cProfile -o profile.pstats -m my_module <args>
```

### Yappi

[Yappi](https://github.com/sumerc/yappi) supports asynchronous and multithreaded profiling, which is not supported by the built-in profiler.

```bash
pip3 install -U yappi
```

```python3
import yappi
from my_module import my_function

yappi.start()

my_function()

yappi.stop()

yappi.get_func_stats().save("profile.pstats", type="pstats")
```

## Visualisation

### gprof2dot (Dot Diagram, SVG)

Transform a `.pstats` file with [gprof2dot](https://github.com/jrfonseca/gprof2dot) into a dot graph as a svg file.

```bash
pip3 install -U gprof2dot
```

```bash
gprof2dot -f pstats profile.pstats | dot -Tsvg -o profile.svg
```

### Snakeviz (Interactive)

[Snakeviz](https://github.com/jiffyclub/snakeviz) is a web-based profiling tool which allows users to analyse their code by filtering data by module,
function and file, and sorting it according to different criteria such as the number of calls or cumulative time spent in a function.

```bash
pip3 install -U snakeviz
```

```bash
snakeviz profile.pstats
```

### flamegraph (SVG)

Flame graphs are visual tools that show how much time is spent in each function call.
The width of each bar in the graph represents the amount of time spent in that function,
with wider bars indicating more time spent and narrower bars indicating less time.
The main function is at the bottom, and the subfunctions are stacked vertically on top.

```bash
pip3 install -U flameprof
```

```bash
flameprof profile.pstats > profile.svg
```
