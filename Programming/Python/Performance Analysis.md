# Profiler

```bash
python3 -m cProfile -o log.pstats -m my_module
```

## Visualisation

### gprof2dot (Dot Diagram)

```bash
sudo pacman -S graphviz
pip3 install gprof2dot
```

```bash
gprof2dot -f pstats log.pstats | dot -Tsvg -o log.svg
```
